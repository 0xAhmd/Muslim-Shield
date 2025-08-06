class LocationResult {
  final bool isSuccess;
  final double? latitude;
  final double? longitude;
  final String? errorMessage;

  const LocationResult._({
    required this.isSuccess,
    this.latitude,
    this.longitude,
    this.errorMessage,
  });

  factory LocationResult.success({
    required double latitude,
    required double longitude,
  }) {
    return LocationResult._(
      isSuccess: true,
      latitude: latitude,
      longitude: longitude,
    );
  }

  factory LocationResult.failure(String message) {
    return LocationResult._(isSuccess: false, errorMessage: message);
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'LocationResult.success(lat: $latitude, lng: $longitude)';
    } else {
      return 'LocationResult.failure($errorMessage)';
    }
  }
}
