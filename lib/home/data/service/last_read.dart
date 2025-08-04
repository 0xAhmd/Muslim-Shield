import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah.dart';

class LastReadService {
  static const String _surahNumberKey = 'last_read_surah_number';
  static const String _surahNameKey = 'last_read_surah_name';
  static const String _surahEnglishNameKey = 'last_read_surah_english_name';
  static const String _ayahNumberKey = 'last_read_ayah_number';
  static const String _totalAyahsKey = 'last_read_total_ayahs';

  // Save last read progress
  static Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required String surahEnglishName,
    required int ayahNumber,
    required int totalAyahs,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_surahNumberKey, surahNumber);
    await prefs.setString(_surahNameKey, surahName);
    await prefs.setString(_surahEnglishNameKey, surahEnglishName);
    await prefs.setInt(_ayahNumberKey, ayahNumber);
    await prefs.setInt(_totalAyahsKey, totalAyahs);
  }

  // Save from Surah model and ayah number
  static Future<void> saveLastReadFromSurah({
    required Surah surah,
    required int ayahNumber,
  }) async {
    await saveLastRead(
      surahNumber: surah.number,
      surahName: surah.name,
      surahEnglishName: surah.englishName,
      ayahNumber: ayahNumber,
      totalAyahs: surah.numberOfAyahs,
    );
  }

  // Get last read progress
  static Future<LastReadData?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    
    final surahNumber = prefs.getInt(_surahNumberKey);
    final surahName = prefs.getString(_surahNameKey);
    final surahEnglishName = prefs.getString(_surahEnglishNameKey);
    final ayahNumber = prefs.getInt(_ayahNumberKey);
    final totalAyahs = prefs.getInt(_totalAyahsKey);

    if (surahNumber == null || surahName == null || surahEnglishName == null || 
        ayahNumber == null || totalAyahs == null) {
      return null;
    }

    return LastReadData(
      surahNumber: surahNumber,
      surahName: surahName,
      surahEnglishName: surahEnglishName,
      ayahNumber: ayahNumber,
      totalAyahs: totalAyahs,
    );
  }

  // Clear last read data
  static Future<void> clearLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_surahNumberKey);
    await prefs.remove(_surahNameKey);
    await prefs.remove(_surahEnglishNameKey);
    await prefs.remove(_ayahNumberKey);
    await prefs.remove(_totalAyahsKey);
  }

  // Check if user has any reading history
  static Future<bool> hasLastRead() async {
    final lastRead = await getLastRead();
    return lastRead != null;
  }
}

class LastReadData {
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;
  final int ayahNumber;
  final int totalAyahs;

  LastReadData({
    required this.surahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.ayahNumber,
    required this.totalAyahs,
  });

  // Calculate reading progress percentage
  double get progressPercentage => (ayahNumber / totalAyahs) * 100;

  // Get progress text
  String get progressText => '${ayahNumber.toStringAsFixed(0)}/${totalAyahs.toString()}';
}