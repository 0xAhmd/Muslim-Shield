import 'package:equatable/equatable.dart';
import '../../data/models/prayer_completion.dart';

abstract class PrayerTrackerState extends Equatable {
  const PrayerTrackerState();

  @override
  List<Object?> get props => [];
}

class PrayerTrackerInitial extends PrayerTrackerState {}

class PrayerTrackerLoading extends PrayerTrackerState {}

class PrayerTrackerLoaded extends PrayerTrackerState {
  final PrayerCompletion todaysCompletion;
  final PrayerStreak streak;
  final Map<String, dynamic> weeklyStats;
  final Map<String, dynamic> monthlyStats;

  const PrayerTrackerLoaded({
    required this.todaysCompletion,
    required this.streak,
    required this.weeklyStats,
    required this.monthlyStats,
  });

  @override
  List<Object?> get props => [
        todaysCompletion,
        streak,
        weeklyStats,
        monthlyStats,
      ];

  PrayerTrackerLoaded copyWith({
    PrayerCompletion? todaysCompletion,
    PrayerStreak? streak,
    Map<String, dynamic>? weeklyStats,
    Map<String, dynamic>? monthlyStats,
  }) {
    return PrayerTrackerLoaded(
      todaysCompletion: todaysCompletion ?? this.todaysCompletion,
      streak: streak ?? this.streak,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      monthlyStats: monthlyStats ?? this.monthlyStats,
    );
  }
}

class PrayerTrackerError extends PrayerTrackerState {
  final String message;

  const PrayerTrackerError({required this.message});

  @override
  List<Object?> get props => [message];
}

