import '../../../prayer/data/models/prayer_timings.dart';

abstract class RemindersEvent {}

class LoadReminders extends RemindersEvent {}

class LoadEventsForMonth extends RemindersEvent {
  final int year;
  final int month;

  LoadEventsForMonth(this.year, this.month);
}

class RefreshReminders extends RemindersEvent {}

class MarkReminderAsRead extends RemindersEvent {
  final String reminderId;

  MarkReminderAsRead(this.reminderId);
}

class ScheduleNotifications extends RemindersEvent {}

class LoadPrayerReminders extends RemindersEvent {
  final PrayerTimings? prayerTimings;

  LoadPrayerReminders(this.prayerTimings);
}
