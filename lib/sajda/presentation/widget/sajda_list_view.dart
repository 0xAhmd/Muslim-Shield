import '../pages/sajda_details_screen.dart';

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

    return ListView.separated(
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
            'Try searching with different keywords',
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
            'Please check your internet connection',
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
