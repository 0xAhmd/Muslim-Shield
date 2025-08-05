// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerMethod _$PrayerMethodFromJson(Map<String, dynamic> json) => PrayerMethod(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  params: json['params'] as Map<String, dynamic>,
  location: PrayerLocation.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PrayerMethodToJson(PrayerMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'params': instance.params,
      'location': instance.location,
    };
