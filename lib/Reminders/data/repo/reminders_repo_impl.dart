import 'package:azkar/Reminders/data/models/muslim_event.dart';
import 'package:azkar/Reminders/data/models/reminder_card.dart';
import 'package:azkar/Reminders/data/services/events_api_service.dart';
import 'package:azkar/Reminders/data/services/local_events_service.dart';
import 'package:azkar/Reminders/data/services/notification_service.dart';
import 'package:azkar/prayer/data/models/prayer_timings.dart';
import 'package:intl/intl.dart';

abstract class RemindersRepository {
  Future<List<MuslimEvent>> getEventsForMonth(int year, int month);
  Future<List<ReminderCard>> getTodayReminders();
  Future<void> scheduleNotifications();
  Future<List<ReminderCard>> generatePrayerReminders(PrayerTimings? timings);
  Future<void> markReminderAsRead(String reminderId);
}

class RemindersRepositoryImpl implements RemindersRepository {
  final EventsApiService _apiService;
  final NotificationService _notificationService;

  RemindersRepositoryImpl(this._apiService, this._notificationService);

  @override
  Future<List<MuslimEvent>> getEventsForMonth(int year, int month) async {
    try {
      // Try to get events from API first
      final apiEvents = await _apiService.getIslamicEvents(year, month);
      final localEvents = LocalEventsService.getLocalEvents(year);
      final fridayEvents = LocalEventsService.getFridayEvents();

      // Combine all events
      final allEvents = [...apiEvents, ...localEvents, ...fridayEvents];

      // Filter events for the specific month
      return allEvents.where((event) {
        return event.date.year == year && event.date.month == month;
      }).toList();
    } catch (e) {
      // Fallback to local events if API fails
      final localEvents = LocalEventsService.getLocalEvents(year);
      final fridayEvents = LocalEventsService.getFridayEvents();

      return [...localEvents, ...fridayEvents].where((event) {
        return event.date.year == year && event.date.month == month;
      }).toList();
    }
  }

  @override
  Future<List<ReminderCard>> getTodayReminders() async {
    final today = DateTime.now();
    final reminders = <ReminderCard>[];

    // Check if it's Friday
    if (today.weekday == DateTime.friday) {
      reminders.add(
        ReminderCard(
          id: 'friday_${DateFormat('yyyy_MM_dd').format(today)}',
          title: 'Friday Reminder',
          message: 'Don\'t forget to read Surah Al-Kahf today',
          type: ReminderType.fridaySurah,
          createdAt: today,
          actionText: 'Read Now',
        ),
      );
    }

    // Check for Islamic events today
    final todayEvents = await getEventsForMonth(today.year, today.month);
    for (final event in todayEvents) {
      if (_isSameDay(event.date, today)) {
        reminders.add(
          ReminderCard(
            id: 'event_${event.id}',
            title: event.title,
            message: event.description,
            type: _mapEventTypeToReminderType(event.type),
            createdAt: today,
            actionText: 'Learn More',
          ),
        );
      }
    }

    return reminders;
  }

  @override
  Future<List<ReminderCard>> generatePrayerReminders(
    PrayerTimings? timings,
  ) async {
    if (timings == null) return [];

    final now = DateTime.now();
    final reminders = <ReminderCard>[];

    final prayers = [
      {'name': 'Fajr', 'time': timings.fajr},
      {'name': 'Dhuhr', 'time': timings.dhuhr},
      {'name': 'Asr', 'time': timings.asr},
      {'name': 'Maghrib', 'time': timings.maghrib},
      {'name': 'Isha', 'time': timings.isha},
    ];

    for (final prayer in prayers) {
      final prayerTime = _parseTime(prayer['time'] as String);
      final timeDiff = prayerTime.difference(now);

      if (timeDiff.isNegative && timeDiff.inHours > -1) {
        // Prayer has passed within the last hour
        reminders.add(
          ReminderCard(
            id: 'prayer_passed_${prayer['name']}_${DateFormat('yyyy_MM_dd').format(now)}',
            title: 'Prayer Time Passed',
            message: '${prayer['name']} prayer time has passed',
            type: ReminderType.prayerPassed,
            createdAt: now,
          ),
        );
      } else if (timeDiff.inMinutes <= 30 && timeDiff.inMinutes > 0) {
        // Prayer is upcoming within 30 minutes
        reminders.add(
          ReminderCard(
            id: 'prayer_upcoming_${prayer['name']}_${DateFormat('yyyy_MM_dd').format(now)}',
            title: 'Prayer Time Approaching',
            message:
                'Time for ${prayer['name']} prayer in ${timeDiff.inMinutes} minutes',
            type: ReminderType.prayerUpcoming,
            createdAt: now,
            actionText: 'Prepare',
          ),
        );
      }
    }

    return reminders;
  }

  @override
  Future<void> scheduleNotifications() async {
    await _notificationService.initialize();

    // Schedule Friday reminders
    await _notificationService.scheduleFridayReminder();

    // Schedule event notifications
    final currentYear = DateTime.now().year;
    final events = await getEventsForMonth(currentYear, DateTime.now().month);

    for (final event in events) {
      if (event.date.isAfter(DateTime.now())) {
        await _notificationService.scheduleEventReminder(event);
      }
    }
  }

  @override
  Future<void> markReminderAsRead(String reminderId) async {
    // In a real app, this would update the reminder status in local storage
    // For now, we'll just print the action
    print('Reminder marked as read: $reminderId');
  }

  DateTime _parseTime(String timeString) {
    final cleanTime = timeString.split(' ')[0];
    final parts = cleanTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  ReminderType _mapEventTypeToReminderType(MuslimEventType eventType) {
    switch (eventType) {
      case MuslimEventType.eidFitr:
      case MuslimEventType.eidAdha:
        return ReminderType.eidGreeting;
      case MuslimEventType.ramadan:
        return ReminderType.ramadanIftar;
      case MuslimEventType.friday:
        return ReminderType.fridaySurah;
      default:
        return ReminderType.general;
    }
  }
}
