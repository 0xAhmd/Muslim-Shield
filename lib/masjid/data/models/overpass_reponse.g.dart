// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overpass_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverpassResponse _$OverpassResponseFromJson(Map<String, dynamic> json) =>
    OverpassResponse(
      elements: (json['elements'] as List<dynamic>)
          .map((e) => OverpassElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OverpassResponseToJson(OverpassResponse instance) =>
    <String, dynamic>{'elements': instance.elements};

OverpassElement _$OverpassElementFromJson(Map<String, dynamic> json) =>
    OverpassElement(
      id: (json['id'] as num).toInt(),
      latitude: (json['lat'] as num?)?.toDouble(),
      longitude: (json['lon'] as num?)?.toDouble(),
      tags: json['tags'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$OverpassElementToJson(OverpassElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lat': instance.latitude,
      'lon': instance.longitude,
      'tags': instance.tags,
    };
