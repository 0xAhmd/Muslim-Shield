
import 'package:azkar/prayer/data/models/hijri_month.dart';
import 'package:json_annotation/json_annotation.dart';
part 'prayer_hijri.g.dart';
@JsonSerializable()
class PrayerHijri {
  final String date;
  final String format;
  final String day;
  final String weekday;
  final HijriMonth month;
  final String year;

  PrayerHijri({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
  });

  factory PrayerHijri.fromJson(Map<String, dynamic> json) =>
      _$PrayerHijriFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerHijriToJson(this);
}