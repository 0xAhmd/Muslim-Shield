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

    if (surahNumber == null ||
        surahName == null ||
        surahEnglishName == null ||
        ayahNumber == null ||
        totalAyahs == null) {
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

// Add this to your existing LastReadData class
class LastReadData {
  final int surahNumber;
  final String surahEnglishName;
  final int ayahNumber;
  final double progressPercentage;
  final DateTime lastReadAt;
  final int? juzzNumber; // Add Juzz support

  LastReadData({
    required this.surahNumber,
    required this.surahEnglishName,
    required this.ayahNumber,
    required this.progressPercentage,
    required this.lastReadAt,
    this.juzzNumber, // Optional Juzz number
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'surahEnglishName': surahEnglishName,
      'ayahNumber': ayahNumber,
      'progressPercentage': progressPercentage,
      'lastReadAt': lastReadAt.toIso8601String(),
      'juzzNumber': juzzNumber,
    };
  }

  // Create from JSON
  factory LastReadData.fromJson(Map<String, dynamic> json) {
    return LastReadData(
      surahNumber: json['surahNumber'] as int,
      surahEnglishName: json['surahEnglishName'] as String,
      ayahNumber: json['ayahNumber'] as int,
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      lastReadAt: DateTime.parse(json['lastReadAt'] as String),
      juzzNumber: json['juzzNumber'] as int?,
    );
  }

  // Copy with method for updates
  LastReadData copyWith({
    int? surahNumber,
    String? surahEnglishName,
    int? ayahNumber,
    double? progressPercentage,
    DateTime? lastReadAt,
    int? juzzNumber,
  }) {
    return LastReadData(
      surahNumber: surahNumber ?? this.surahNumber,
      surahEnglishName: surahEnglishName ?? this.surahEnglishName,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      juzzNumber: juzzNumber ?? this.juzzNumber,
    );
  }

  @override
  String toString() {
    return 'LastReadData(surahNumber: $surahNumber, surahEnglishName: $surahEnglishName, ayahNumber: $ayahNumber, progressPercentage: $progressPercentage, lastReadAt: $lastReadAt, juzzNumber: $juzzNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LastReadData &&
        other.surahNumber == surahNumber &&
        other.surahEnglishName == surahEnglishName &&
        other.ayahNumber == ayahNumber &&
        other.progressPercentage == progressPercentage &&
        other.lastReadAt == lastReadAt &&
        other.juzzNumber == juzzNumber;
  }

  @override
  int get hashCode {
    return surahNumber.hashCode ^
        surahEnglishName.hashCode ^
        ayahNumber.hashCode ^
        progressPercentage.hashCode ^
        lastReadAt.hashCode ^
        juzzNumber.hashCode;
  }
}
