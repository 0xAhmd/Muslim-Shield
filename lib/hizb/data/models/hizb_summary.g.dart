// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hizb_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HizbSummary _$HizbSummaryFromJson(Map<String, dynamic> json) => HizbSummary(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  containedSurahs: (json['containedSurahs'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  containedJuzz: (json['containedJuzz'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  approximateAyahs: (json['approximateAyahs'] as num).toInt(),
);

Map<String, dynamic> _$HizbSummaryToJson(HizbSummary instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'description': instance.description,
      'containedSurahs': instance.containedSurahs,
      'containedJuzz': instance.containedJuzz,
      'approximateAyahs': instance.approximateAyahs,
    };
