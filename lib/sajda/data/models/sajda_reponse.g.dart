// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sajda_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SajdaResponse _$SajdaResponseFromJson(Map<String, dynamic> json) =>
    SajdaResponse(
      code: (json['code'] as num).toInt(),
      status: json['status'] as String,
      data: Sajda.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SajdaResponseToJson(SajdaResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'data': instance.data,
    };
