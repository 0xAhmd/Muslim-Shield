import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah.dart';

class LastReadService {
  // Updated keys to match new LastReadData structure
  static const String _surahNumberKey = 'last_read_surah_number';
  static const String _surahEnglishNameKey = 'last_read_surah_english_name';
  static const String _ayahNumberKey = 'last_read_ayah_number';
  static const String _progressPercentageKey = 'last_read_progress_percentage';
  static const String _lastReadAtKey = 'last_read_at';
  static const String _juzzNumberKey = 'last_read_juzz_number';

  // Save last read progress using LastReadData model
  static Future<void> saveLastRead(LastReadData lastReadData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_surahNumberKey, lastReadData.surahNumber);
    await prefs.setString(_surahEnglishNameKey, lastReadData.surahEnglishName);
    await prefs.setInt(_ayahNumberKey, lastReadData.ayahNumber);
    await prefs.setDouble(
      _progressPercentageKey,
      lastReadData.progressPercentage,
    );
    await prefs.setString(
      _lastReadAtKey,
      lastReadData.lastReadAt.toIso8601String(),
    );

    if (lastReadData.juzzNumber != null) {
      await prefs.setInt(_juzzNumberKey, lastReadData.juzzNumber!);
    } else {
      await prefs.remove(_juzzNumberKey);
    }
  }

  // Legacy method for backward compatibility
  static Future<void> saveLastReadLegacy({
    required int surahNumber,
    required String surahName,
    required String surahEnglishName,
    required int ayahNumber,
    required int totalAyahs,
  }) async {
    final progressPercentage = (ayahNumber / totalAyahs) * 100;
    final lastReadData = LastReadData(
      surahNumber: surahNumber,
      surahEnglishName: surahEnglishName,
      ayahNumber: ayahNumber,
      progressPercentage: progressPercentage,
      lastReadAt: DateTime.now(),
    );
    await saveLastRead(lastReadData);
  }

  // Save from Surah model and ayah number
  static Future<void> saveLastReadFromSurah({
    required Surah surah,
    required int ayahNumber,
  }) async {
    final progressPercentage = (ayahNumber / surah.numberOfAyahs) * 100;
    final lastReadData = LastReadData(
      surahNumber: surah.number,
      surahEnglishName: surah.englishName,
      ayahNumber: ayahNumber,
      progressPercentage: progressPercentage,
      lastReadAt: DateTime.now(),
    );
    await saveLastRead(lastReadData);
  }

  // Get last read progress
  static Future<LastReadData?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();

    final surahNumber = prefs.getInt(_surahNumberKey);
    final surahEnglishName = prefs.getString(_surahEnglishNameKey);
    final ayahNumber = prefs.getInt(_ayahNumberKey);
    final progressPercentage = prefs.getDouble(_progressPercentageKey);
    final lastReadAtString = prefs.getString(_lastReadAtKey);
    final juzzNumber = prefs.getInt(_juzzNumberKey);

    if (surahNumber == null ||
        surahEnglishName == null ||
        ayahNumber == null ||
        progressPercentage == null ||
        lastReadAtString == null) {
      return null;
    }

    try {
      final lastReadAt = DateTime.parse(lastReadAtString);
      return LastReadData(
        surahNumber: surahNumber,
        surahEnglishName: surahEnglishName,
        ayahNumber: ayahNumber,
        progressPercentage: progressPercentage,
        lastReadAt: lastReadAt,
        juzzNumber: juzzNumber,
      );
    } catch (e) {
      // If date parsing fails, return null
      return null;
    }
  }

  // Clear last read data
  static Future<void> clearLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_surahNumberKey);
    await prefs.remove(_surahEnglishNameKey);
    await prefs.remove(_ayahNumberKey);
    await prefs.remove(_progressPercentageKey);
    await prefs.remove(_lastReadAtKey);
    await prefs.remove(_juzzNumberKey);
  }

  // Check if user has any reading history
  static Future<bool> hasLastRead() async {
    final lastRead = await getLastRead();
    return lastRead != null;
  }

  // Save from JuzzAyah model - moved from extension to main class
  static Future<void> saveLastReadFromJuzzAyah({
    required dynamic juzzAyah, // JuzzAyah type
    required int juzzNumber,
  }) async {
    final lastReadData = LastReadData(
      surahNumber: juzzAyah.surah.number,
      surahEnglishName: juzzAyah.surah.englishName,
      ayahNumber: juzzAyah.numberInSurah,
      progressPercentage:
          (juzzAyah.numberInSurah / juzzAyah.surah.numberOfAyahs) * 100,
      lastReadAt: DateTime.now(),
      juzzNumber: juzzNumber,
    );

    await LastReadService.saveLastRead(lastReadData);
  }
}

class LastReadData {
  final int surahNumber;
  final String surahEnglishName;
  final int ayahNumber;
  final double progressPercentage;
  final DateTime lastReadAt;
  final int? juzzNumber; // Optional Juzz number

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
