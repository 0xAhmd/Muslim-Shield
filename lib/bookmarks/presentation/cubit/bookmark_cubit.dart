

import '../../model/bookmark.dart';
import 'bookmark_state.dart';
import '../../service/bookmark_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final BookmarksService _bookmarksService;

  BookmarksCubit(this._bookmarksService) : super(BookmarksInitial());

  Future<void> loadBookmarks() async {
    try {
      emit(BookmarksLoading());
      
      final bookmarks = await _bookmarksService.getAllBookmarks();
      // Sort by creation date (newest first)
      bookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      final count = await _bookmarksService.getBookmarksCount();
      
      emit(BookmarksLoaded(
        bookmarks: bookmarks,
        filteredBookmarks: bookmarks,
        totalCount: count,
      ));
    } catch (e) {
      emit(BookmarksError('Failed to load bookmarks: ${e.toString()}'));
    }
  }

  Future<void> searchBookmarks(String query) async {
    final currentState = state;
    if (currentState is BookmarksLoaded) {
      try {
        if (query.isEmpty) {
          emit(currentState.copyWith(
            filteredBookmarks: currentState.bookmarks,
            searchQuery: '',
            clearSelectedType: true,
          ));
        } else {
          final filteredBookmarks = await _bookmarksService.searchBookmarks(query);
          filteredBookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          emit(currentState.copyWith(
            filteredBookmarks: filteredBookmarks,
            searchQuery: query,
            clearSelectedType: true,
          ));
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
        
        emit(currentState.copyWith(
          filteredBookmarks: filteredBookmarks,
          selectedType: type,
          searchQuery: '', // Clear search when filtering
        ));
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
      emit(currentState.copyWith(
        filteredBookmarks: currentState.bookmarks,
        searchQuery: '',
        clearSelectedType: true,
      ));
    }
  }

  // Helper methods for checking bookmark status (used in other screens)
  Future<bool> isAyahBookmarked(int surahNumber, int ayahNumber) async {
    return await _bookmarksService.isAyahBookmarked(surahNumber, ayahNumber);
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
}