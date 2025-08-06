import '../models/prayer_location.dart';
import '../models/prayer_time.dart';
import '../models/prayer_timings.dart';
import '../service/prayer_api_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

abstract class PrayerRepository {
  Future<LocationInfo> getCurrentLocation();
  Future<PrayerTimesResponse> getPrayerTimes(double latitude, double longitude);
  Future<List<PrayerInfo>> getTodayPrayersList(PrayerTimings timings);
  Future<PrayerInfo?> getNextPrayer(PrayerTimings timings);
}

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerApiService _apiService;

  PrayerRepositoryImpl(this._apiService);

  @override
  Future<LocationInfo> getCurrentLocation() async {
    try {
      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Get city name from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String cityName = 'Unknown City';
      String countryName = 'Unknown Country';

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        cityName =
            place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
        countryName = place.country ?? 'Unknown Country';
      }

      return LocationInfo(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: cityName,
        countryName: countryName,
      );
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }

  @override
  Future<PrayerTimesResponse> getPrayerTimes(
    double latitude,
    double longitude,
  ) async {
    try {
      return await _apiService.getPrayerTimes(
        latitude,
        longitude,
        2,
      ); // MWL method
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to fetch prayer times: $e');
    }
  }

  @override
  Future<List<PrayerInfo>> getTodayPrayersList(PrayerTimings timings) async {
    final prayers = [
      PrayerInfo(name: 'Fajr', time: _formatTime(timings.fajr)),
      PrayerInfo(name: 'Dhuhr', time: _formatTime(timings.dhuhr)),
      PrayerInfo(name: 'Asr', time: _formatTime(timings.asr)),
      PrayerInfo(name: 'Maghrib', time: _formatTime(timings.maghrib)),
      PrayerInfo(name: 'Isha', time: _formatTime(timings.isha)),
    ];

    return prayers;
  }

  @override
  Future<PrayerInfo?> getNextPrayer(PrayerTimings timings) async {
    final now = DateTime.now();
    final prayers = [
      {'name': 'Fajr', 'time': timings.fajr},
      {'name': 'Dhuhr', 'time': timings.dhuhr},
      {'name': 'Asr', 'time': timings.asr},
      {'name': 'Maghrib', 'time': timings.maghrib},
      {'name': 'Isha', 'time': timings.isha},
    ];

    for (final prayer in prayers) {
      final prayerTime = _parseTime(prayer['time'] as String);
      if (prayerTime.isAfter(now)) {
        return PrayerInfo(
          name: prayer['name'] as String,
          time: _formatTime(prayer['time'] as String),
          isNext: true,
        );
      }
    }

    // If no prayer is left today, return Fajr for tomorrow
    return PrayerInfo(
      name: 'Fajr',
      time: _formatTime(timings.fajr),
      isNext: true,
    );
  }

  DateTime _parseTime(String timeString) {
    // Remove timezone info if present (e.g., "05:30 (+03)")
    final cleanTime = timeString.split(' ')[0];
    final parts = cleanTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String _formatTime(String timeString) {
    try {
      final cleanTime = timeString.split(' ')[0];
      final parts = cleanTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Convert to 12-hour format
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeString; // Return original if parsing fails
    }
  }
}
