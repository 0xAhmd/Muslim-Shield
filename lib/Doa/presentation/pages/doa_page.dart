import 'package:azkar/Doa/presentation/widgets/category_filter.dart';
import 'package:azkar/Doa/presentation/widgets/duaa_card.dart';
import 'package:azkar/bookmarks/presentation/cubit/bookmark_cubit.dart';
import 'package:azkar/bookmarks/presentation/cubit/bookmark_state.dart';
import 'package:azkar/bookmarks/service/bookmark_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/Doa/data/dua_model.dart';
import 'package:azkar/Doa/presentation/cubit/dua_state.dart';
import 'package:azkar/Doa/presentation/cubit/dua_cubit.dart';
import 'package:azkar/constants.dart';

class DoaPage extends StatelessWidget {
  const DoaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DuaCubit()..loadDuas()),
        BlocProvider(create: (context) => BookmarksCubit(BookmarksService())),
      ],
      child: const DoaPageContent(),
    );
  }
}

class DoaPageContent extends StatefulWidget {
  const DoaPageContent({super.key});

  @override
  State<DoaPageContent> createState() => _DoaPageContentState();
}

class _DoaPageContentState extends State<DoaPageContent> {
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
        context.read<DuaCubit>().clearFilters();
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

            // Category filters
            BlocBuilder<DuaCubit, DuaState>(
              builder: (context, state) {
                if (state is DuaLoaded && !_isSearching) {
                  return _buildCategoryFilters(state);
                }
                return const SizedBox.shrink();
              },
            ),

            // Duas list
            Expanded(
              child: BlocBuilder<DuaCubit, DuaState>(
                builder: (context, state) {
                  if (state is DuaLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: primary),
                    );
                  } else if (state is DuaError) {
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
                          const Text(
                            'Error loading Duas',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(
                              color: textColor.withOpacity(0.7),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else if (state is DuaLoaded) {
                    return _buildDuasList(state);
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
                  'Duas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Islamic supplications and prayers',
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
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
          hintText: 'Search duas...',
          hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: textColor.withOpacity(0.6)),
        ),
        onChanged: (query) {
          context.read<DuaCubit>().searchDuas(query);
        },
      ),
    );
  }

  Widget _buildCategoryFilters(DuaLoaded state) {
    return Container(
      height: 42,
      margin: const EdgeInsets.only(top: 16),
      child: BlocBuilder<DuaCubit, DuaState>(
        builder: (context, state) {
          if (state is! DuaLoaded) return const SizedBox.shrink();

          final cubit = context.read<DuaCubit>();
          final categories = cubit.getCategories();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return CategoryFilterButton(
                  label: 'All',
                  isSelected: state.selectedCategory == null,
                  onTap: () => cubit.filterByCategory(null),
                );
              }

              final category = categories[index - 1];
              return CategoryFilterButton(
                label: category,
                isSelected: state.selectedCategory == category,
                onTap: () => cubit.filterByCategory(category),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDuasList(DuaLoaded state) {
    if (state.filteredDuas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: textColor.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              _isSearching ? 'No duas found' : 'No duas in this category',
              style: const TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isSearching
                  ? 'Try different search terms'
                  : 'Select a different category',
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: state.filteredDuas.length,
      itemBuilder: (context, index) {
        final dua = state.filteredDuas[index];
        return DuaCard(dua: dua, onTap: () => _showDuaDetails(context, dua));
      },
    );
  }

  void _showDuaDetails(BuildContext context, DuaModel dua) {
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
                      // Title, category, and bookmark button
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dua.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                                    dua.category,
                                    style: const TextStyle(
                                      color: primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Bookmark button
                          BlocBuilder<BookmarksCubit, BookmarksState>(
                            builder: (context, bookmarkState) {
                              return FutureBuilder<bool>(
                                future: context
                                    .read<BookmarksCubit>()
                                    .isDuaBookmarked(dua.id),
                                builder: (context, snapshot) {
                                  final isBookmarked = snapshot.data ?? false;

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: isBookmarked
                                          ? primary.withOpacity(0.2)
                                          : gray.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      onPressed: () =>
                                          _toggleBookmark(dua, isBookmarked),
                                      icon: Icon(
                                        isBookmarked
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: isBookmarked
                                            ? primary
                                            : textColor,
                                        size: 24,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

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
                          dua.arabic,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 2.0,
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),

                      // Transliteration
                      if (dua.transliteration != null) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Transliteration:',
                          style: TextStyle(
                            color: primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dua.transliteration!,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.6,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Translation
                      const Text(
                        'Translation:',
                        style: TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dua.translation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),

                      // Reference
                      if (dua.reference != null) ...[
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
                                'Reference: ${dua.reference}',
                                style: const TextStyle(
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

  void _toggleBookmark(DuaModel dua, bool isCurrentlyBookmarked) async {
    final bookmarksCubit = context.read<BookmarksCubit>();

    try {
      if (isCurrentlyBookmarked) {
        await bookmarksCubit.removeDuaBookmark(dua.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.bookmark_remove, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Bookmark removed'),
                ],
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red.withOpacity(0.8),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        await bookmarksCubit.bookmarkDua(
          duaId: dua.id,
          title: dua.title,
          arabic: dua.arabic,
          translation: dua.translation,
          category: dua.category,
          transliteration: dua.transliteration,
          reference: dua.reference,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.bookmark_added, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Dua bookmarked'),
                ],
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
      // Force rebuild of the bookmark button
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
