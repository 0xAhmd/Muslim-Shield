import 'package:azkar/hizb/data/models/hizb.dart';
import 'package:json_annotation/json_annotation.dart';
part 'hizb_reponse.g.dart';

@JsonSerializable()
class HizbResponse {
  final int code;
  final String status;
  final Hizb data;

  HizbResponse({required this.code, required this.status, required this.data});

  factory HizbResponse.fromJson(Map<String, dynamic> json) =>
      _$HizbResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HizbResponseToJson(this);
}
