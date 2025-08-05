// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juzz_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JuzzResponse _$JuzzResponseFromJson(Map<String, dynamic> json) => JuzzResponse(
  code: (json['code'] as num).toInt(),
  status: json['status'] as String,
  data: Juzz.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$JuzzResponseToJson(JuzzResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'data': instance.data,
    };
