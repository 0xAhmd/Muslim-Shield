import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prayer_completion.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class PrayerCompletion extends HiveObject {
  @HiveField(0)
  final String date; // Format: yyyy-MM-dd

  @HiveField(1)
  final Map<PrayerType, bool> completions;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime? updatedAt;

  PrayerCompletion({
    required this.date,
    required this.completions,
    required this.createdAt,
    this.updatedAt,
  });

  factory PrayerCompletion.fromJson(Map<String, dynamic> json) =>
      _$PrayerCompletionFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerCompletionToJson(this);

  PrayerCompletion copyWith({
    String? date,
    Map<PrayerType, bool>? completions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrayerCompletion(
      date: date ?? this.date,
      completions: completions ?? this.completions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get isComplete => completions.values.every((completed) => completed);
  
  int get completedCount => completions.values.where((completed) => completed).length;
  
  double get completionPercentage => completedCount / completions.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrayerCompletion &&
        other.date == date &&
        other.completions == completions;
  }

  @override
  int get hashCode => date.hashCode ^ completions.hashCode;
}

@HiveType(typeId: 11)
enum PrayerType {
  @HiveField(0)
  fajr,
  
  @HiveField(1)
  dhuhr,
  
  @HiveField(2)
  asr,
  
  @HiveField(3)
  maghrib,
  
  @HiveField(4)
  isha;

  String get displayName {
    switch (this) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
    }
  }

  String get arabicName {
    switch (this) {
      case PrayerType.fajr:
        return 'فجر';
      case PrayerType.dhuhr:
        return 'ظهر';
      case PrayerType.asr:
        return 'عصر';
      case PrayerType.maghrib:
        return 'مغرب';
      case PrayerType.isha:
        return 'عشاء';
    }
  }
}

@HiveType(typeId: 12)
@JsonSerializable()
class PrayerStreak extends HiveObject {
  @HiveField(0)
  final int currentStreak;

  @HiveField(1)
  final int longestStreak;

  @HiveField(2)
  final String? lastCompletionDate; // yyyy-MM-dd

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final int totalCompleteDays;

  PrayerStreak({
    required this.currentStreak,
    required this.longestStreak,
    this.lastCompletionDate,
    required this.createdAt,
    required this.updatedAt,
    required this.totalCompleteDays,
  });

  factory PrayerStreak.initial() {
    final now = DateTime.now();
    return PrayerStreak(
      currentStreak: 0,
      longestStreak: 0,
      lastCompletionDate: null,
      createdAt: now,
      updatedAt: now,
      totalCompleteDays: 0,
    );
  }

  factory PrayerStreak.fromJson(Map<String, dynamic> json) =>
      _$PrayerStreakFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerStreakToJson(this);

  PrayerStreak copyWith({
    int? currentStreak,
    int? longestStreak,
    String? lastCompletionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalCompleteDays,
  }) {
    return PrayerStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletionDate: lastCompletionDate ?? this.lastCompletionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalCompleteDays: totalCompleteDays ?? this.totalCompleteDays,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrayerStreak &&
        other.currentStreak == currentStreak &&
        other.longestStreak == longestStreak &&
        other.lastCompletionDate == lastCompletionDate;
  }

  @override
  int get hashCode =>
      currentStreak.hashCode ^
      longestStreak.hashCode ^
      lastCompletionDate.hashCode;
}