import 'package:json_annotation/json_annotation.dart';

part 'overpass_reponse.g.dart';

@JsonSerializable()
class OverpassResponse {
  @JsonKey(name: 'elements')
  final List<OverpassElement> elements;

  const OverpassResponse({required this.elements});

  factory OverpassResponse.fromJson(Map<String, dynamic> json) =>
      _$OverpassResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OverpassResponseToJson(this);
}

@JsonSerializable()
class OverpassElement {
  final int id;
  @JsonKey(name: 'lat')
  final double? latitude;
  @JsonKey(name: 'lon')
  final double? longitude;
  final Map<String, dynamic>? tags;

  const OverpassElement({
    required this.id,
    this.latitude,
    this.longitude,
    this.tags,
  });

  factory OverpassElement.fromJson(Map<String, dynamic> json) =>
      _$OverpassElementFromJson(json);

  Map<String, dynamic> toJson() => _$OverpassElementToJson(this);

  String get name => tags?['name'] ?? 'Unnamed Masjid';
  String? get address => _buildAddress();
  String? get amenity => tags?['amenity'];
  String? get religion => tags?['religion'];
  String? get denomination => tags?['denomination'];

  String? _buildAddress() {
    final tags = this.tags;
    if (tags == null) return null;

    final List<String> addressParts = [];

    // Add house number and street
    final houseNumber = tags['addr:housenumber'];
    final street = tags['addr:street'];
    if (houseNumber != null && street != null) {
      addressParts.add('$houseNumber $street');
    } else if (street != null) {
      addressParts.add(street);
    }

    // Add city
    final city = tags['addr:city'];
    if (city != null) {
      addressParts.add(city);
    }

    // Add postcode
    final postcode = tags['addr:postcode'];
    if (postcode != null) {
      addressParts.add(postcode);
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : null;
  }
}
