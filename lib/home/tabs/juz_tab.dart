import 'package:azkar/constants.dart';
import 'package:azkar/home/data/repo/surah_repo.dart';
import 'package:azkar/juzz/data/models/juzz_summary.dart';
import 'package:azkar/juzz/presentation/cubit/juzz_cubit.dart';
import 'package:azkar/juzz/presentation/cubit/juzz_state.dart';
import 'package:azkar/juzz/presentation/pages/juzz_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzTab extends StatefulWidget {
  const JuzTab({super.key});

  @override
  State<JuzTab> createState() => JuzTabState();
}

class JuzTabState extends State<JuzTab> {
  late JuzzCubit _juzzCubit;

  @override
  void initState() {
    super.initState();
    _juzzCubit = JuzzCubit(repository: SurahRepository());
    _juzzCubit.loadJuzzSummaries();
  }

  @override
  void dispose() {
    _juzzCubit.close();
    super.dispose();
  }

  void searchJuzz(String query) {
    _juzzCubit.searchJuzz(query);
  }

  void clearSearch() {
    _juzzCubit.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _juzzCubit,
      child: BlocBuilder<JuzzCubit, JuzzState>(
        builder: (context, state) {
          if (state is JuzzLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading Juzz sections...',
                    style: GoogleFonts.poppins(color: textColor, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          if (state is JuzzError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading Juzz sections',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _juzzCubit.retry(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(Icons.refresh, size: 18),
                    label: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is JuzzLoaded) {
            return _buildJuzzList(context, state);
          }

          // Initial state
          return Center(
            child: Text(
              'Initializing...',
              style: GoogleFonts.poppins(color: textColor),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJuzzList(BuildContext context, JuzzLoaded state) {
    if (state.filteredJuzz.isEmpty && state.searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: textColor),
            const SizedBox(height: 16),
            Text(
              'No Juzz found',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: GoogleFonts.poppins(color: textColor, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (state.searchQuery.isNotEmpty) _buildSearchIndicator(state),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: state.filteredJuzz.length,
            separatorBuilder: (context, index) => Divider(
              color: const Color(0xFFAAAAAA).withOpacity(.35),
              thickness: 1,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final juzz = state.filteredJuzz[index];
              return _JuzzTile(
                juzzSummary: juzz,
                searchQuery: state.searchQuery,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JuzzDetailScreen(
                        juzzNumber: juzz.number,
                        juzzCubit: _juzzCubit,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchIndicator(JuzzLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${state.filteredJuzz.length} result${state.filteredJuzz.length == 1 ? '' : 's'} for "${state.searchQuery}"',
              style: GoogleFonts.poppins(
                color: primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JuzzTile extends StatelessWidget {
  final JuzzSummary juzzSummary;
  final String searchQuery;
  final VoidCallback onTap;

  const _JuzzTile({
    required this.juzzSummary,
    required this.searchQuery,
    required this.onTap,
  });

  Widget _highlightText(
    String text,
    String query, {
    Color normalColor = Colors.white,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    if (query.isEmpty) {
      return Text(
        text,
        style: GoogleFonts.poppins(
          color: normalColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(
        text,
        style: GoogleFonts.poppins(
          color: normalColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      );
    }

    final index = lowerText.indexOf(lowerQuery);
    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: before,
            style: GoogleFonts.poppins(
              color: normalColor,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
          TextSpan(
            text: match,
            style: GoogleFonts.poppins(
              color: primary,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              backgroundColor: primary.withOpacity(0.2),
            ),
          ),
          TextSpan(
            text: after,
            style: GoogleFonts.poppins(
              color: normalColor,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldHighlightNumber() {
    return searchQuery.isNotEmpty &&
        juzzSummary.number.toString().contains(searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final subtitleText =
        "${juzzSummary.description} • ${juzzSummary.approximateAyahs} Ayahs";

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary.withOpacity(0.8), primary],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          Text(
            "${juzzSummary.number}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: _shouldHighlightNumber() ? Colors.yellow : Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _highlightText(
            juzzSummary.name,
            searchQuery,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 2),
          _highlightText(
            subtitleText,
            searchQuery,
            normalColor: textColor,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.book_outlined, size: 14, color: primary),
            const SizedBox(width: 4),
            Text(
              '${juzzSummary.containedSurahs.length} Surah${juzzSummary.containedSurahs.length == 1 ? '' : 's'}',
              style: GoogleFonts.poppins(
                color: primary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension for the HomeScreen to use this tab
extension JuzTabExtension on JuzTabState {
  void performSearch(String query) {
    searchJuzz(query);
  }

  void performClearSearch() {
    clearSearch();
  }
}
