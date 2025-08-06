import 'sajda.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sajda_reponse.g.dart';

@JsonSerializable()
class SajdaResponse {
  final int code;
  final String status;
  final Sajda data;

  SajdaResponse({required this.code, required this.status, required this.data});

  factory SajdaResponse.fromJson(Map<String, dynamic> json) =>
      _$SajdaResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SajdaResponseToJson(this);
}