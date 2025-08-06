// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sajda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sajda _$SajdaFromJson(Map<String, dynamic> json) => Sajda(
  ayahs: (json['ayahs'] as List<dynamic>)
      .map((e) => SajdaAyah.fromJson(e as Map<String, dynamic>))
      .toList(),
  edition: SajdaEdition.fromJson(json['edition'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SajdaToJson(Sajda instance) => <String, dynamic>{
  'ayahs': instance.ayahs,
  'edition': instance.edition,
};

SajdaEdition _$SajdaEditionFromJson(Map<String, dynamic> json) => SajdaEdition(
  identifier: json['identifier'] as String,
  language: json['language'] as String,
  name: json['name'] as String,
  englishName: json['englishName'] as String,
  format: json['format'] as String,
  type: json['type'] as String,
  direction: json['direction'] as String,
);

Map<String, dynamic> _$SajdaEditionToJson(SajdaEdition instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'language': instance.language,
      'name': instance.name,
      'englishName': instance.englishName,
      'format': instance.format,
      'type': instance.type,
      'direction': instance.direction,
    };
