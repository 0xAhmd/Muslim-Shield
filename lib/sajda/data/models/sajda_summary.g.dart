// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sajda_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SajdaSummary _$SajdaSummaryFromJson(Map<String, dynamic> json) => SajdaSummary(
  id: (json['id'] as num).toInt(),
  surahName: json['surahName'] as String,
  surahArabicName: json['surahArabicName'] as String,
  surahNumber: (json['surahNumber'] as num).toInt(),
  ayahNumber: (json['ayahNumber'] as num).toInt(),
  ayahText: json['ayahText'] as String,
  isObligatory: json['isObligatory'] as bool,
  isRecommended: json['isRecommended'] as bool,
  juz: (json['juz'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  sajdaType: json['sajdaType'] as String,
);

Map<String, dynamic> _$SajdaSummaryToJson(SajdaSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'surahName': instance.surahName,
      'surahArabicName': instance.surahArabicName,
      'surahNumber': instance.surahNumber,
      'ayahNumber': instance.ayahNumber,
      'ayahText': instance.ayahText,
      'isObligatory': instance.isObligatory,
      'isRecommended': instance.isRecommended,
      'juz': instance.juz,
      'page': instance.page,
      'sajdaType': instance.sajdaType,
    };
