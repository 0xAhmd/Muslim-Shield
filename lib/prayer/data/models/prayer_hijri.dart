import 'package:json_annotation/json_annotation.dart';

import 'hijri_month.dart';

part 'prayer_hijri.g.dart';

@JsonSerializable()
class PrayerHijri {
  final String date;
  final String format;
  final String day;
  @JsonKey(fromJson: _weekdayFromJson)
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

  static String _weekdayFromJson(dynamic json) {
    if (json is String) return json;
    if (json is Map<String, dynamic>) {
      return json['en'] as String? ?? '';
    }
    return '';
  }
}
