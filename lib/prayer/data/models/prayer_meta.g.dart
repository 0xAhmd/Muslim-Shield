// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerMeta _$PrayerMetaFromJson(Map<String, dynamic> json) => PrayerMeta(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  timezone: json['timezone'] as String,
  method: PrayerMethod.fromJson(json['method'] as Map<String, dynamic>),
  latitudeAdjustmentMethod: json['latitudeAdjustmentMethod'] as String,
  midnightMode: json['midnightMode'] as String,
  school: json['school'] as String,
  offset: json['offset'] == null
      ? {}
      : PrayerMeta._offsetFromJson(json['offset']),
);

Map<String, dynamic> _$PrayerMetaToJson(PrayerMeta instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timezone': instance.timezone,
      'method': instance.method,
      'latitudeAdjustmentMethod': instance.latitudeAdjustmentMethod,
      'midnightMode': instance.midnightMode,
      'school': instance.school,
      'offset': instance.offset,
    };
