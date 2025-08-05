// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_timings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerTimings _$PrayerTimingsFromJson(Map<String, dynamic> json) =>
    PrayerTimings(
      fajr: json['Fajr'] as String,
      dhuhr: json['Dhuhr'] as String,
      asr: json['Asr'] as String,
      maghrib: json['Maghrib'] as String,
      isha: json['Isha'] as String,
      sunrise: json['Sunrise'] as String,
      sunset: json['Sunset'] as String,
    );

Map<String, dynamic> _$PrayerTimingsToJson(PrayerTimings instance) =>
    <String, dynamic>{
      'Fajr': instance.fajr,
      'Dhuhr': instance.dhuhr,
      'Asr': instance.asr,
      'Maghrib': instance.maghrib,
      'Isha': instance.isha,
      'Sunrise': instance.sunrise,
      'Sunset': instance.sunset,
    };
