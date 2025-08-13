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

      debugPrint('PrayerTimesCubit: Starting to fetch prayer times...');
      emit(PrayerTimesLoading());

      // Initialize notification service
      try {
        await _notificationService.initialize();
        debugPrint('PrayerTimesCubit: Notification service initialized');
      } catch (e) {
        debugPrint('Warning: Could not initialize notification service: $e');
      }

      // Initialize Next Prayer Widget Service
      try {
        await NextPrayerWidgetService.initialize();
        debugPrint('PrayerTimesCubit: Next Prayer Widget service initialized');
      } catch (e) {
        debugPrint(
          'Warning: Could not initialize Next Prayer Widget service: $e',
        );
      }

      // Get current location
      debugPrint('PrayerTimesCubit: Getting current location...');
      final location = await _repository.getCurrentLocation();
      if (isClosed) return;

      debugPrint(
        'PrayerTimesCubit: Location obtained: ${location.cityName}, ${location.countryName}',
      );

      // Fetch prayer times
      debugPrint('PrayerTimesCubit: Fetching prayer times from API...');
      final prayerTimes = await _repository.getPrayerTimes(
        location.latitude,
        location.longitude,
      );
      if (isClosed) return;

      debugPrint('PrayerTimesCubit: Prayer times fetched successfully');

      // Get today's prayers list
      final prayersList = await _repository.getTodayPrayersList(
        prayerTimes.data.timings,
      );
      if (isClosed) return;

      debugPrint(
        'PrayerTimesCubit: Prayers list created with ${prayersList.length} prayers',
      );

      // Get next prayer
      final nextPrayer = await _repository.getNextPrayer(
        prayerTimes.data.timings,
      );
      if (isClosed) return;

      debugPrint(
        'PrayerTimesCubit: Next prayer: ${nextPrayer?.name} at ${nextPrayer?.time}',
      );

      // Schedule Adhan notifications if enabled
      await _scheduleAdhanNotifications(prayerTimes.data.timings);

      // Update Next Prayer Widget
      await _updateNextPrayerWidget(nextPrayer, location, prayersList);

      debugPrint('PrayerTimesCubit: Emitting PrayerTimesLoaded state');
      emit(
        PrayerTimesLoaded(
          prayerTimes: prayerTimes,
          location: location,
          prayersList: prayersList,
          nextPrayer: nextPrayer,
        ),
      );

      debugPrint('PrayerTimesCubit: Successfully completed fetchPrayerTimes');
    } catch (e, stackTrace) {
      debugPrint('PrayerTimesCubit: Error in fetchPrayerTimes: $e');
      debugPrint('PrayerTimesCubit: Stack trace: $stackTrace');

      if (!isClosed) {
        emit(PrayerTimesError('Failed to fetch prayer times: ${e.toString()}'));
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
      debugPrint('PrayerTimesCubit: Updating Next Prayer Widget...');
      final locationString = '${location.cityName}, ${location.countryName}';

      // Update widget with prayer times list for better next prayer calculation
      await NextPrayerWidgetService.updateWidgetWithPrayerTimes(
        prayers: prayersList,
        location: locationString,
        lastUpdated: DateTime.now().toIso8601String(),
      );

      debugPrint('PrayerTimesCubit: Next Prayer Widget updated successfully');
    } catch (e) {
      debugPrint('PrayerTimesCubit: Error updating Next Prayer Widget: $e');
      // Don't throw here, just log the error
    }
  }

  Future<void> _scheduleAdhanNotifications(timings) async {
    try {
      debugPrint('PrayerTimesCubit: Scheduling Adhan notifications...');
      final isEnabled = await _notificationService.isAdhanEnabled();
      if (isEnabled) {
        await _notificationService.scheduleAdhanNotifications(
          fajrTime: timings.fajr,
          dhuhrTime: timings.dhuhr,
          asrTime: timings.asr,
          maghribTime: timings.maghrib,
          ishaTime: timings.isha,
        );
        debugPrint('PrayerTimesCubit: Adhan notifications scheduled');
      } else {
        debugPrint('PrayerTimesCubit: Adhan notifications disabled');
      }
    } catch (e) {
      debugPrint('PrayerTimesCubit: Error scheduling Adhan notifications: $e');
      // Don't throw here, just log the error
    }
  }

  Future<void> refreshPrayerTimes() async {
    debugPrint('PrayerTimesCubit: Refresh prayer times called');
    await fetchPrayerTimes();
  }

  Future<void> updateAdhanSettings() async {
    debugPrint('PrayerTimesCubit: Updating Adhan settings...');
    final currentState = state;
    if (currentState is PrayerTimesLoaded) {
      await _scheduleAdhanNotifications(currentState.prayerTimes.data.timings);
      debugPrint('PrayerTimesCubit: Adhan settings updated');
    } else {
      debugPrint(
        'PrayerTimesCubit: Cannot update Adhan settings - no loaded state',
      );
    }
  }

  /// Manually update Next Prayer Widget (can be called from UI)
  Future<void> updateNextPrayerWidget() async {
    debugPrint('PrayerTimesCubit: Manual widget update called');
    final currentState = state;
    if (currentState is PrayerTimesLoaded) {
      await _updateNextPrayerWidget(
        currentState.nextPrayer,
        currentState.location,
        currentState.prayersList,
      );
      debugPrint('PrayerTimesCubit: Manual widget update completed');
    } else {
      debugPrint(
        'PrayerTimesCubit: Cannot update widget - no loaded state available',
      );
      throw Exception(
        'No prayer data available. Please load prayer times first.',
      );
    }
  }

  /// Clear Next Prayer Widget data
  Future<void> clearNextPrayerWidget() async {
    try {
      debugPrint('PrayerTimesCubit: Clearing Next Prayer Widget...');
      await NextPrayerWidgetService.clearWidgetData();
      debugPrint('PrayerTimesCubit: Next Prayer Widget cleared');
    } catch (e) {
      debugPrint('PrayerTimesCubit: Error clearing Next Prayer Widget: $e');
    }
  }
}

// Location Cubit (separate for reusability)
class LocationCubit extends Cubit<LocationState> {
  final PrayerRepository _repository;

  LocationCubit(this._repository) : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    try {
      debugPrint('LocationCubit: Getting current location...');
      emit(LocationLoading());
      final location = await _repository.getCurrentLocation();
      debugPrint('LocationCubit: Location obtained: ${location.cityName}');
      emit(LocationLoaded(location));
    } catch (e) {
      debugPrint('LocationCubit: Error getting location: $e');
      emit(LocationError(e.toString()));
    }
  }
}
