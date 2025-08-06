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
  ];

  static RadioModel get defaultStation => stations.first;
}
