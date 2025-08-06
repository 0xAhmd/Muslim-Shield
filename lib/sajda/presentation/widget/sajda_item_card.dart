import '../../../constants.dart';
import '../../data/models/sajda_summary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SajdaItemCard extends StatelessWidget {
  final SajdaSummary sajda;
  final VoidCallback onTap;

  const SajdaItemCard({super.key, required this.sajda, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: grey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: sajda.isObligatory ? Colors.red.withOpacity(0.3) : primary.withOpacity(0.1), 
            width: 1
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildSajdaInfo(),
            const SizedBox(height: 12),
            _buildAyahPreview(),
            const SizedBox(height: 12),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: sajda.isObligatory ? Colors.red.withOpacity(0.1) : primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: sajda.isObligatory ? Colors.red.withOpacity(0.3) : primary.withOpacity(0.3), 
              width: 1
            ),
          ),
          child: Center(
            child: Text(
              '${sajda.id}',
              style: GoogleFonts.poppins(
                color: sajda.isObligatory ? Colors.red : primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sajda.surahName,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sajda.surahArabicName,
                style: GoogleFonts.amiri(
                  color: textColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        _buildSajdaTypeChip(),
      ],
    );
  }

  Widget _buildSajdaTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: sajda.isObligatory ? Colors.red.withOpacity(0.2) : orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: sajda.isObligatory ? Colors.red : orange,
        ),
      ),
      child: Text(
        sajda.sajdaType,
        style: GoogleFonts.poppins(
          color: sajda.isObligatory ? Colors.red : orange,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSajdaInfo() {
    return Row(
      children: [
        _buildInfoChip(
          icon: Icons.format_list_numbered,
          text: 'Ayah ${sajda.ayahNumber}',
        ),
        const SizedBox(width: 12),
        _buildInfoChip(
          icon: Icons.book_outlined,
          text: 'Surah ${sajda.surahNumber}',
        ),
        const SizedBox(width: 12),
        _buildInfoChip(
          icon: Icons.bookmark_outline,
          text: 'Juz ${sajda.juz}',
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor.withOpacity(0.6)),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Text(
        sajda.shortText,
        style: GoogleFonts.poppins(
          color: textColor.withOpacity(0.8),
          fontSize: 13,
          height: 1.4,
          fontStyle: FontStyle.italic,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: background.withOpacity(0.8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, size: 12, color: orange),
              const SizedBox(width: 4),
              Text(
                'Page ${sajda.page}',
                style: GoogleFonts.poppins(
                  color: textColor.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.arrow_forward_ios, size: 14, color: primary),
        ),
      ],
    );
  }
}