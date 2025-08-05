// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_hijri.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerHijri _$PrayerHijriFromJson(Map<String, dynamic> json) => PrayerHijri(
  date: json['date'] as String,
  format: json['format'] as String,
  day: json['day'] as String,
  weekday: PrayerHijri._weekdayFromJson(json['weekday']),
  month: HijriMonth.fromJson(json['month'] as Map<String, dynamic>),
  year: json['year'] as String,
);

Map<String, dynamic> _$PrayerHijriToJson(PrayerHijri instance) =>
    <String, dynamic>{
      'date': instance.date,
      'format': instance.format,
      'day': instance.day,
      'weekday': instance.weekday,
      'month': instance.month,
      'year': instance.year,
    };
