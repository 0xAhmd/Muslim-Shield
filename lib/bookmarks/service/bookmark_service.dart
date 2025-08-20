// lib/bookmarks/service/bookmark_service.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/bookmark.dart';

class BookmarksService {
  static const String _boxName = 'bookmarks';
  Box<BookmarkModel>? _box;

  // Singleton pattern
  static final BookmarksService _instance = BookmarksService._internal();
  factory BookmarksService() => _instance;
  BookmarksService._internal();

  // Initialize the service - called from AppInitializer
  Future<void> init() async {
    try {
      debugPrint('BookmarksService: Initializing...');
      await _ensureBoxOpen();
      debugPrint(
        'BookmarksService: Initialization complete. Box has ${_box!.length} bookmarks',
      );

      // Debug: Print all existing bookmarks
      final bookmarks = _box!.values.toList();
      for (var bookmark in bookmarks) {
        debugPrint(
          'BookmarksService: Existing bookmark - ${bookmark.type.displayName}: ${bookmark.title}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('BookmarksService: Error during initialization: $e');
      debugPrint('BookmarksService: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Ensure Hive box is open
  Future<void> _ensureBoxOpen() async {
    if (_box == null || !_box!.isOpen) {
      try {
        _box = await Hive.openBox<BookmarkModel>(_boxName);
        debugPrint('BookmarksService: Box opened successfully');
      } catch (e) {
        debugPrint('BookmarksService: Error opening box: $e');
        rethrow;
      }
    }
  }

  // Get all bookmarks
  Future<List<BookmarkModel>> getAllBookmarks() async {
    await _ensureBoxOpen();
    final bookmarks = _box!.values.toList();
    debugPrint(
      'BookmarksService: getAllBookmarks() - Found ${bookmarks.length} bookmarks',
    );
    for (var bookmark in bookmarks) {
      debugPrint(
        'BookmarksService: ${bookmark.type.displayName} - ${bookmark.title}',
      );
    }
    return bookmarks;
  }

  // Get bookmarks count
  Future<int> getBookmarksCount() async {
    await _ensureBoxOpen();
    return _box!.length;
  }

  // Search bookmarks
  Future<List<BookmarkModel>> searchBookmarks(String query) async {
    await _ensureBoxOpen();
    if (query.isEmpty) return getAllBookmarks();

    final allBookmarks = _box!.values.toList();
    return allBookmarks.where((bookmark) {
      final searchText = query.toLowerCase();
      return bookmark.title.toLowerCase().contains(searchText) ||
          bookmark.content.toLowerCase().contains(searchText) ||
          bookmark.snippet.toLowerCase().contains(searchText) ||
          (bookmark.reference?.toLowerCase().contains(searchText) ?? false) ||
          (bookmark.category?.toLowerCase().contains(searchText) ?? false);
    }).toList();
  }

  // Get bookmarks by type
  Future<List<BookmarkModel>> getBookmarksByType(BookmarkType type) async {
    await _ensureBoxOpen();
    final allBookmarks = _box!.values.toList();
    return allBookmarks.where((bookmark) => bookmark.type == type).toList();
  }

  // Remove bookmark by ID
  Future<void> removeBookmark(String bookmarkId) async {
    await _ensureBoxOpen();
    await _box!.delete(bookmarkId);
    debugPrint('BookmarksService: Removed bookmark with ID: $bookmarkId');
  }

  // Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    await _ensureBoxOpen();
    await _box!.clear();
    debugPrint('BookmarksService: Cleared all bookmarks');
  }

  // AYAH BOOKMARK METHODS
  Future<bool> isAyahBookmarked(int surahNumber, int ayahNumber) async {
    await _ensureBoxOpen();
    final bookmarkId = 'ayah_${surahNumber}_$ayahNumber';
    return _box!.containsKey(bookmarkId);
  }

  Future<void> bookmarkAyah({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
    required String ayahText,
    required String translation,
  }) async {
    await _ensureBoxOpen();

    final bookmark = BookmarkModel.fromAyah(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      surahName: surahName,
      ayahText: ayahText,
      translation: translation,
    );

    await _box!.put(bookmark.id, bookmark);
    debugPrint('BookmarksService: Saved Ayah bookmark - ${bookmark.title}');
  }

  Future<void> removeAyahBookmark(int surahNumber, int ayahNumber) async {
    await _ensureBoxOpen();
    final bookmarkId = 'ayah_${surahNumber}_$ayahNumber';
    await _box!.delete(bookmarkId);
    debugPrint('BookmarksService: Removed Ayah bookmark - $bookmarkId');
  }

  // SURAH BOOKMARK METHODS
  Future<bool> isSurahBookmarked(int surahNumber) async {
    await _ensureBoxOpen();
    final bookmarkId = 'surah_$surahNumber';
    final isBookmarked = _box!.containsKey(bookmarkId);
    debugPrint(
      'BookmarksService: Checking Surah $surahNumber bookmark status: $isBookmarked',
    );
    return isBookmarked;
  }

  Future<void> bookmarkSurah({
    required int surahNumber,
    required String surahName,
    required String englishName,
    required String revelationType,
    required int numberOfAyahs,
    required String englishNameTranslation,
    List<dynamic>? ayahs,
    Map<String, String>? translations,
  }) async {
    await _ensureBoxOpen();

    debugPrint('BookmarksService: Starting to save Surah bookmark...');
    debugPrint('BookmarksService: Surah Number: $surahNumber');
    debugPrint('BookmarksService: Surah Name: $surahName');
    debugPrint('BookmarksService: English Name: $englishName');
    debugPrint('BookmarksService: Revelation Type: $revelationType');
    debugPrint('BookmarksService: Number of Ayahs: $numberOfAyahs');
    debugPrint(
      'BookmarksService: English Name Translation: $englishNameTranslation',
    );
    debugPrint('BookmarksService: Ayahs data length: ${ayahs?.length ?? 0}');

    try {
      final bookmark = BookmarkModel.fromSurah(
        surahNumber: surahNumber,
        surahName: surahName,
        englishName: englishName,
        revelationType: revelationType,
        numberOfAyahs: numberOfAyahs,
        englishNameTranslation: englishNameTranslation,
        ayahs: ayahs,
        translations: translations,
      );

      debugPrint('BookmarksService: Created bookmark with ID: ${bookmark.id}');
      debugPrint('BookmarksService: Bookmark type: ${bookmark.type}');
      debugPrint('BookmarksService: Bookmark title: ${bookmark.title}');
      debugPrint('BookmarksService: Bookmark content: ${bookmark.content}');
      debugPrint('BookmarksService: Bookmark snippet: ${bookmark.snippet}');

      await _box!.put(bookmark.id, bookmark);

      debugPrint(
        'BookmarksService: Successfully saved Surah bookmark - ${bookmark.title}',
      );

      // Verify it was saved
      final saved = _box!.get(bookmark.id);
      if (saved != null) {
        debugPrint(
          'BookmarksService: Verification successful - bookmark exists in storage',
        );
        debugPrint('BookmarksService: Saved bookmark type: ${saved.type}');
        debugPrint('BookmarksService: Saved bookmark title: ${saved.title}');
      } else {
        debugPrint(
          'BookmarksService: ERROR - bookmark was not saved properly!',
        );
      }

      // Print total bookmarks count
      debugPrint(
        'BookmarksService: Total bookmarks in storage: ${_box!.length}',
      );
    } catch (e, stackTrace) {
      debugPrint('BookmarksService: Error creating/saving Surah bookmark: $e');
      debugPrint('BookmarksService: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> removeSurahBookmark(int surahNumber) async {
    await _ensureBoxOpen();
    final bookmarkId = 'surah_$surahNumber';
    await _box!.delete(bookmarkId);
    debugPrint('BookmarksService: Removed Surah bookmark - $bookmarkId');
  }

  Future<BookmarkModel?> getBookmarkedSurah(int surahNumber) async {
    await _ensureBoxOpen();
    final bookmarkId = 'surah_$surahNumber';
    return _box!.get(bookmarkId);
  }

  // DUA BOOKMARK METHODS
  Future<bool> isDuaBookmarked(String duaId) async {
    await _ensureBoxOpen();
    final bookmarkId = 'dua_$duaId';
    return _box!.containsKey(bookmarkId);
  }

  Future<void> bookmarkDua({
    required String duaId,
    required String title,
    required String arabic,
    required String translation,
    required String category,
    String? transliteration,
    String? reference,
  }) async {
    await _ensureBoxOpen();

    final bookmark = BookmarkModel.fromDua(
      duaId: duaId,
      title: title,
      arabic: arabic,
      translation: translation,
      category: category,
      transliteration: transliteration,
      reference: reference,
    );

    await _box!.put(bookmark.id, bookmark);
    debugPrint('BookmarksService: Saved Dua bookmark - ${bookmark.title}');
  }

  Future<void> removeDuaBookmark(String duaId) async {
    await _ensureBoxOpen();
    final bookmarkId = 'dua_$duaId';
    await _box!.delete(bookmarkId);
    debugPrint('BookmarksService: Removed Dua bookmark - $bookmarkId');
  }

  // HADITH BOOKMARK METHODS
  Future<bool> isHadithBookmarked(String hadithId) async {
    await _ensureBoxOpen();
    final bookmarkId = 'hadith_$hadithId';
    return _box!.containsKey(bookmarkId);
  }

  Future<void> bookmarkHadith({
    required String hadithId,
    required String title,
    required String text,
    String? arabicText,
    required String reference,
    String? category,
  }) async {
    await _ensureBoxOpen();

    final bookmark = BookmarkModel.fromHadith(
      hadithId: hadithId,
      title: title,
      text: text,
      arabicText: arabicText,
      reference: reference,
      category: category,
    );

    await _box!.put(bookmark.id, bookmark);
    debugPrint('BookmarksService: Saved Hadith bookmark - ${bookmark.title}');
  }

  Future<void> removeHadithBookmark(String hadithId) async {
    await _ensureBoxOpen();
    final bookmarkId = 'hadith_$hadithId';
    await _box!.delete(bookmarkId);
    debugPrint('BookmarksService: Removed Hadith bookmark - $bookmarkId');
  }

  // Close the box when not needed
  Future<void> close() async {
    if (_box?.isOpen == true) {
      await _box!.close();
    }
  }
}
