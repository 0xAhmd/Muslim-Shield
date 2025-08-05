
import 'package:azkar/prayer/presentation/data/models/prayer_method.dart';
import 'package:json_annotation/json_annotation.dart';
part 'prayer_meta.g.dart';
@JsonSerializable()
class PrayerMeta {
  final double latitude;
  final double longitude;
  final String timezone;
  final PrayerMethod method;
  final String latitudeAdjustmentMethod;
  final String midnightMode;
  final String school;
  final Map<String, int> offset;

  PrayerMeta({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.method,
    required this.latitudeAdjustmentMethod,
    required this.midnightMode,
    required this.school,
    required this.offset,
  });

  factory PrayerMeta.fromJson(Map<String, dynamic> json) =>
      _$PrayerMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerMetaToJson(this);
}