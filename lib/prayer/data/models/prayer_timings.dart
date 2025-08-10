import 'package:json_annotation/json_annotation.dart';

part 'prayer_timings.g.dart';
@JsonSerializable()
class PrayerTimings {
  @JsonKey(name: 'Fajr')
  final String fajr;

  @JsonKey(name: 'Dhuhr')
  final String dhuhr;

  @JsonKey(name: 'Asr')
  final String asr;

  @JsonKey(name: 'Maghrib')
  final String maghrib;

  @JsonKey(name: 'Isha')
  final String isha;

  @JsonKey(name: 'Sunrise')
  final String sunrise;

  @JsonKey(name: 'Sunset')
  final String sunset;

  PrayerTimings({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
    required this.sunset,
  });

  factory PrayerTimings.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimingsFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerTimingsToJson(this);
}
