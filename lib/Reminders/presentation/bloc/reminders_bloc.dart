import 'package:azkar/Reminders/data/repo/reminders_repo_impl.dart';
import 'package:azkar/Reminders/presentation/bloc/reminders_event.dart';
import 'package:azkar/Reminders/presentation/bloc/reminders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemindersBloc extends Bloc<RemindersEvent, RemindersState> {
  final RemindersRepository _repository;

  RemindersBloc(this._repository) : super(RemindersInitial()) {
    on<LoadReminders>(_onLoadReminders);
    on<LoadEventsForMonth>(_onLoadEventsForMonth);
    on<RefreshReminders>(_onRefreshReminders);
    on<MarkReminderAsRead>(_onMarkReminderAsRead);
    on<ScheduleNotifications>(_onScheduleNotifications);
    on<LoadPrayerReminders>(_onLoadPrayerReminders);
  }

  Future<void> _onLoadReminders(
    LoadReminders event,
    Emitter<RemindersState> emit,
  ) async {
    try {
      emit(RemindersLoading());

      final now = DateTime.now();
      final events = await _repository.getEventsForMonth(now.year, now.month);
      final reminders = await _repository.getTodayReminders();

      emit(RemindersLoaded(events: events, reminders: reminders));
    } catch (e) {
      emit(RemindersError(e.toString()));
    }
  }

  Future<void> _onLoadEventsForMonth(
    LoadEventsForMonth event,
    Emitter<RemindersState> emit,
  ) async {
    try {
      final events = await _repository.getEventsForMonth(
        event.year,
        event.month,
      );
      final reminders = await _repository.getTodayReminders();

      emit(RemindersLoaded(events: events, reminders: reminders));
    } catch (e) {
      emit(RemindersError(e.toString()));
    }
  }

  Future<void> _onRefreshReminders(
    RefreshReminders event,
    Emitter<RemindersState> emit,
  ) async {
    add(LoadReminders());
  }

  Future<void> _onMarkReminderAsRead(
    MarkReminderAsRead event,
    Emitter<RemindersState> emit,
  ) async {
    try {
      await _repository.markReminderAsRead(event.reminderId);
      add(LoadReminders()); // Refresh after marking as read
    } catch (e) {
      emit(RemindersError(e.toString()));
    }
  }

  Future<void> _onScheduleNotifications(
    ScheduleNotifications event,
    Emitter<RemindersState> emit,
  ) async {
    try {
      await _repository.scheduleNotifications();
    } catch (e) {
      emit(RemindersError('Failed to schedule notifications: ${e.toString()}'));
    }
  }

  Future<void> _onLoadPrayerReminders(
    LoadPrayerReminders event,
    Emitter<RemindersState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is RemindersLoaded) {
        final prayerReminders = await _repository.generatePrayerReminders(
          event.prayerTimings,
        );
        final allReminders = [...currentState.reminders, ...prayerReminders];

        emit(
          RemindersLoaded(events: currentState.events, reminders: allReminders),
        );
      }
    } catch (e) {
      emit(RemindersError(e.toString()));
    }
  }
}
