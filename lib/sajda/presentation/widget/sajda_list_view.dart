import 'package:azkar/sajda/presentation/pages/sajda_details_screen.dart';

import '../../../constants.dart';
import '../../data/models/sajda_summary.dart';
import '../cubit/sajda_cubit.dart';
import 'sajda_item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SajdaListView extends StatelessWidget {
  final List<SajdaSummary> sajdaSummaries;
  final bool isSearching;
  final String searchQuery;
  final SajdaCubit sajdaCubit;
  final bool showObligatory;
  final bool showRecommended;

  const SajdaListView({
    super.key,
    required this.sajdaSummaries,
    required this.isSearching,
    required this.searchQuery,
    required this.sajdaCubit,
    required this.showObligatory,
    required this.showRecommended,
  });

  @override
  Widget build(BuildContext context) {
    if (sajdaSummaries.isEmpty && isSearching) {
      return _buildNoSearchResults();
    }

    if (sajdaSummaries.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 16, bottom: 100),
            itemCount: sajdaSummaries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final sajda = sajdaSummaries[index];
              return SajdaItemCard(
                sajda: sajda,
                onTap: () => _navigateToSajdaDetails(context, sajda),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final obligatoryCount = sajdaSummaries.where((s) => s.isObligatory).length;
    final recommendedCount = sajdaSummaries
        .where((s) => s.isRecommended)
        .length;

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSearching)
            Text(
              'Found ${sajdaSummaries.length} result${sajdaSummaries.length == 1 ? '' : 's'} for "$searchQuery"',
              style: GoogleFonts.poppins(
                color: textColor.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStatsChip(
                icon: Icons.keyboard_arrow_down,
                label: 'Total',
                count: sajdaSummaries.length.toString(),
                color: primary,
              ),
              const SizedBox(width: 12),
              _buildStatsChip(
                icon: Icons.priority_high,
                label: 'Obligatory',
                count: obligatoryCount.toString(),
                color: Colors.red,
                isActive: showObligatory,
              ),
              const SizedBox(width: 12),
              _buildStatsChip(
                icon: Icons.star_outline,
                label: 'Recommended',
                count: recommendedCount.toString(),
                color: orange,
                isActive: showRecommended,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsChip({
    required IconData icon,
    required String label,
    required String count,
    required Color color,
    bool isActive = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : background.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? color.withOpacity(0.3) : textColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isActive ? color : textColor.withOpacity(0.6),
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: GoogleFonts.poppins(
              color: isActive ? color : textColor.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: isActive ? color : textColor.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: textColor.withOpacity(0.5)),
          const SizedBox(height: 24),
          Text(
            'No sajdas found',
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords like surah name, ayah number, or sajda type',
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 64,
            color: textColor.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No sajdas available',
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your internet connection and try again',
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToSajdaDetails(BuildContext context, SajdaSummary sajda) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            SajdaDetailScreen(sajdaId: sajda.id, sajdaCubit: sajdaCubit),
      ),
    );
  }
}
