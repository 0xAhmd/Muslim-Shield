import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 0)
class BookmarkModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String snippet;

  @HiveField(4)
  final BookmarkType type;

  @HiveField(5)
  final String? reference;

  @HiveField(6)
  final String? category;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final Map<String, dynamic>? metadata;

  BookmarkModel({
    required this.id,
    required this.title,
    required this.content,
    required this.snippet,
    required this.type,
    this.reference,
    this.category,
    required this.createdAt,
    this.metadata,
  });

  // Factory constructors for different content types
  factory BookmarkModel.fromAyah({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
    required String ayahText,
    required String translation,
  }) {
    final id = 'ayah_${surahNumber}_$ayahNumber';
    final snippet = ayahText.length > 100
        ? '${ayahText.substring(0, 100)}...'
        : ayahText;

    return BookmarkModel(
      id: id,
      title: '$surahName - Ayah $ayahNumber',
      content: ayahText,
      snippet: snippet,
      type: BookmarkType.ayah,
      reference: 'Surah $surahNumber:$ayahNumber',
      createdAt: DateTime.now(),
      metadata: {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'surahName': surahName,
        'translation': translation,
      },
    );
  }

  // Replace your BookmarkModel.fromSurah factory constructor with this debug version

  factory BookmarkModel.fromSurah({
    required int surahNumber,
    required String surahName,
    required String englishName,
    required String revelationType,
    required int numberOfAyahs,
    required String englishNameTranslation,
    List<dynamic>? ayahs, // Complete ayah data
    Map<String, String>? translations, // Ayah translations by verse number
  }) {
    debugPrint('BookmarkModel.fromSurah: Creating bookmark...');
    debugPrint('BookmarkModel.fromSurah: surahNumber: $surahNumber');
    debugPrint('BookmarkModel.fromSurah: surahName: $surahName');
    debugPrint('BookmarkModel.fromSurah: englishName: $englishName');
    debugPrint('BookmarkModel.fromSurah: revelationType: $revelationType');
    debugPrint('BookmarkModel.fromSurah: numberOfAyahs: $numberOfAyahs');
    debugPrint(
      'BookmarkModel.fromSurah: englishNameTranslation: $englishNameTranslation',
    );
    debugPrint('BookmarkModel.fromSurah: ayahs length: ${ayahs?.length ?? 0}');

    final id = 'surah_$surahNumber';
    debugPrint('BookmarkModel.fromSurah: Generated ID: $id');

    final snippet =
        '$numberOfAyahs verses • $revelationType • Available Offline';
    debugPrint('BookmarkModel.fromSurah: Generated snippet: $snippet');

    // Process ayahs to include all necessary data for offline reading
    List<Map<String, dynamic>>? processedAyahs;
    if (ayahs != null) {
      debugPrint(
        'BookmarkModel.fromSurah: Processing ${ayahs.length} ayahs...',
      );
      try {
        processedAyahs = ayahs.map((ayah) {
          // Handle different ayah object types
          int ayahNumber;
          String ayahText;
          int ayahGlobalNumber;

          // Check if ayah is a Map or an object with properties
          if (ayah is Map) {
            ayahNumber = ayah['numberInSurah'] ?? ayah['number'] ?? 0;
            ayahText = ayah['text'] ?? '';
            ayahGlobalNumber = ayah['number'] ?? 0;
          } else {
            // Assume it's an object with properties
            ayahNumber = ayah.numberInSurah ?? ayah.number ?? 0;
            ayahText = ayah.text ?? '';
            ayahGlobalNumber = ayah.number ?? 0;
          }

          return {
            'numberInSurah': ayahNumber,
            'text': ayahText,
            'number': ayahGlobalNumber,
            'translation':
                translations?[ayahNumber.toString()] ??
                '', // Add translation if available
            'transliteration':
                '', // Can be added if you have transliteration data
          };
        }).toList();
        debugPrint(
          'BookmarkModel.fromSurah: Successfully processed ${processedAyahs.length} ayahs',
        );
      } catch (e, stackTrace) {
        debugPrint('BookmarkModel.fromSurah: Error processing ayahs: $e');
        debugPrint('BookmarkModel.fromSurah: Stack trace: $stackTrace');
        processedAyahs = [];
      }
    } else {
      debugPrint('BookmarkModel.fromSurah: No ayahs provided');
      processedAyahs = [];
    }

    try {
      final bookmark = BookmarkModel(
        id: id,
        title: surahName,
        content: englishNameTranslation,
        snippet: snippet,
        type: BookmarkType.surah,
        reference: 'Surah $surahNumber',
        createdAt: DateTime.now(),
        metadata: {
          'surahNumber': surahNumber,
          'surahName': surahName,
          'englishName': englishName,
          'revelationType': revelationType,
          'numberOfAyahs': numberOfAyahs,
          'englishNameTranslation': englishNameTranslation,
          'ayahs':
              processedAyahs, // Store ALL ayahs for complete offline access
          'isComplete': true, // Flag to indicate this is a complete surah
          'downloadedAt': DateTime.now().toIso8601String(),
        },
      );

      debugPrint('BookmarkModel.fromSurah: Successfully created bookmark');
      debugPrint('BookmarkModel.fromSurah: Final bookmark ID: ${bookmark.id}');
      debugPrint(
        'BookmarkModel.fromSurah: Final bookmark type: ${bookmark.type}',
      );
      debugPrint(
        'BookmarkModel.fromSurah: Final bookmark title: ${bookmark.title}',
      );

      return bookmark;
    } catch (e, stackTrace) {
      debugPrint('BookmarkModel.fromSurah: Error creating BookmarkModel: $e');
      debugPrint('BookmarkModel.fromSurah: Stack trace: $stackTrace');
      rethrow;
    }
  }

  factory BookmarkModel.fromDua({
    required String duaId,
    required String title,
    required String arabic,
    required String translation,
    required String category,
    String? transliteration,
    String? reference,
  }) {
    final snippet = translation.length > 100
        ? '${translation.substring(0, 100)}...'
        : translation;

    return BookmarkModel(
      id: 'dua_$duaId',
      title: title,
      content: arabic,
      snippet: snippet,
      type: BookmarkType.dua,
      reference: reference,
      category: category,
      createdAt: DateTime.now(),
      metadata: {
        'arabic': arabic,
        'translation': translation,
        'transliteration': transliteration,
        'category': category,
      },
    );
  }

  factory BookmarkModel.fromHadith({
    required String hadithId,
    required String title,
    required String text,
    String? arabicText,
    required String reference,
    String? category,
  }) {
    final snippet = text.length > 100 ? '${text.substring(0, 100)}...' : text;

    return BookmarkModel(
      id: 'hadith_$hadithId',
      title: title,
      content: arabicText ?? text,
      snippet: snippet,
      type: BookmarkType.hadith,
      reference: reference,
      category: category,
      createdAt: DateTime.now(),
      metadata: {
        'text': text,
        'arabicText': arabicText,
        'reference': reference,
      },
    );
  }

  // Getters for easy access to metadata
  String? get englishText => metadata?['text'];
  String? get arabicText => metadata?['arabicText'];
  String? get translation => metadata?['translation'];
  String? get transliteration => metadata?['transliteration'];
  int? get surahNumber => metadata?['surahNumber'];
  int? get ayahNumber => metadata?['ayahNumber'];
  String? get surahName => metadata?['surahName'];

  // NEW: Surah-specific getters
  String? get englishName => metadata?['englishName'];
  String? get revelationType => metadata?['revelationType'];
  int? get numberOfAyahs => metadata?['numberOfAyahs'];
  String? get englishNameTranslation => metadata?['englishNameTranslation'];
  List<dynamic>? get ayahs => metadata?['ayahs'];

  @override
  String toString() {
    return 'BookmarkModel(id: $id, title: $title, type: $type)';
  }
}

@HiveType(typeId: 1)
enum BookmarkType {
  @HiveField(0)
  ayah,

  @HiveField(1)
  dua,

  @HiveField(2)
  hadith,

  @HiveField(3)
  other,

  @HiveField(4) // NEW: Add surah type
  surah;

  String get displayName {
    switch (this) {
      case BookmarkType.ayah:
        return 'Ayah';
      case BookmarkType.dua:
        return 'Dua';
      case BookmarkType.hadith:
        return 'Hadith';
      case BookmarkType.surah:
        return 'Surah';
      case BookmarkType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case BookmarkType.ayah:
        return '📖';
      case BookmarkType.dua:
        return '🤲';
      case BookmarkType.hadith:
        return '📚';
      case BookmarkType.surah:
        return '📜';
      case BookmarkType.other:
        return '⭐';
    }
  }
}
