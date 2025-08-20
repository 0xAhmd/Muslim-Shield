// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adhkar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Adhkar _$AdhkarFromJson(Map<String, dynamic> json) => Adhkar(
  id: (json['id'] as num).toInt(),
  arabic: json['arabic'] as String,
  transliteration: json['transliteration'] as String,
  translation: json['translation'] as String,
  reference: json['reference'] as String,
  repetition: (json['repetition'] as num).toInt(),
  type: $enumDecode(_$AdhkarTypeEnumMap, json['type']),
);

Map<String, dynamic> _$AdhkarToJson(Adhkar instance) => <String, dynamic>{
  'id': instance.id,
  'arabic': instance.arabic,
  'transliteration': instance.transliteration,
  'translation': instance.translation,
  'reference': instance.reference,
  'repetition': instance.repetition,
  'type': _$AdhkarTypeEnumMap[instance.type]!,
};

const _$AdhkarTypeEnumMap = {
  AdhkarType.morning: 'morning',
  AdhkarType.evening: 'evening',
};
