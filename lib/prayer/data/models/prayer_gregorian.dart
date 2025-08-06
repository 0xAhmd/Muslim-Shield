import 'gregorian_month.dart';
import 'package:json_annotation/json_annotation.dart';
part 'prayer_gregorian.g.dart';

@JsonSerializable()
class PrayerGregorian {
  final String date;
  final String format;
  final String day;
  @JsonKey(fromJson: _weekdayFromJson)
  final String weekday;
  final GregorianMonth month;
  final String year;

  PrayerGregorian({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
  });

  factory PrayerGregorian.fromJson(Map<String, dynamic> json) =>
      _$PrayerGregorianFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerGregorianToJson(this);

  static String _weekdayFromJson(dynamic json) {
    if (json is String) return json;
    if (json is Map<String, dynamic>) {
      return json['en'] as String? ?? '';
    }
    return '';
  }
}
