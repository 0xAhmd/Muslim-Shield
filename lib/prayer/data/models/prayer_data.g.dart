// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerData _$PrayerDataFromJson(Map<String, dynamic> json) => PrayerData(
  timings: PrayerTimings.fromJson(json['timings'] as Map<String, dynamic>),
  date: PrayerDate.fromJson(json['date'] as Map<String, dynamic>),
  meta: PrayerMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PrayerDataToJson(PrayerData instance) =>
    <String, dynamic>{
      'timings': instance.timings,
      'date': instance.date,
      'meta': instance.meta,
    };
