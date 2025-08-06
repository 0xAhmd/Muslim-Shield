import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// Open Google Maps with specific location
  Future<bool> openGoogleMaps({
    required double latitude,
    required double longitude,
    String? placeName,
  }) async {
    try {
      // Create Google Maps search URL
      String query = '$latitude,$longitude';
      if (placeName != null && placeName.isNotEmpty) {
        // Encode the place name for URL
        final encodedName = Uri.encodeComponent(placeName);
        query = '$encodedName+$latitude,$longitude';
      }

      final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$query',
      );

      // Try to launch the URL
      if (await canLaunchUrl(googleMapsUrl)) {
        return await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback: Open in any available app
        return await launchUrl(googleMapsUrl);
      }
    } catch (e) {
      // Handle any errors silently and return false
      return false;
    }
  }

  /// Open Google Maps with directions from current location to destination
  Future<bool> openGoogleMapsDirections({
    required double destinationLatitude,
    required double destinationLongitude,
    double? originLatitude,
    double? originLongitude,
    String? destinationName,
  }) async {
    try {
      String destination = '$destinationLatitude,$destinationLongitude';
      if (destinationName != null && destinationName.isNotEmpty) {
        final encodedName = Uri.encodeComponent(destinationName);
        destination = '$encodedName+$destinationLatitude,$destinationLongitude';
      }

      String origin = '';
      if (originLatitude != null && originLongitude != null) {
        origin = '&origin=$originLatitude,$originLongitude';
      }

      final Uri directionsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$destination$origin',
      );

      if (await canLaunchUrl(directionsUrl)) {
        return await launchUrl(
          directionsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        return await launchUrl(directionsUrl);
      }
    } catch (e) {
      return false;
    }
  }

  /// Open phone dialer with number
  Future<bool> openPhoneDialer(String phoneNumber) async {
    try {
      final Uri phoneUrl = Uri.parse('tel:$phoneNumber');

      if (await canLaunchUrl(phoneUrl)) {
        return await launchUrl(phoneUrl);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
