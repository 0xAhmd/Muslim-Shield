import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:azkar/bookmarks/model/bookmark.dart';
import 'package:azkar/bookmarks/presentation/cubit/bookmark_cubit.dart';
import 'package:azkar/bookmarks/presentation/cubit/bookmark_state.dart';
import 'package:azkar/bookmarks/presentation/widgets/bookmarks_card.dart';
import 'package:azkar/bookmarks/service/bookmark_service.dart';
import 'package:azkar/constants.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarksCubit(BookmarksService())..loadBookmarks(),
      child: const BookmarksPageContent(),
    );
  }
}

class BookmarksPageContent extends StatefulWidget {
  const BookmarksPageContent({super.key});

  @override
  State<BookmarksPageContent> createState() => _BookmarksPageContentState();
}

class _BookmarksPageContentState extends State<BookmarksPageContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<BookmarksCubit>().clearFilters();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with search
            _buildHeader(),

            // Search bar (when active)
            if (_isSearching) _buildSearchBar(),

            // Type filters
            BlocBuilder<BookmarksCubit, BookmarksState>(
              builder: (context, state) {
                if (state is BookmarksLoaded && !_isSearching) {
                  return _buildTypeFilters(state);
                }
                return const SizedBox.shrink();
              },
            ),

            // Bookmarks list
            Expanded(
              child: BlocBuilder<BookmarksCubit, BookmarksState>(
                builder: (context, state) {
                  if (state is BookmarksLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: primary),
                    );
                  } else if (state is BookmarksError) {
                    return _buildErrorView(state.message);
                  } else if (state is BookmarksLoaded) {
                    return _buildBookmarksList(state);
                  } else if (state is BookmarkActionSuccess) {
                    // Show success and then reload
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<BookmarksCubit>().loadBookmarks();
                    });
                    return const Center(
                      child: CircularProgressIndicator(color: primary),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bookmarks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                BlocBuilder<BookmarksCubit, BookmarksState>(
                  builder: (context, state) {
                    if (state is BookmarksLoaded) {
                      return Text(
                        '${state.totalCount} saved items',
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      );
                    }
                    return Text(
                      'Your saved Islamic content',
                      style: TextStyle(
                        color: textColor.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            children: [
              // Search button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: gray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _toggleSearch,
                  icon: Icon(
                    _isSearching ? Icons.close : Icons.search,
                    color: primary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Clear all button
              BlocBuilder<BookmarksCubit, BookmarksState>(
                builder: (context, state) {
                  if (state is BookmarksLoaded && state.bookmarks.isNotEmpty) {
                    return Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: gray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: _showClearAllDialog,
                        icon: Icon(
                          Icons.delete_sweep,
                          color: Colors.red.withOpacity(0.8),
                          size: 24,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: gray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search bookmarks...',
          hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: textColor.withOpacity(0.6)),
        ),
        onChanged: (query) {
          context.read<BookmarksCubit>().searchBookmarks(query);
        },
      ),
    );
  }

  Widget _buildTypeFilters(BookmarksLoaded state) {
    final types = [
      BookmarkType.ayah,
      BookmarkType.dua,
      BookmarkType.hadith,
      BookmarkType.other,
    ];

    return Container(
      height: 42,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: types.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _TypeFilterButton(
              label: 'All',
              isSelected: state.selectedType == null,
              onTap: () => context.read<BookmarksCubit>().filterByType(null),
            );
          }

          final type = types[index - 1];
          final count = state.bookmarks.where((b) => b.type == type).length;

          return _TypeFilterButton(
            label: '${type.displayName} ($count)',
            isSelected: state.selectedType == type,
            onTap: () => context.read<BookmarksCubit>().filterByType(type),
          );
        },
      ),
    );
  }

  Widget _buildBookmarksList(BookmarksLoaded state) {
    if (state.filteredBookmarks.isEmpty) {
      return _buildEmptyView();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<BookmarksCubit>().loadBookmarks();
      },
      color: primary,
      backgroundColor: gray,
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: state.filteredBookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = state.filteredBookmarks[index];
          return BookmarkCard(
            bookmark: bookmark,
            onTap: () => _showBookmarkDetails(context, bookmark),
            onRemove: () => _removeBookmark(bookmark.id),
          );
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: textColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _isSearching ? 'No bookmarks found' : 'No bookmarks yet',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSearching
                ? 'Try different search terms'
                : 'Start bookmarking your favorite verses and duas',
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading bookmarks',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<BookmarksCubit>().loadBookmarks();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookmarkDetails(BuildContext context, BookmarkModel bookmark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: gray,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with type and title
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor(
                                bookmark.type,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  bookmark.type.icon,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  bookmark.type.displayName,
                                  style: GoogleFonts.poppins(
                                    color: _getTypeColor(bookmark.type),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (bookmark.category != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                bookmark.category!,
                                style: GoogleFonts.poppins(
                                  color: primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        bookmark.title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Content based on type
                      if (bookmark.type == BookmarkType.ayah ||
                          bookmark.type == BookmarkType.dua) ...[
                        // Arabic text
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            bookmark.content,
                            style: GoogleFonts.amiri(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              height: 2.0,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),

                        // Transliteration (for Duas)
                        if (bookmark.transliteration != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Transliteration:',
                            style: GoogleFonts.poppins(
                              color: primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bookmark.transliteration!,
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Translation
                        if (bookmark.translation != null) ...[
                          Text(
                            'Translation:',
                            style: GoogleFonts.poppins(
                              color: primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bookmark.translation!,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ] else ...[
                        // Other content types
                        Text(
                          bookmark.content,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ],

                      // Reference
                      if (bookmark.reference != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.book, color: orange, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Reference: ${bookmark.reference}',
                                style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(BookmarkType type) {
    switch (type) {
      case BookmarkType.ayah:
        return primary;
      case BookmarkType.dua:
        return orange;
      case BookmarkType.hadith:
        return const Color(0xFF4CAF50);
      case BookmarkType.other:
        return textColor;
    }
  }

  void _removeBookmark(String bookmarkId) {
    context.read<BookmarksCubit>().removeBookmark(bookmarkId);
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: gray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Clear All Bookmarks',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: Text(
            'Are you sure you want to remove all bookmarks? This action cannot be undone.',
            style: GoogleFonts.poppins(color: textColor, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: textColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<BookmarksCubit>().clearAllBookmarks();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Clear All',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TypeFilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeFilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primary : primary.withOpacity(0.4),
              width: 1.4,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
