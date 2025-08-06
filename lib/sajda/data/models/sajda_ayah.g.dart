// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sajda_ayah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SajdaAyah _$SajdaAyahFromJson(Map<String, dynamic> json) => SajdaAyah(
  number: (json['number'] as num).toInt(),
  text: json['text'] as String,
  numberInSurah: (json['numberInSurah'] as num).toInt(),
  juz: (json['juz'] as num).toInt(),
  manzil: (json['manzil'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  ruku: (json['ruku'] as num).toInt(),
  hizbQuarter: (json['hizbQuarter'] as num).toInt(),
  sajda: SajdaInfo.fromJson(json['sajda'] as Map<String, dynamic>),
  surah: Surah.fromJson(json['surah'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SajdaAyahToJson(SajdaAyah instance) => <String, dynamic>{
  'number': instance.number,
  'text': instance.text,
  'numberInSurah': instance.numberInSurah,
  'juz': instance.juz,
  'manzil': instance.manzil,
  'page': instance.page,
  'ruku': instance.ruku,
  'hizbQuarter': instance.hizbQuarter,
  'sajda': instance.sajda,
  'surah': instance.surah,
};

SajdaInfo _$SajdaInfoFromJson(Map<String, dynamic> json) => SajdaInfo(
  id: (json['id'] as num).toInt(),
  recommended: json['recommended'] as bool,
  obligatory: json['obligatory'] as bool,
);

Map<String, dynamic> _$SajdaInfoToJson(SajdaInfo instance) => <String, dynamic>{
  'id': instance.id,
  'recommended': instance.recommended,
  'obligatory': instance.obligatory,
};
