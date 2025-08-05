import 'package:azkar/prayer/data/models/prayer_method.dart';
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
  @JsonKey(fromJson: _offsetFromJson, defaultValue: <String, int>{})
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

  static Map<String, int> _offsetFromJson(dynamic json) {
    if (json == null) return <String, int>{};
    if (json is Map) {
      final Map<String, dynamic> dynamicMap = Map<String, dynamic>.from(json);
      return dynamicMap.map((key, value) {
        int intValue = 0;
        if (value is int) {
          intValue = value;
        } else if (value is double) {
          intValue = value.toInt();
        } else if (value is String) {
          intValue = int.tryParse(value) ?? 0;
        }
        return MapEntry(key, intValue);
      });
    }
    return <String, int>{};
  }
}
