// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juzz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Juzz _$JuzzFromJson(Map<String, dynamic> json) => Juzz(
  number: (json['number'] as num).toInt(),
  ayahs: (json['ayahs'] as List<dynamic>)
      .map((e) => JuzzAyah.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$JuzzToJson(Juzz instance) => <String, dynamic>{
  'number': instance.number,
  'ayahs': instance.ayahs,
};
