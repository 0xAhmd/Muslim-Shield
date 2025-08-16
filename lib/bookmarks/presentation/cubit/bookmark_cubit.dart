// Updated lib/bookmarks/presentation/cubit/bookmark_cubit.dart

import 'package:flutter/material.dart';

import '../../model/bookmark.dart';
import 'bookmark_state.dart';
import '../../service/bookmark_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final BookmarksService _bookmarksService;

  BookmarksCubit(this._bookmarksService) : super(BookmarksInitial());

  Future<void> searchBookmarks(String query) async {
    final currentState = state;
    if (currentState is BookmarksLoaded) {
      try {
        if (query.isEmpty) {
          emit(
            currentState.copyWith(
              filteredBookmarks: currentState.bookmarks,
              searchQuery: '',
              clearSelectedType: true,
            ),
          );
        } else {
          final filteredBookmarks = await _bookmarksService.searchBookmarks(
            query,
          );
          filteredBookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          emit(
            currentState.copyWith(
              filteredBookmarks: filteredBookmarks,
              searchQuery: query,
              clearSelectedType: true,
            ),
          );
        }
      } catch (e) {
        emit(BookmarksError('Search failed: ${e.toString()}'));
      }
    }
  }

  Future<void> filterByType(BookmarkType? type) async {
    final currentState = state;
    if (currentState is BookmarksLoaded) {
      try {
        List<BookmarkModel> filteredBookmarks;

        if (type == null) {
          filteredBookmarks = currentState.bookmarks;
        } else {
          filteredBookmarks = await _bookmarksService.getBookmarksByType(type);
          filteredBookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }

        emit(
          currentState.copyWith(
            filteredBookmarks: filteredBookmarks,
            selectedType: type,
            searchQuery: '', // Clear search when filtering
          ),
        );
      } catch (e) {
        emit(BookmarksError('Filter failed: ${e.toString()}'));
      }
    }
  }

  Future<void> removeBookmark(String bookmarkId) async {
    try {
      emit(BookmarkActionLoading());

      await _bookmarksService.removeBookmark(bookmarkId);

      emit(BookmarkActionSuccess('Bookmark removed successfully'));

      // Reload bookmarks
      await loadBookmarks();
    } catch (e) {
      emit(BookmarksError('Failed to remove bookmark: ${e.toString()}'));
    }
  }

  Future<void> clearAllBookmarks() async {
    try {
      emit(BookmarkActionLoading());

      await _bookmarksService.clearAllBookmarks();

      emit(BookmarkActionSuccess('All bookmarks cleared'));

      // Reload bookmarks
      await loadBookmarks();
    } catch (e) {
      emit(BookmarksError('Failed to clear bookmarks: ${e.toString()}'));
    }
  }

  void clearFilters() {
    final currentState = state;
    if (currentState is BookmarksLoaded) {
      emit(
        currentState.copyWith(
          filteredBookmarks: currentState.bookmarks,
          searchQuery: '',
          clearSelectedType: true,
        ),
      );
    }
  }

  // Helper methods for checking bookmark status (used in other screens)
  Future<bool> isAyahBookmarked(int surahNumber, int ayahNumber) async {
    return await _bookmarksService.isAyahBookmarked(surahNumber, ayahNumber);
  }

  // NEW: Check if Surah is bookmarked
  Future<bool> isSurahBookmarked(int surahNumber) async {
    return await _bookmarksService.isSurahBookmarked(surahNumber);
  }

  Future<bool> isDuaBookmarked(String duaId) async {
    return await _bookmarksService.isDuaBookmarked(duaId);
  }

  // Bookmark actions (used in other screens)
  Future<void> bookmarkAyah({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
    required String ayahText,
    required String translation,
  }) async {
    try {
      await _bookmarksService.bookmarkAyah(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: surahName,
        ayahText: ayahText,
        translation: translation,
      );

      emit(BookmarkActionSuccess('Ayah bookmarked successfully'));
    } catch (e) {
      emit(BookmarksError('Failed to bookmark ayah: ${e.toString()}'));
    }
  }

  // NEW: Bookmark entire Surah
  // Replace your bookmarkSurah method in BookmarksCubit with this debug version

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
    try {
      debugPrint('BookmarksCubit: bookmarkSurah called');
      debugPrint('BookmarksCubit: surahNumber: $surahNumber');
      debugPrint('BookmarksCubit: surahName: $surahName');
      debugPrint('BookmarksCubit: englishName: $englishName');
      debugPrint('BookmarksCubit: revelationType: $revelationType');
      debugPrint('BookmarksCubit: numberOfAyahs: $numberOfAyahs');
      debugPrint('BookmarksCubit: englishNameTranslation: $englishNameTranslation');
      debugPrint('BookmarksCubit: ayahs length: ${ayahs?.length ?? 0}');

      debugPrint('BookmarksCubit: Calling _bookmarksService.bookmarkSurah...');

      await _bookmarksService.bookmarkSurah(
        surahNumber: surahNumber,
        surahName: surahName,
        englishName: englishName,
        revelationType: revelationType,
        numberOfAyahs: numberOfAyahs,
        englishNameTranslation: englishNameTranslation,
        ayahs: ayahs,
        translations: translations,
      );

      debugPrint(
        'BookmarksCubit: _bookmarksService.bookmarkSurah completed successfully',
      );

      emit(BookmarkActionSuccess('Surah bookmarked for offline access'));

      debugPrint('BookmarksCubit: Emitted BookmarkActionSuccess');
    } catch (e, stackTrace) {
      debugPrint('BookmarksCubit: Error in bookmarkSurah: $e');
      debugPrint('BookmarksCubit: Stack trace: $stackTrace');
      emit(BookmarksError('Failed to bookmark surah: ${e.toString()}'));
    }
  }

  // Also add debug logging to loadBookmarks method
  Future<void> loadBookmarks() async {
    try {
      debugPrint('BookmarksCubit: loadBookmarks called');
      emit(BookmarksLoading());

      debugPrint('BookmarksCubit: Calling _bookmarksService.getAllBookmarks()...');
      final bookmarks = await _bookmarksService.getAllBookmarks();

      debugPrint(
        'BookmarksCubit: Received ${bookmarks.length} bookmarks from service',
      );

      // Sort by creation date (newest first)
      bookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final count = await _bookmarksService.getBookmarksCount();
      debugPrint('BookmarksCubit: Bookmarks count: $count');

      // Debug: Print all bookmarks with their types
      for (var bookmark in bookmarks) {
        debugPrint(
          'BookmarksCubit: Bookmark - Type: ${bookmark.type.displayName}, Title: ${bookmark.title}, ID: ${bookmark.id}',
        );
      }

      emit(
        BookmarksLoaded(
          bookmarks: bookmarks,
          filteredBookmarks: bookmarks,
          totalCount: count,
        ),
      );

      debugPrint(
        'BookmarksCubit: Emitted BookmarksLoaded with ${bookmarks.length} bookmarks',
      );
    } catch (e, stackTrace) {
      debugPrint('BookmarksCubit: Error in loadBookmarks: $e');
      debugPrint('BookmarksCubit: Stack trace: $stackTrace');
      emit(BookmarksError('Failed to load bookmarks: ${e.toString()}'));
    }
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
    try {
      await _bookmarksService.bookmarkDua(
        duaId: duaId,
        title: title,
        arabic: arabic,
        translation: translation,
        category: category,
        transliteration: transliteration,
        reference: reference,
      );

      emit(BookmarkActionSuccess('Dua bookmarked successfully'));
    } catch (e) {
      emit(BookmarksError('Failed to bookmark dua: ${e.toString()}'));
    }
  }

  Future<void> removeAyahBookmark(int surahNumber, int ayahNumber) async {
    try {
      await _bookmarksService.removeAyahBookmark(surahNumber, ayahNumber);
      emit(BookmarkActionSuccess('Bookmark removed'));
    } catch (e) {
      emit(BookmarksError('Failed to remove bookmark: ${e.toString()}'));
    }
  }

  // NEW: Remove Surah bookmark
  Future<void> removeSurahBookmark(int surahNumber) async {
    try {
      await _bookmarksService.removeSurahBookmark(surahNumber);
      emit(BookmarkActionSuccess('Surah bookmark removed'));
    } catch (e) {
      emit(BookmarksError('Failed to remove surah bookmark: ${e.toString()}'));
    }
  }

  Future<void> removeDuaBookmark(String duaId) async {
    try {
      await _bookmarksService.removeDuaBookmark(duaId);
      emit(BookmarkActionSuccess('Bookmark removed'));
    } catch (e) {
      emit(BookmarksError('Failed to remove bookmark: ${e.toString()}'));
    }
  }

  // Get bookmarks count for display
  Future<int> getBookmarksCount() async {
    return await _bookmarksService.getBookmarksCount();
  }

  // NEW: Get specific bookmarked Surah
  Future<BookmarkModel?> getBookmarkedSurah(int surahNumber) async {
    return await _bookmarksService.getBookmarkedSurah(surahNumber);
  }
}
