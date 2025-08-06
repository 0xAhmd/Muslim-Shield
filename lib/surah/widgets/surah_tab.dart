import '../../constants.dart';
import '../data/models/surah.dart';
import '../data/repo/surah_repo.dart';
import '../data/service/last_read.dart';
import '../pages/surah_details_page.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SurahTab extends StatefulWidget {
  const SurahTab({super.key});

  @override
  State<SurahTab> createState() => SurahTabState();
}

class SurahTabState extends State<SurahTab> {
  final SurahRepository _repository = SurahRepository();
  List<Surah> allSurahs = [];
  List<Surah> filteredSurahs = [];
  bool isLoading = true;
  String? error;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedSurahs = await _repository.getSurahs();
      setState(() {
        allSurahs = fetchedSurahs;
        filteredSurahs = fetchedSurahs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void searchSurahs(String query) {
    setState(() {
      searchQuery = query.toLowerCase().trim();
      if (searchQuery.isEmpty) {
        filteredSurahs = allSurahs;
      } else {
        filteredSurahs = allSurahs.where((surah) {
          return surah.englishName.toLowerCase().contains(searchQuery) ||
              surah.englishNameTranslation.toLowerCase().contains(
                searchQuery,
              ) ||
              surah.name.contains(searchQuery) ||
              surah.number.toString().contains(searchQuery);
        }).toList();
      }
    });
  }

  void clearSearch() {
    setState(() {
      searchQuery = '';
      filteredSurahs = allSurahs;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child:  CupertinoActivityIndicator(color: primary));
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading surahs',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              style: GoogleFonts.poppins(color: textColor, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSurahs,
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (filteredSurahs.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: textColor),
            const SizedBox(height: 16),
            Text(
              'No surahs found',
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
        if (searchQuery.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: primary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${filteredSurahs.length} result${filteredSurahs.length == 1 ? '' : 's'} for "$searchQuery"',
                    style: GoogleFonts.poppins(
                      color: primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: filteredSurahs.length,
            separatorBuilder: (context, index) => Divider(
              color: const Color(0xFFAAAAAA).withOpacity(.35),
              thickness: 1,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final surah = filteredSurahs[index];
              return _SurahTile(
                surah: surah,
                searchQuery: searchQuery,
                onTap: () async {
                  // Save as last read when tapping on a surah
                  await LastReadService.saveLastReadFromSurah(
                    surah: surah,
                    ayahNumber: 1, // Start from first ayah when entering surah
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailScreen(surah: surah),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SurahTile extends StatelessWidget {
  final Surah surah;
  final String searchQuery;
  final VoidCallback onTap;

  const _SurahTile({
    required this.surah,
    required this.searchQuery,
    required this.onTap,
  });

  Widget _highlightText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
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
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: match,
            style: GoogleFonts.poppins(
              color: primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              backgroundColor: primary.withOpacity(0.2),
            ),
          ),
          TextSpan(
            text: after,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _highlightSubtitle(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: GoogleFonts.poppins(color: textColor, fontSize: 12),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(
        text,
        style: GoogleFonts.poppins(color: textColor, fontSize: 12),
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
            style: GoogleFonts.poppins(color: textColor, fontSize: 12),
          ),
          TextSpan(
            text: match,
            style: GoogleFonts.poppins(
              color: primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              backgroundColor: primary.withOpacity(0.2),
            ),
          ),
          TextSpan(
            text: after,
            style: GoogleFonts.poppins(color: textColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtitleText =
        "${surah.englishNameTranslation} • ${surah.numberOfAyahs} Ayahs";

    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          SvgPicture.asset('assets/svgs/nomor-surah.svg'),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Text(
                "${surah.number}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color:
                      searchQuery.isNotEmpty &&
                          surah.number.toString().contains(searchQuery)
                      ? primary
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      title: _highlightText(surah.englishName, searchQuery),
      subtitle: _highlightSubtitle(subtitleText, searchQuery),
      trailing: Text(
        surah.name,
        style: GoogleFonts.amiri(
          color: searchQuery.isNotEmpty && surah.name.contains(searchQuery)
              ? primary
              : primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
