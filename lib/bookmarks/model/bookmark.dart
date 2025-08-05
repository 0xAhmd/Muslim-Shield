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
    required String reference,
    String? category,
  }) {
    final snippet = text.length > 100 ? '${text.substring(0, 100)}...' : text;

    return BookmarkModel(
      id: 'hadith_$hadithId',
      title: title,
      content: text,
      snippet: snippet,
      type: BookmarkType.hadith,
      reference: reference,
      category: category,
      createdAt: DateTime.now(),
      metadata: {'text': text, 'reference': reference},
    );
  }

  // Getters for easy access to metadata
  String? get translation => metadata?['translation'];
  String? get transliteration => metadata?['transliteration'];
  int? get surahNumber => metadata?['surahNumber'];
  int? get ayahNumber => metadata?['ayahNumber'];
  String? get surahName => metadata?['surahName'];

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
  other;

  String get displayName {
    switch (this) {
      case BookmarkType.ayah:
        return 'Quran';
      case BookmarkType.dua:
        return 'Dua';
      case BookmarkType.hadith:
        return 'Hadith';
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
      case BookmarkType.other:
        return '⭐';
    }
  }
}
