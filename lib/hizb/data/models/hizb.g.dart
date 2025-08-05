// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hizb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hizb _$HizbFromJson(Map<String, dynamic> json) => Hizb(
  number: (json['number'] as num).toInt(),
  ayahs: (json['ayahs'] as List<dynamic>)
      .map((e) => HizbAyah.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HizbToJson(Hizb instance) => <String, dynamic>{
  'number': instance.number,
  'ayahs': instance.ayahs,
};
