// lib/prayer/presentation/cubit/prayer_times_cubit.dart
import 'package:azkar/prayer/data/models/prayer_location.dart';
import 'package:azkar/prayer/data/models/prayer_time.dart';


// States
abstract class PrayerTimesState {}

class PrayerTimesInitial extends PrayerTimesState {}

class PrayerTimesLoading extends PrayerTimesState {}

class PrayerTimesLoaded extends PrayerTimesState {
  final PrayerTimesResponse prayerTimes;
  final LocationInfo location;
  final List<PrayerInfo> prayersList;
  final PrayerInfo? nextPrayer;

  PrayerTimesLoaded({
    required this.prayerTimes,
    required this.location,
    required this.prayersList,
    this.nextPrayer,
  });
}

class PrayerTimesError extends PrayerTimesState {
  final String message;

  PrayerTimesError(this.message);
}

// Location States
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LocationInfo location;

  LocationLoaded(this.location);
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}

