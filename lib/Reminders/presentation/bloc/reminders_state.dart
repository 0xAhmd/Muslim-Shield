import '../../data/models/muslim_event.dart';
import '../../data/models/reminder_card.dart';


abstract class RemindersState {}

class RemindersInitial extends RemindersState {}

class RemindersLoading extends RemindersState {}

class RemindersLoaded extends RemindersState {
  final List<MuslimEvent> events;
  final List<ReminderCard> reminders;

  RemindersLoaded({required this.events, required this.reminders});
}

class RemindersError extends RemindersState {
  final String message;

  RemindersError(this.message);
}
