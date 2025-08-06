import '../../../constants.dart';
import '../../data/models/hizb_summary.dart';
import '../cubit/hizb_cubit.dart';
import '../pages/hizb_details_screen.dart';
import 'hizb_item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HizbListView extends StatelessWidget {
  final List<HizbSummary> hizbSummaries;
  final bool isSearching;
  final String searchQuery;
  final HizbCubit hizbCubit;

  const HizbListView({
    super.key,
    required this.hizbSummaries,
    required this.isSearching,
    required this.searchQuery,
    required this.hizbCubit,
  });

  @override
  Widget build(BuildContext context) {
    if (hizbSummaries.isEmpty && isSearching) {
      return _buildNoSearchResults();
    }

    if (hizbSummaries.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isSearching) _buildSearchHeader(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 16, bottom: 100),
            itemCount: hizbSummaries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final hizb = hizbSummaries[index];
              return HizbItemCard(
                hizb: hizb,
                onTap: () => _navigateToHizbDetails(context, hizb),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        'Found ${hizbSummaries.length} result${hizbSummaries.length == 1 ? '' : 's'} for "$searchQuery"',
        style: GoogleFonts.poppins(
          color: textColor.withOpacity(0.8),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
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
            'No Hizb sections found',
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords like Hizb number, Juzz, or Surah name',
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
            Icons.menu_book_outlined,
            size: 64,
            color: textColor.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Hizb sections available',
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

  void _navigateToHizbDetails(BuildContext context, HizbSummary hizb) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            HizbDetailScreen(hizbNumber: hizb.number, hizbCubit: hizbCubit),
      ),
    );
  }
}
