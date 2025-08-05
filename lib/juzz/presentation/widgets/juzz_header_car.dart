// lib/juzz/presentation/widgets/juzz_header_card.dart
import 'package:azkar/constants.dart';
import 'package:azkar/juzz/data/models/juzz.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzHeaderCard extends StatelessWidget {
  final Juzz juzz;

  const JuzzHeaderCard({super.key, required this.juzz});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary.withOpacity(0.8), primary],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Juzz ${juzz.number}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${juzz.totalAyahs} Ayahs • ${juzz.containedSurahs.length} Surahs',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            juzz.surahRange,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
