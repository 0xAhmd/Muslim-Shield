import 'package:azkar/constants.dart';
import 'package:azkar/surah/data/service/last_read.dart';
import 'package:azkar/juzz/data/models/juzz_ayah.dart';
import 'package:azkar/juzz/presentation/widgets/meta_data_chip.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AyahTile extends StatelessWidget {
  final JuzzAyah ayah;
  final int juzzNumber;
  final bool isBookmarked;
  final VoidCallback onBookmarkChanged;

  const AyahTile({
    super.key,
    required this.ayah,
    required this.juzzNumber,
    required this.isBookmarked,
    required this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBookmarked ? primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isBookmarked
            ? Border.all(color: primary.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAyahHeader(context),
          const SizedBox(height: 12),
          _buildArabicText(),
          const SizedBox(height: 12),
          _buildMetadataRow(),
        ],
      ),
    );
  }

  Widget _buildAyahHeader(BuildContext context) {
    return Row(
      children: [
        _buildAyahNumber(),
        const Spacer(),
        if (isBookmarked) _buildLastReadBadge(),
        const SizedBox(width: 8),
        _buildBookmarkButton(context),
      ],
    );
  }

  Widget _buildAyahNumber() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${ayah.numberInSurah}',
        style: GoogleFonts.poppins(
          color: primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLastReadBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bookmark, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            'Last Read',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _saveLastRead(context),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          color: primary,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildArabicText() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        ayah.text,
        style: GoogleFonts.amiri(
          fontSize: 20,
          color: Colors.white,
          height: 1.8,
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildMetadataRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        MetadataChip(label: 'Page ${ayah.page}', icon: Icons.book),
        MetadataChip(label: 'Ruku ${ayah.ruku}', icon: Icons.bookmark_outlined),
        if (ayah.sajda)
          const MetadataChip(
            label: 'Sajda',
            icon: Icons.keyboard_arrow_down,
            color: orange,
          ),
      ],
    );
  }

  Future<void> _saveLastRead(BuildContext context) async {
    try {
      await LastReadService.saveLastReadFromJuzzAyah(
        juzzAyah: ayah,
        juzzNumber: juzzNumber,
      );

      onBookmarkChanged();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bookmark, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Bookmark saved',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving last read: $e');
    }
  }
}

// Extension to add to LastReadService for Juzz support
extension LastReadJuzzExtension on LastReadService {
  static Future<void> saveLastReadFromJuzzAyah({
    required JuzzAyah juzzAyah,
    required int juzzNumber,
  }) async {
    final lastReadData = LastReadData(
      surahNumber: juzzAyah.surah.number,
      surahEnglishName: juzzAyah.surah.englishName,
      ayahNumber: juzzAyah.numberInSurah,
      progressPercentage:
          (juzzAyah.numberInSurah / juzzAyah.surah.numberOfAyahs) * 100,
      lastReadAt: DateTime.now(),
      juzzNumber: juzzNumber,
    );

    await LastReadService.saveLastRead(lastReadData);
  }
}
