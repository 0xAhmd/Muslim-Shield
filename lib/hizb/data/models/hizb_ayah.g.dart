// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hizb_ayah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HizbAyah _$HizbAyahFromJson(Map<String, dynamic> json) => HizbAyah(
  number: (json['number'] as num).toInt(),
  text: json['text'] as String,
  numberInSurah: (json['numberInSurah'] as num).toInt(),
  juz: (json['juz'] as num).toInt(),
  manzil: (json['manzil'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  ruku: (json['ruku'] as num).toInt(),
  hizbQuarter: (json['hizbQuarter'] as num).toInt(),
  sajda: json['sajda'] as bool,
  surah: Surah.fromJson(json['surah'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HizbAyahToJson(HizbAyah instance) => <String, dynamic>{
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
