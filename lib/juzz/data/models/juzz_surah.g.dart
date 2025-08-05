// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juzz_surah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JuzzSurah _$JuzzSurahFromJson(Map<String, dynamic> json) => JuzzSurah(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  englishName: json['englishName'] as String,
  englishNameTranslation: json['englishNameTranslation'] as String,
  revelationType: json['revelationType'] as String,
  numberOfAyahs: (json['numberOfAyahs'] as num).toInt(),
);

Map<String, dynamic> _$JuzzSurahToJson(JuzzSurah instance) => <String, dynamic>{
  'number': instance.number,
  'name': instance.name,
  'englishName': instance.englishName,
  'englishNameTranslation': instance.englishNameTranslation,
  'revelationType': instance.revelationType,
  'numberOfAyahs': instance.numberOfAyahs,
};
