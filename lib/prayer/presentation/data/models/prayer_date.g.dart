// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerDate _$PrayerDateFromJson(Map<String, dynamic> json) => PrayerDate(
  readable: json['readable'] as String,
  timestamp: json['timestamp'] as String,
  hijri: PrayerHijri.fromJson(json['hijri'] as Map<String, dynamic>),
  gregorian: PrayerGregorian.fromJson(
    json['gregorian'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PrayerDateToJson(PrayerDate instance) =>
    <String, dynamic>{
      'readable': instance.readable,
      'timestamp': instance.timestamp,
      'hijri': instance.hijri,
      'gregorian': instance.gregorian,
    };
