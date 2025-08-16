// Updated lib/bookmarks/service/bookmark_service.dart
import '../model/bookmark.dart';
import 'package:hive/hive.dart';

class LocalBookmarksSource {
  static const String _boxName = 'bookmarks';
  Box<BookmarkModel>? _box;

  // Initialize Hive box
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<BookmarkModel>(_boxName);
    } else {
      _box = Hive.box<BookmarkModel>(_boxName);
    }
  }

  // Add bookmark
  Future<void> addBookmark(BookmarkModel bookmark) async {
    await _ensureBoxOpen();
    await _box!.put(bookmark.id, bookmark);
  }

  // Remove bookmark
  Future<void> removeBookmark(String bookmarkId) async {
    await _ensureBoxOpen();
    await _box!.delete(bookmarkId);
  }

  // Get all bookmarks
  Future<List<BookmarkModel>> getAllBookmarks() async {
    await _ensureBoxOpen();
    return _box!.values.toList();
  }

  // Get bookmarks by type
  Future<List<BookmarkModel>> getBookmarksByType(BookmarkType type) async {
    await _ensureBoxOpen();
    return _box!.values.where((bookmark) => bookmark.type == type).toList();
  }

  // Check if item is bookmarked
  Future<bool> isBookmarked(String bookmarkId) async {
    await _ensureBoxOpen();
    return _box!.containsKey(bookmarkId);
  }

  // Get bookmark by ID
  Future<BookmarkModel?> getBookmark(String bookmarkId) async {
    await _ensureBoxOpen();
    return _box!.get(bookmarkId);
  }

  // Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    await _ensureBoxOpen();
    await _box!.clear();
  }

  // Get bookmarks count
  Future<int> getBookmarksCount() async {
    await _ensureBoxOpen();
    return _box!.length;
  }

  // Search bookmarks
  Future<List<BookmarkModel>> searchBookmarks(String query) async {
    await _ensureBoxOpen();
    final lowercaseQuery = query.toLowerCase();

    return _box!.values.where((bookmark) {
      return bookmark.title.toLowerCase().contains(lowercaseQuery) ||
          bookmark.content.toLowerCase().contains(lowercaseQuery) ||
          bookmark.snippet.toLowerCase().contains(lowercaseQuery) ||
          (bookmark.category?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  // Get recent bookmarks (last 10)
  Future<List<BookmarkModel>> getRecentBookmarks({int limit = 10}) async {
    await _ensureBoxOpen();
    final bookmarks = _box!.values.toList();
    bookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return bookmarks.take(limit).toList();
  }

  // Private helper to ensure box is open
  Future<void> _ensureBoxOpen() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
  }

  // Close the box
  Future<void> close() async {
    if (_box?.isOpen == true) {
      await _box!.close();
    }
  }
}

// Service class to handle bookmark operations
class BookmarksService {
  static final BookmarksService _instance = BookmarksService._internal();
  factory BookmarksService() => _instance;
  BookmarksService._internal();

  final LocalBookmarksSource _localSource = LocalBookmarksSource();

  Future<void> init() async {
    await _localSource.init();
  }

  // Bookmark an Ayah
  Future<void> bookmarkAyah({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
    required String ayahText,
    required String translation,
  }) async {
    final bookmark = BookmarkModel.fromAyah(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      surahName: surahName,
      ayahText: ayahText,
      translation: translation,
    );
    await _localSource.addBookmark(bookmark);
  }

  // NEW: Bookmark entire Surah
  Future<void> bookmarkSurah({
    required int surahNumber,
    required String surahName,
    required String englishName,
    required String revelationType,
    required int numberOfAyahs,
    required String englishNameTranslation,
    List<dynamic>? ayahs, // Complete ayah data
    Map<String, String>? translations, // Ayah translations by verse number
  }) async {
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
    await _localSource.addBookmark(bookmark);
  }

  // Bookmark a Dua
  Future<void> bookmarkDua({
    required String duaId,
    required String title,
    required String arabic,
    required String translation,
    required String category,
    String? transliteration,
    String? reference,
  }) async {
    final bookmark = BookmarkModel.fromDua(
      duaId: duaId,
      title: title,
      arabic: arabic,
      translation: translation,
      category: category,
      transliteration: transliteration,
      reference: reference,
    );
    await _localSource.addBookmark(bookmark);
  }

  // Bookmark a Hadith
  Future<void> bookmarkHadith({
    required String hadithId,
    required String title,
    required String text,
    String? arabicText,
    required String reference,
    String? category,
  }) async {
    final bookmark = BookmarkModel.fromHadith(
      hadithId: hadithId,
      title: title,
      text: text,
      arabicText: arabicText,
      reference: reference,
      category: category,
    );
    await _localSource.addBookmark(bookmark);
  }

  // Check if Ayah is bookmarked
  Future<bool> isAyahBookmarked(int surahNumber, int ayahNumber) async {
    final id = 'ayah_${surahNumber}_$ayahNumber';
    return await _localSource.isBookmarked(id);
  }

  // NEW: Check if Surah is bookmarked
  Future<bool> isSurahBookmarked(int surahNumber) async {
    final id = 'surah_$surahNumber';
    return await _localSource.isBookmarked(id);
  }

  // Check if Dua is bookmarked
  Future<bool> isDuaBookmarked(String duaId) async {
    final id = 'dua_$duaId';
    return await _localSource.isBookmarked(id);
  }

  // Check if Hadith is bookmarked
  Future<bool> isHadithBookmarked(String hadithId) async {
    final id = 'hadith_$hadithId';
    return await _localSource.isBookmarked(id);
  }

  // Remove Ayah bookmark
  Future<void> removeAyahBookmark(int surahNumber, int ayahNumber) async {
    final id = 'ayah_${surahNumber}_$ayahNumber';
    await _localSource.removeBookmark(id);
  }

  // NEW: Remove Surah bookmark
  Future<void> removeSurahBookmark(int surahNumber) async {
    final id = 'surah_$surahNumber';
    await _localSource.removeBookmark(id);
  }

  // Remove Dua bookmark
  Future<void> removeDuaBookmark(String duaId) async {
    final id = 'dua_$duaId';
    await _localSource.removeBookmark(id);
  }

  // Remove Hadith bookmark
  Future<void> removeHadithBookmark(String hadithId) async {
    final id = 'hadith_$hadithId';
    await _localSource.removeBookmark(id);
  }

  // Remove any bookmark by ID
  Future<void> removeBookmark(String bookmarkId) async {
    await _localSource.removeBookmark(bookmarkId);
  }

  // Get all bookmarks
  Future<List<BookmarkModel>> getAllBookmarks() async {
    return await _localSource.getAllBookmarks();
  }

  // Get bookmarks by type
  Future<List<BookmarkModel>> getBookmarksByType(BookmarkType type) async {
    return await _localSource.getBookmarksByType(type);
  }

  // NEW: Get all Surah bookmarks
  Future<List<BookmarkModel>> getSurahBookmarks() async {
    return await _localSource.getBookmarksByType(BookmarkType.surah);
  }

  // NEW: Get specific bookmarked Surah by number
  Future<BookmarkModel?> getBookmarkedSurah(int surahNumber) async {
    final id = 'surah_$surahNumber';
    return await _localSource.getBookmark(id);
  }

  // Get all Hadith bookmarks
  Future<List<BookmarkModel>> getHadithBookmarks() async {
    return await _localSource.getBookmarksByType(BookmarkType.hadith);
  }

  // Search bookmarks
  Future<List<BookmarkModel>> searchBookmarks(String query) async {
    return await _localSource.searchBookmarks(query);
  }

  // Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    await _localSource.clearAllBookmarks();
  }

  // Get bookmarks count
  Future<int> getBookmarksCount() async {
    return await _localSource.getBookmarksCount();
  }

  // Get recent bookmarks
  Future<List<BookmarkModel>> getRecentBookmarks({int limit = 10}) async {
    return await _localSource.getRecentBookmarks(limit: limit);
  }
}