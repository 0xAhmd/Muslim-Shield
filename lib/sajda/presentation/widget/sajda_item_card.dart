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
            color: sajda.isObligatory
                ? Colors.red.withOpacity(0.3)
                : primary.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: sajda.isObligatory
                  ? Colors.red.withOpacity(0.1)
                  : primary.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSajdaInfo(),
            const SizedBox(height: 16),
            _buildAyahPreview(),
            const SizedBox(height: 16),
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
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: sajda.isObligatory
                  ? [Colors.red.withOpacity(0.2), Colors.red.withOpacity(0.1)]
                  : [primary.withOpacity(0.2), primary.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: sajda.isObligatory
                  ? Colors.red.withOpacity(0.4)
                  : primary.withOpacity(0.4),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '${sajda.id}',
              style: GoogleFonts.poppins(
                color: sajda.isObligatory ? Colors.red : primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sajda.surahName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sajda.surahArabicName,
                style: GoogleFonts.amiri(
                  color: textColor.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: sajda.isObligatory
              ? [Colors.red.withOpacity(0.3), Colors.red.withOpacity(0.2)]
              : [orange.withOpacity(0.3), orange.withOpacity(0.2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sajda.isObligatory ? Colors.red : orange,
          width: 1,
        ),
      ),
      child: Text(
        sajda.sajdaType,
        style: GoogleFonts.poppins(
          color: sajda.isObligatory ? Colors.red : orange,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSajdaInfo() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildInfoChip(
          icon: Icons.format_list_numbered,
          text: 'Ayah ${sajda.ayahNumber}',
          color: Colors.cyan,
        ),
        _buildInfoChip(
          icon: Icons.book_outlined,
          text: 'Surah ${sajda.surahNumber}',
          color: Colors.blue,
        ),
        _buildInfoChip(
          icon: Icons.bookmark_outline,
          text: 'Juz ${sajda.juz}',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                size: 16,
                color: primary.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'Ayah Text',
                style: GoogleFonts.poppins(
                  color: primary.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            sajda.shortText,
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.9),
              fontSize: 14,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: orange.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, size: 14, color: orange),
              const SizedBox(width: 6),
              Text(
                'Page ${sajda.page}',
                style: GoogleFonts.poppins(
                  color: orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary.withOpacity(0.2), primary.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primary.withOpacity(0.3)),
          ),
          child: const Icon(Icons.arrow_forward_ios, size: 16, color: primary),
        ),
      ],
    );
  }
}
