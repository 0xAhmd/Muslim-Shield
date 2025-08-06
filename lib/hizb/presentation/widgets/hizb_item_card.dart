import '../../../constants.dart';
import '../../data/models/hizb_summary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HizbItemCard extends StatelessWidget {
  final HizbSummary hizb;
  final VoidCallback onTap;

  const HizbItemCard({super.key, required this.hizb, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: grey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.1), width: 1),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _buildHizbNumber(),
            const SizedBox(width: 16),
            Expanded(child: _buildHizbInfo()),
            _buildArrowIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildHizbNumber() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Text(
          '${hizb.number}',
          style: GoogleFonts.poppins(
            color: primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHizbInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hizb.name,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hizb.description,
          style: GoogleFonts.poppins(
            color: textColor.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildInfoChip(
              icon: Icons.format_list_numbered,
              text: '${hizb.approximateAyahs} Ayahs',
            ),
            const SizedBox(width: 12),
            _buildInfoChip(
              icon: Icons.book_outlined,
              text:
                  '${hizb.containedSurahs.length} Surah${hizb.containedSurahs.length == 1 ? '' : 's'}',
            ),
          ],
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

  Widget _buildArrowIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.arrow_forward_ios, size: 16, color: primary),
    );
  }
}
