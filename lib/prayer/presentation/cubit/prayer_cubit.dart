import 'package:azkar/prayer/data/repo/prayer_repo.dart';
import 'package:azkar/prayer/presentation/cubit/prayer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Reminders/data/services/notification_service.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerRepository _repository;
  final NotificationService _notificationService = NotificationService();

  PrayerTimesCubit(this._repository) : super(PrayerTimesInitial());

  Future<void> fetchPrayerTimes() async {
    try {
      if (isClosed) return; // Check if cubit is closed
      emit(PrayerTimesLoading());

      // Initialize notification service with better error handling
      try {
        await _notificationService.initialize();
      } catch (e) {
        debugPrint('Warning: Could not initialize notification service: $e');
        // Continue without notifications rather than failing completely
      }

      // Get current location
      final location = await _repository.getCurrentLocation();
      if (isClosed) return; // Check again after async operation

      // Fetch prayer times
      final prayerTimes = await _repository.getPrayerTimes(
        location.latitude,
        location.longitude,
      );
      if (isClosed) return; // Check again after async operation

      // Get today's prayers list
      final prayersList = await _repository.getTodayPrayersList(
        prayerTimes.data.timings,
      );
      if (isClosed) return; // Check again after async operation

      // Get next prayer
      final nextPrayer = await _repository.getNextPrayer(
        prayerTimes.data.timings,
      );
      if (isClosed) return; // Check again after async operation

      // Schedule Adhan notifications if enabled
      await _scheduleAdhanNotifications(prayerTimes.data.timings);

      emit(
        PrayerTimesLoaded(
          prayerTimes: prayerTimes,
          location: location,
          prayersList: prayersList,
          nextPrayer: nextPrayer,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        // Only emit error if not closed
        emit(PrayerTimesError(e.toString()));
      }
    }
  }

  Future<void> _scheduleAdhanNotifications(timings) async {
    try {
      // Check if Adhan is enabled before scheduling
      final isEnabled = await _notificationService.isAdhanEnabled();
      if (isEnabled) {
        await _notificationService.scheduleAdhanNotifications(
          fajrTime: timings.fajr,
          dhuhrTime: timings.dhuhr,
          asrTime: timings.asr,
          maghribTime: timings.maghrib,
          ishaTime: timings.isha,
        );
      }
    } catch (e) {
      // Don't fail the whole operation if Adhan scheduling fails
      debugPrint('Error scheduling Adhan notifications: $e');
    }
  }

  Future<void> refreshPrayerTimes() async {
    await fetchPrayerTimes();
  }

  Future<void> updateAdhanSettings() async {
    // Refresh prayer times to re-schedule Adhan notifications
    final currentState = state;
    if (currentState is PrayerTimesLoaded) {
      await _scheduleAdhanNotifications(currentState.prayerTimes.data.timings);
    }
  }
}

// Location Cubit (separate for reusability)
class LocationCubit extends Cubit<LocationState> {
  final PrayerRepository _repository;

  LocationCubit(this._repository) : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    try {
      emit(LocationLoading());
      final location = await _repository.getCurrentLocation();
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
