// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerLocation _$PrayerLocationFromJson(Map<String, dynamic> json) =>
    PrayerLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$PrayerLocationToJson(PrayerLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
