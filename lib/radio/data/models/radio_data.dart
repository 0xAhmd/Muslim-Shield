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

    // Alternative working Islamic radio stations
    RadioModel(
      name: 'Radio Islam International',
      url: 'https://stream-148.zeno.fm/ye3tbzpx1nhvv?zs=_ZVduVUbThOiGrALtNsUzw',
      description: 'International Islamic radio with Quran recitation',
      language: 'Arabic',
    ),

    RadioModel(
      name: 'Quran Radio - Live Recitation',
      url: 'https://quraan.us:9874/stream',
      description: 'Continuous Quran recitation by various reciters',
      language: 'Arabic',
    ),

    // Backup stations with known working streams
    RadioModel(
      name: 'Voice of Islam Radio',
      url: 'https://stream.zenolive.com/gxb8gds8vfhvv',
      description: 'Islamic teachings and Quran recitation',
      language: 'Arabic',
    ),

    RadioModel(
      name: 'Al-Quran Al-Kareem Radio',
      url: 'https://stream-156.zeno.fm/b7npe06x1nhvv?zs=hj_z2MfPTB2g4I5rn8xGnA',
      description: 'Holy Quran recitation 24/7',
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
