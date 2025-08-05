import 'package:json_annotation/json_annotation.dart';
part 'hijri_month.g.dart';
@JsonSerializable()
class HijriMonth {
  final int number;
  final String en;
  final String ar;

  HijriMonth({required this.number, required this.en, required this.ar});

  factory HijriMonth.fromJson(Map<String, dynamic> json) =>
      _$HijriMonthFromJson(json);

  Map<String, dynamic> toJson() => _$HijriMonthToJson(this);
}
