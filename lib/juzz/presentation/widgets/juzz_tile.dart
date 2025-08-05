import 'package:azkar/constants.dart';
import 'package:azkar/juzz/data/models/juzz_summary.dart';
import 'package:azkar/juzz/presentation/widgets/highlighted_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzTile extends StatelessWidget {
  final JuzzSummary juzzSummary;
  final String searchQuery;
  final VoidCallback onTap;

  const JuzzTile({
    super.key,
    required this.juzzSummary,
    required this.searchQuery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: _buildLeadingIcon(),
      title: _buildTitle(),
      trailing: _buildTrailing(),
    );
  }

  Widget _buildLeadingIcon() {
    final shouldHighlightNumber = _shouldHighlightNumber();

    return Stack(
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
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        Text(
          "${juzzSummary.number}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: shouldHighlightNumber ? Colors.yellow : Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    final subtitleText =
        "${juzzSummary.description} • ${juzzSummary.approximateAyahs} Ayahs";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HighlightedText(
          text: juzzSummary.name,
          query: searchQuery,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 2),
        HighlightedText(
          text: subtitleText,
          query: searchQuery,
          normalColor: textColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ],
    );
  }

  Widget _buildTrailing() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.book_outlined, size: 14, color: primary),
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
    );
  }

  bool _shouldHighlightNumber() {
    return searchQuery.isNotEmpty &&
        juzzSummary.number.toString().contains(searchQuery);
  }
}
