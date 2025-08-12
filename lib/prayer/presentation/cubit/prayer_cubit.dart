import 'package:azkar/core/widgets/next_prayer_widget_service.dart';
import 'package:azkar/prayer/data/models/prayer_location.dart';

import '../../data/repo/prayer_repo.dart';
import 'prayer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Reminders/data/services/notification_service.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerRepository _repository;
  final NotificationService _notificationService = NotificationService();

  PrayerTimesCubit(this._repository) : super(PrayerTimesInitial());

  Future<void> fetchPrayerTimes() async {
    try {
      if (isClosed) return;
      emit(PrayerTimesLoading());

      // Initialize notification service
      try {
        await _notificationService.initialize();
      } catch (e) {
        debugPrint('Warning: Could not initialize notification service: $e');
      }

      // Initialize Next Prayer Widget Service
      try {
        await NextPrayerWidgetService.initialize();
      } catch (e) {
        debugPrint(
          'Warning: Could not initialize Next Prayer Widget service: $e',
        );
      }

      // Get current location
      final location = await _repository.getCurrentLocation();
      if (isClosed) return;

      // Fetch prayer times
      final prayerTimes = await _repository.getPrayerTimes(
        location.latitude,
        location.longitude,
      );
      if (isClosed) return;

      // Get today's prayers list
      final prayersList = await _repository.getTodayPrayersList(
        prayerTimes.data.timings,
      );
      if (isClosed) return;

      // Get next prayer
      final nextPrayer = await _repository.getNextPrayer(
        prayerTimes.data.timings,
      );
      if (isClosed) return;

      // Schedule Adhan notifications if enabled
      await _scheduleAdhanNotifications(prayerTimes.data.timings);

      // Update Next Prayer Widget
      await _updateNextPrayerWidget(nextPrayer, location, prayersList);

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
        emit(PrayerTimesError(e.toString()));
      }
    }
  }

  /// Update the Next Prayer Widget with latest data
  Future<void> _updateNextPrayerWidget(
    PrayerInfo? nextPrayer,
    LocationInfo location,
    List<PrayerInfo> prayersList,
  ) async {
    try {
      final locationString = '${location.cityName}, ${location.countryName}';

      // Update widget with prayer times list for better next prayer calculation
      await NextPrayerWidgetService.updateWidgetWithPrayerTimes(
        prayers: prayersList,
        location: locationString,
        lastUpdated: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      debugPrint('Error updating Next Prayer Widget: $e');
    }
  }

  Future<void> _scheduleAdhanNotifications(timings) async {
    try {
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
      debugPrint('Error scheduling Adhan notifications: $e');
    }
  }

  Future<void> refreshPrayerTimes() async {
    await fetchPrayerTimes();
  }

  Future<void> updateAdhanSettings() async {
    final currentState = state;
    if (currentState is PrayerTimesLoaded) {
      await _scheduleAdhanNotifications(currentState.prayerTimes.data.timings);
    }
  }

  /// Manually update Next Prayer Widget (can be called from UI)
  Future<void> updateNextPrayerWidget() async {
    final currentState = state;
    if (currentState is PrayerTimesLoaded) {
      await _updateNextPrayerWidget(
        currentState.nextPrayer,
        currentState.location,
        currentState.prayersList,
      );
    }
  }

  /// Clear Next Prayer Widget data
  Future<void> clearNextPrayerWidget() async {
    try {
      await NextPrayerWidgetService.clearWidgetData();
    } catch (e) {
      debugPrint('Error clearing Next Prayer Widget: $e');
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
