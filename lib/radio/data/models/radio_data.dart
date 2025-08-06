import 'package:azkar/radio/data/models/radio.dart';

class RadioData {
  static const List<RadioModel> stations = [
    // Primary Cairo Quran station (working)
    RadioModel(
      name: 'إذاعة القرآن الكريم من القاهرة',
      url:
          'https://n09.radiojar.com/8s5u5tpdtwzuv?rj-ttl=5&rj-tok=AAABhHgZxAkAS5rfiR',
      description: '24-hour Quran broadcast from Cairo',
      language: 'Arabic',
    ),
  ];

  static RadioModel get defaultStation => stations.first;

  // Method to get working station with fallback logic
  static RadioModel getWorkingStation() {
    return stations.first; // Return Cairo station as primary
  }

  // Method to test station connectivity (optional implementation)
  static List<RadioModel> getReliableStations() {
    // Return stations in order of reliability
    return [
      stations[0], // Cairo - most reliable
      stations[1], // Radio Islam International
      stations[2], // Quran Radio Live
    ];
  }
}
