import 'prayer_location.dart';
import 'package:json_annotation/json_annotation.dart';
part 'prayer_method.g.dart';

@JsonSerializable()
class PrayerMethod {
  final int id;
  final String name;
  final Map<String, dynamic> params;
  final PrayerLocation location;

  PrayerMethod({
    required this.id,
    required this.name,
    required this.params,
    required this.location,
  });

  factory PrayerMethod.fromJson(Map<String, dynamic> json) =>
      _$PrayerMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerMethodToJson(this);
}
