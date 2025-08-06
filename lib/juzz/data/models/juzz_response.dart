
import 'juzz.dart';
import 'package:json_annotation/json_annotation.dart';
part 'juzz_response.g.dart';
@JsonSerializable()
class JuzzResponse {
  final int code;
  final String status;
  final Juzz data;

  JuzzResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory JuzzResponse.fromJson(Map<String, dynamic> json) => _$JuzzResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JuzzResponseToJson(this);
}