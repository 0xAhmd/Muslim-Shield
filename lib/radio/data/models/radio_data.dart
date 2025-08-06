import 'package:azkar/radio/data/models/radio.dart';

class RadioData {
  static const List<RadioModel> stations = [
    RadioModel(
      name: 'إذاعة القرآن الكريم من القاهرة',
      url:
          'https://n09.radiojar.com/8s5u5tpdtwzuv?rj-ttl=5&rj-tok=AAABhHgZxAkAS5rfiR',
      description: '24-hour Quran broadcast from Cairo',
      language: 'Arabic',
    ),
    // Backup stations in case the primary fails
    RadioModel(
      name: 'إذاعة القرآن الكريم - السعودية',
      url: 'https://radioplus.sba.sa/ar/live/4',
      description: 'Saudi Quran Radio',
      language: 'Arabic',
    ),
    RadioModel(
      name: 'Radio Al-Quran',
      url: 'https://www.liveonlineradio.net/saudi-arabia/radio-al-quran.htm',
      description: 'International Quran Radio',
      language: 'Arabic',
    ),
  ];

  static RadioModel get defaultStation => stations.first;

  // Method to get working station (you can implement fallback logic)
  static RadioModel getWorkingStation() {
    // For now, return the first station
    // In the future, you could implement logic to test each station
    return stations.first;
  }
}
