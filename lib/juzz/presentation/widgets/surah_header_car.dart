import '../../../constants.dart';
import '../../data/models/juzz_ayah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SurahHeaderCard extends StatelessWidget {
  final JuzzAyah ayah;

  const SurahHeaderCard({super.key, required this.ayah});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          _buildSurahNumber(),
          const SizedBox(width: 12),
          _buildSurahInfo(),
          _buildArabicName(),
        ],
      ),
    );
  }

  Widget _buildSurahNumber() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset('assets/svgs/nomor-surah.svg'),
        Text(
          "${ayah.surah.number}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSurahInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ayah.surah.englishName,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            ayah.surah.englishNameTranslation,
            style: GoogleFonts.poppins(color: textColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildArabicName() {
    return Text(
      ayah.surah.name,
      style: GoogleFonts.amiri(
        color: primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
