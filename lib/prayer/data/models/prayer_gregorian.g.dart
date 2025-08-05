// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_gregorian.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerGregorian _$PrayerGregorianFromJson(Map<String, dynamic> json) =>
    PrayerGregorian(
      date: json['date'] as String,
      format: json['format'] as String,
      day: json['day'] as String,
      weekday: PrayerGregorian._weekdayFromJson(json['weekday']),
      month: GregorianMonth.fromJson(json['month'] as Map<String, dynamic>),
      year: json['year'] as String,
    );

Map<String, dynamic> _$PrayerGregorianToJson(PrayerGregorian instance) =>
    <String, dynamic>{
      'date': instance.date,
      'format': instance.format,
      'day': instance.day,
      'weekday': instance.weekday,
      'month': instance.month,
      'year': instance.year,
    };
