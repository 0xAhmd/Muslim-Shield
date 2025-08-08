part of 'prayer_tracker_bloc.dart';

abstract class PrayerTrackerState extends Equatable {
  const PrayerTrackerState();  

  @override
  List<Object> get props => [];
}
class PrayerTrackerInitial extends PrayerTrackerState {}
