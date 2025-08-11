import 'package:easy_localization/easy_localization.dart';

import '../../../constants.dart';
import '../../data/models/hizb_summary.dart';
import '../../data/repo/hizb_repo.dart';
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
        'hizb.found_results'.tr(
          namedArgs: {
            'count': '${hizbSummaries.length}',
            'plural': hizbSummaries.length == 1 ? '' : 's',
            'query': searchQuery,
          },
        ),
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
            'hizb.no_hizb_found'.tr(),
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'hizb.no_hizb_description'.tr(),
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
            'hizb.no_hizb_available'.tr(),
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
         Text(
  'hizb.no_hizb_available_description'.tr(),
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
    // Create a separate cubit instance for the detail screen
    final detailCubit = HizbCubit(repository: HizbRepository());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            HizbDetailScreen(hizbNumber: hizb.number, hizbCubit: detailCubit),
      ),
    );
  }
}
