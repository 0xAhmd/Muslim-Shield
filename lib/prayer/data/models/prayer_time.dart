import 'prayer_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prayer_time.g.dart';

@JsonSerializable()
class PrayerTimesResponse {
  final int code;
  final String status;
  final PrayerData data;

  PrayerTimesResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerTimesResponseToJson(this);
}








