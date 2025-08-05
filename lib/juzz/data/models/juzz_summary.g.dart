// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juzz_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JuzzSummary _$JuzzSummaryFromJson(Map<String, dynamic> json) => JuzzSummary(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  containedSurahs: (json['containedSurahs'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  approximateAyahs: (json['approximateAyahs'] as num).toInt(),
);

Map<String, dynamic> _$JuzzSummaryToJson(JuzzSummary instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'description': instance.description,
      'containedSurahs': instance.containedSurahs,
      'approximateAyahs': instance.approximateAyahs,
    };
