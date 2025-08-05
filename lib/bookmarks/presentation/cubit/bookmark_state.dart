import 'package:azkar/bookmarks/model/bookmark.dart';

abstract class BookmarksState {}

class BookmarksInitial extends BookmarksState {}

class BookmarksLoading extends BookmarksState {}

class BookmarksLoaded extends BookmarksState {
  final List<BookmarkModel> bookmarks;
  final List<BookmarkModel> filteredBookmarks;
  final String searchQuery;
  final BookmarkType? selectedType;
  final int totalCount;

  BookmarksLoaded({
    required this.bookmarks,
    required this.filteredBookmarks,
    this.searchQuery = '',
    this.selectedType,
    required this.totalCount,
  });

  BookmarksLoaded copyWith({
    List<BookmarkModel>? bookmarks,
    List<BookmarkModel>? filteredBookmarks,
    String? searchQuery,
    BookmarkType? selectedType,
    bool clearSelectedType = false,
    int? totalCount,
  }) {
    return BookmarksLoaded(
      bookmarks: bookmarks ?? this.bookmarks,
      filteredBookmarks: filteredBookmarks ?? this.filteredBookmarks,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: clearSelectedType
          ? null
          : (selectedType ?? this.selectedType),
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class BookmarksError extends BookmarksState {
  final String message;
  BookmarksError(this.message);
}

class BookmarkActionLoading extends BookmarksState {}

class BookmarkActionSuccess extends BookmarksState {
  final String message;
  BookmarkActionSuccess(this.message);
}
