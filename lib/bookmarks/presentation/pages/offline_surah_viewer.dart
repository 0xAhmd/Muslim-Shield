// NEW: Create lib/bookmarks/presentation/pages/offline_surah_viewer.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/bookmark.dart';
import '../../../constants.dart';

class OfflineSurahViewer extends StatelessWidget {
  final BookmarkModel surahBookmark;

  const OfflineSurahViewer({super.key, required this.surahBookmark});

  @override
  Widget build(BuildContext context) {
    final ayahs = surahBookmark.ayahs ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined, color: primary),
        ),
        title: Text(
          surahBookmark.title,
          style: GoogleFonts.amiri(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, color: primary, size: 16),
                const SizedBox(width: 4),
                Text(
                  'OFFLINE',
                  style: GoogleFonts.poppins(
                    color: primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final ayah = ayahs[index];
              return _buildAyahCard(ayah, index + 1);
            }, childCount: ayahs.length),
          ),
          // Add some bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDF98EA), Color(0XFFB070FD), Color(0xFF9055FF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            surahBookmark.title,
            style: GoogleFonts.amiri(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            surahBookmark.englishNameTranslation ?? surahBookmark.content,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
          Divider(
            color: Colors.white.withOpacity(.35),
            thickness: 2,
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${surahBookmark.revelationType?.toUpperCase() ?? 'MECCAN'} • ${surahBookmark.numberOfAyahs} VERSES',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.download_done, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Available Offline',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahCard(Map<dynamic, dynamic> ayah, int displayNumber) {
    final arabicText = ayah['text'] ?? '';
    final translation = ayah['translation'] ?? '';
    final transliteration = ayah['transliteration'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Header with ayah number
          Row(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$displayNumber',
                  style: GoogleFonts.poppins(
                    color: primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Arabic text
          if (arabicText.isNotEmpty) ...[
            Text(
              arabicText,
              style: GoogleFonts.amiri(
                color: Colors.white,
                fontSize: 24,
                height: 2.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),
          ],

          // Transliteration (if available)
          if (transliteration.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transliteration:',
                    style: GoogleFonts.poppins(
                      color: orange,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transliteration,
                    style: GoogleFonts.poppins(
                      color: textColor.withOpacity(0.9),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Translation (if available)
          if (translation.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Translation:',
                    style: GoogleFonts.poppins(
                      color: primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translation,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
