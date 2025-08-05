import 'package:json_annotation/json_annotation.dart';

part 'gregorian_month.g.dart';
@JsonSerializable()

class GregorianMonth {
  final int number;
  final String en;

  GregorianMonth({required this.number, required this.en});

  factory GregorianMonth.fromJson(Map<String, dynamic> json) =>
      _$GregorianMonthFromJson(json);

  Map<String, dynamic> toJson() => _$GregorianMonthToJson(this);
}