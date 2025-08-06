
import 'prayer_gregorian.dart';
import 'prayer_hijri.dart';
import 'package:json_annotation/json_annotation.dart';
part 'prayer_date.g.dart';
@JsonSerializable()
class PrayerDate {
  final String readable;
  final String timestamp;
  final PrayerHijri hijri;
  final PrayerGregorian gregorian;

  PrayerDate({
    required this.readable,
    required this.timestamp,
    required this.hijri,
    required this.gregorian,
  });

  factory PrayerDate.fromJson(Map<String, dynamic> json) =>
      _$PrayerDateFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerDateToJson(this);
}
