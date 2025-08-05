
import 'package:azkar/prayer/data/models/gregorian_month.dart';
import 'package:json_annotation/json_annotation.dart';
part 'prayer_gregorian.g.dart';
@JsonSerializable()
class PrayerGregorian {
  final String date;
  final String format;
  final String day;
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
}
