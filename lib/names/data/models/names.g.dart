// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'names.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllahName _$AllahNameFromJson(Map<String, dynamic> json) => AllahName(
      id: (json['id'] as num).toInt(),
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      meaning: json['meaning'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$AllahNameToJson(AllahName instance) => <String, dynamic>{
      'id': instance.id,
      'arabic': instance.arabic,
      'transliteration': instance.transliteration,
      'meaning': instance.meaning,
      'description': instance.description,
    };
