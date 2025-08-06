import 'prayer_date.dart';
import 'prayer_meta.dart';
import 'prayer_timings.dart';
import 'package:json_annotation/json_annotation.dart';
part 'prayer_data.g.dart';
@JsonSerializable()
class PrayerData {
  final PrayerTimings timings;
  final PrayerDate date;
  final PrayerMeta meta;

  PrayerData({required this.timings, required this.date, required this.meta});

  factory PrayerData.fromJson(Map<String, dynamic> json) =>
      _$PrayerDataFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerDataToJson(this);
}
