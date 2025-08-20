import '../../data/service/prayer_tracker_service.dart';
import 'package:bloc/bloc.dart';
import '../../data/models/prayer_completion.dart';
import 'prayer_tracker_state.dart';

class PrayerTrackerCubit extends Cubit<PrayerTrackerState> {
  final PrayerTrackerService _prayerTrackerService;

  PrayerTrackerCubit({required PrayerTrackerService prayerTrackerService})
    : _prayerTrackerService = prayerTrackerService,
      super(PrayerTrackerInitial());

  Future<void> initialize() async {
    try {
      emit(PrayerTrackerLoading());

      await _prayerTrackerService.initialize();
      await loadData();
    } catch (e) {
      emit(
        PrayerTrackerError(
          message: 'Failed to initialize prayer tracker: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> loadData() async {
    try {
      emit(PrayerTrackerLoading());

      final todaysCompletion = await _prayerTrackerService
          .getTodaysCompletion();
      final streak = await _prayerTrackerService.getStreak();
      final weeklyStats = await _prayerTrackerService.getWeeklyStats();
      final monthlyStats = await _prayerTrackerService.getMonthlyStats();

      emit(
        PrayerTrackerLoaded(
          todaysCompletion: todaysCompletion,
          streak: streak,
          weeklyStats: weeklyStats,
          monthlyStats: monthlyStats,
        ),
      );
    } catch (e) {
      emit(
        PrayerTrackerError(
          message: 'Failed to load prayer data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> togglePrayerCompletion(PrayerType prayer) async {
    final currentState = state;
    if (currentState is! PrayerTrackerLoaded) return;

    try {
      // Optimistically update UI
      final currentCompletions = Map<PrayerType, bool>.from(
        currentState.todaysCompletion.completions,
      );
      currentCompletions[prayer] = !(currentCompletions[prayer] ?? false);

      final optimisticCompletion = currentState.todaysCompletion.copyWith(
        completions: currentCompletions,
        updatedAt: DateTime.now(),
      );

      emit(currentState.copyWith(todaysCompletion: optimisticCompletion));

      // Perform actual update
      await _prayerTrackerService.togglePrayerCompletion(prayer);

      // Reload data to get updated streak and stats
      await loadData();
    } catch (e) {
      // Revert on error
      emit(currentState);
      emit(
        PrayerTrackerError(message: 'Failed to update prayer: ${e.toString()}'),
      );

      // Reload original data
      await loadData();
    }
  }

  Future<void> resetDaily() async {
    try {
      await _prayerTrackerService.resetDailyCompletions();
      await loadData();
    } catch (e) {
      emit(
        PrayerTrackerError(
          message: 'Failed to reset daily data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  // Get completion for specific date
  Future<PrayerCompletion?> getCompletionForDate(DateTime date) async {
    return await _prayerTrackerService.getCompletionForDate(date);
  }

  // Get completions for date range (for calendar view)
  Future<List<PrayerCompletion>> getCompletionsForRange(
    DateTime start,
    DateTime end,
  ) async {
    return await _prayerTrackerService.getCompletionsForRange(start, end);
  }
}
