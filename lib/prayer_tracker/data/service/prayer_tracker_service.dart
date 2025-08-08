import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/prayer_completion.dart';

class PrayerTrackerService {
  static const String _completionsBoxName = 'prayer_completions';
  static const String _streakBoxName = 'prayer_streak';

  Box<PrayerCompletion>? _completionsBox;
  Box<PrayerStreak>? _streakBox;

  // Singleton pattern
  static final PrayerTrackerService _instance =
      PrayerTrackerService._internal();
  factory PrayerTrackerService() => _instance;
  PrayerTrackerService._internal();

  Future<void> initialize() async {
    if (!Hive.isBoxOpen(_completionsBoxName)) {
      _completionsBox = await Hive.openBox<PrayerCompletion>(
        _completionsBoxName,
      );
    } else {
      _completionsBox = Hive.box<PrayerCompletion>(_completionsBoxName);
    }

    if (!Hive.isBoxOpen(_streakBoxName)) {
      _streakBox = await Hive.openBox<PrayerStreak>(_streakBoxName);
    } else {
      _streakBox = Hive.box<PrayerStreak>(_streakBoxName);
    }

    // Initialize streak if doesn't exist
    if (_streakBox!.isEmpty) {
      await _streakBox!.put('main', PrayerStreak.initial());
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Get today's completion status
  Future<PrayerCompletion> getTodaysCompletion() async {
    final today = _formatDate(DateTime.now());
    final completion = _completionsBox!.get(today);

    if (completion != null) {
      return completion;
    }

    // Create new completion for today
    final newCompletion = PrayerCompletion(
      date: today,
      completions: {for (final prayer in PrayerType.values) prayer: false},
      createdAt: DateTime.now(),
    );

    await _completionsBox!.put(today, newCompletion);
    return newCompletion;
  }

  // Mark a specific prayer as completed/uncompleted
  Future<void> togglePrayerCompletion(PrayerType prayer) async {
    final todaysCompletion = await getTodaysCompletion();
    final currentStatus = todaysCompletion.completions[prayer] ?? false;

    final updatedCompletions = Map<PrayerType, bool>.from(
      todaysCompletion.completions,
    );
    updatedCompletions[prayer] = !currentStatus;

    final updatedCompletion = todaysCompletion.copyWith(
      completions: updatedCompletions,
      updatedAt: DateTime.now(),
    );

    await _completionsBox!.put(todaysCompletion.date, updatedCompletion);

    // Update streak if day became complete
    if (updatedCompletion.isComplete && !todaysCompletion.isComplete) {
      await _updateStreakForCompletion();
    } else if (!updatedCompletion.isComplete && todaysCompletion.isComplete) {
      await _updateStreakForIncompletion();
    }
  }

  // Get completion for specific date
  Future<PrayerCompletion?> getCompletionForDate(DateTime date) async {
    final dateStr = _formatDate(date);
    return _completionsBox!.get(dateStr);
  }

  // Get completions for date range
  Future<List<PrayerCompletion>> getCompletionsForRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final completions = <PrayerCompletion>[];

    for (
      DateTime date = startDate;
      date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
      date = date.add(const Duration(days: 1))
    ) {
      final completion = await getCompletionForDate(date);
      if (completion != null) {
        completions.add(completion);
      }
    }

    return completions;
  }

  // Get current streak info
  Future<PrayerStreak> getStreak() async {
    return _streakBox!.get('main') ?? PrayerStreak.initial();
  }

  // Update streak when a day is completed
  Future<void> _updateStreakForCompletion() async {
    final currentStreak = await getStreak();
    final today = _formatDate(DateTime.now());
    final yesterday = _formatDate(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    int newCurrentStreak;

    // If yesterday was completed, extend streak
    if (currentStreak.lastCompletionDate == yesterday) {
      newCurrentStreak = currentStreak.currentStreak + 1;
    } else {
      // Start new streak
      newCurrentStreak = 1;
    }

    final newLongestStreak = newCurrentStreak > currentStreak.longestStreak
        ? newCurrentStreak
        : currentStreak.longestStreak;

    final updatedStreak = currentStreak.copyWith(
      currentStreak: newCurrentStreak,
      longestStreak: newLongestStreak,
      lastCompletionDate: today,
      updatedAt: DateTime.now(),
      totalCompleteDays: currentStreak.totalCompleteDays + 1,
    );

    await _streakBox!.put('main', updatedStreak);
  }

  // Update streak when a day becomes incomplete
  Future<void> _updateStreakForIncompletion() async {
    final currentStreak = await getStreak();
    final today = _formatDate(DateTime.now());

    // If today was the last completion date, break the streak
    if (currentStreak.lastCompletionDate == today) {
      final updatedStreak = currentStreak.copyWith(
        currentStreak: 0,
        lastCompletionDate: null,
        updatedAt: DateTime.now(),
        totalCompleteDays: currentStreak.totalCompleteDays - 1,
      );

      await _streakBox!.put('main', updatedStreak);
    }
  }

  // Reset daily completions (called at midnight)
  Future<void> resetDailyCompletions() async {
    // This method can be called to clean up old data or perform daily maintenance
    // For now, we just ensure streak is correctly calculated
    await _recalculateStreak();
  }

  // Recalculate streak from scratch (useful for data integrity)
  Future<void> _recalculateStreak() async {
    final now = DateTime.now();
    int currentStreak = 0;
    int longestStreak = 0;
    int totalCompleteDays = 0;
    String? lastCompletionDate;

    // Go back up to 365 days to calculate streaks
    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      final completion = await getCompletionForDate(date);

      if (completion?.isComplete == true) {
        totalCompleteDays++;
        if (i == 0) {
          // Today is complete
          currentStreak = 1;
          lastCompletionDate = _formatDate(date);

          // Count backward to find streak length
          for (int j = 1; j < 365; j++) {
            final prevDate = now.subtract(Duration(days: j));
            final prevCompletion = await getCompletionForDate(prevDate);

            if (prevCompletion?.isComplete == true) {
              currentStreak++;
            } else {
              break;
            }
          }
        }

        // Update longest streak
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      }
    }

    final updatedStreak = PrayerStreak(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastCompletionDate: lastCompletionDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      totalCompleteDays: totalCompleteDays,
    );

    await _streakBox!.put('main', updatedStreak);
  }

  // Get weekly statistics
  Future<Map<String, dynamic>> getWeeklyStats() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final weekCompletions = await getCompletionsForRange(weekStart, weekEnd);

    final completeDays = weekCompletions.where((c) => c.isComplete).length;
    final totalPrayers = weekCompletions.fold<int>(
      0,
      (sum, c) => sum + c.completedCount,
    );
    final possiblePrayers = weekCompletions.length * 5;

    return {
      'completeDays': completeDays,
      'totalPrayers': totalPrayers,
      'possiblePrayers': possiblePrayers,
      'completionRate': possiblePrayers > 0
          ? totalPrayers / possiblePrayers
          : 0.0,
    };
  }

  // Get monthly statistics
  Future<Map<String, dynamic>> getMonthlyStats() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    final monthCompletions = await getCompletionsForRange(monthStart, monthEnd);

    final completeDays = monthCompletions.where((c) => c.isComplete).length;
    final totalPrayers = monthCompletions.fold<int>(
      0,
      (sum, c) => sum + c.completedCount,
    );
    final possiblePrayers = monthCompletions.length * 5;

    return {
      'completeDays': completeDays,
      'totalPrayers': totalPrayers,
      'possiblePrayers': possiblePrayers,
      'completionRate': possiblePrayers > 0
          ? totalPrayers / possiblePrayers
          : 0.0,
    };
  }

  Future<void> dispose() async {
    await _completionsBox?.close();
    await _streakBox?.close();
  }
}
