import 'package:json_annotation/json_annotation.dart';

part 'masjid.g.dart';

@JsonSerializable()
class MasjidModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final String? amenity;
  final String? religion;
  final String? denomination;
  final double? distance; // Distance from user in kilometers

  const MasjidModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.amenity,
    this.religion,
    this.denomination,
    this.distance,
  });

  factory MasjidModel.fromJson(Map<String, dynamic> json) =>
      _$MasjidModelFromJson(json);

  Map<String, dynamic> toJson() => _$MasjidModelToJson(this);

  MasjidModel copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    String? amenity,
    String? religion,
    String? denomination,
    double? distance,
  }) {
    return MasjidModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      amenity: amenity ?? this.amenity,
      religion: religion ?? this.religion,
      denomination: denomination ?? this.denomination,
      distance: distance ?? this.distance,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MasjidModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MasjidModel(id: $id, name: $name, distance: ${distance?.toStringAsFixed(2)}km)';
  }
}