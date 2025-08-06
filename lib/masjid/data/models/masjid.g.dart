// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masjid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasjidModel _$MasjidModelFromJson(Map<String, dynamic> json) => MasjidModel(
  id: json['id'] as String,
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
  amenity: json['amenity'] as String?,
  religion: json['religion'] as String?,
  denomination: json['denomination'] as String?,
  distance: (json['distance'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MasjidModelToJson(MasjidModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'amenity': instance.amenity,
      'religion': instance.religion,
      'denomination': instance.denomination,
      'distance': instance.distance,
    };
