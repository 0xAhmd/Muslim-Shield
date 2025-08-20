import 'package:json_annotation/json_annotation.dart';
part 'prayer_location.g.dart';

@JsonSerializable()
class PrayerLocation {
  final double latitude;
  final double longitude;

  PrayerLocation({required this.latitude, required this.longitude});

  factory PrayerLocation.fromJson(Map<String, dynamic> json) =>
      _$PrayerLocationFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerLocationToJson(this);
}

// Helper class for prayer info
class PrayerInfo {
  final String name;
  final String time;
  final bool isNext;

  PrayerInfo({required this.name, required this.time, this.isNext = false});
}

// Helper class for location info
class LocationInfo {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;

  LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
  });
}
