import '../models/masjid.dart';
import '../services/masjid_api_service.dart';

import '../models/location_result.dart';
import '../services/location_service.dart';

class MasjidRepository {
  final MasjidApiClient _apiClient;
  final LocationService _locationService;

  MasjidRepository({
    MasjidApiClient? apiClient,
    LocationService? locationService,
  }) : _apiClient = apiClient ?? MasjidApiClient(),
       _locationService = locationService ?? LocationService();

  /// Get user's current location
  Future<LocationResult> getCurrentLocation() async {
    return await _locationService.getCurrentLocation();
  }

  /// Search for nearby masjids
  Future<List<MasjidModel>> searchNearbyMasjids({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
    int limit = 5,
  }) async {
    try {
      final response = await _apiClient.searchNearbyMasjids(
        latitude: latitude,
        longitude: longitude,
        radiusInKm: radiusInKm,
      );

      // Convert Overpass elements to MasjidModel
      final List<MasjidModel> masjids = [];

      for (final element in response.elements) {
        // Skip elements without coordinates
        if (element.latitude == null || element.longitude == null) {
          continue;
        }

        // Calculate distance from user location
        final distance = _locationService.calculateDistance(
          lat1: latitude,
          lon1: longitude,
          lat2: element.latitude!,
          lon2: element.longitude!,
        );

        final masjid = MasjidModel(
          id: element.id.toString(),
          name: element.name,
          latitude: element.latitude!,
          longitude: element.longitude!,
          address: element.address,
          amenity: element.amenity,
          religion: element.religion,
          denomination: element.denomination,
          distance: distance,
        );

        masjids.add(masjid);
      }

      // Sort by distance (closest first) and limit results
      masjids.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));

      return masjids.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch nearby masjids: ${e.toString()}');
    }
  }

  /// Format distance for display
  String formatDistance(double distanceKm) {
    return _locationService.formatDistance(distanceKm);
  }

  /// Calculate distance between two points
  double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    return _locationService.calculateDistance(
      lat1: lat1,
      lon1: lon1,
      lat2: lat2,
      lon2: lon2,
    );
  }
}
