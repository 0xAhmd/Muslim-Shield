import 'package:easy_localization/easy_localization.dart';

import '../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzEmptyState extends StatelessWidget {
  final String searchQuery;

  const JuzzEmptyState({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: textColor),
          const SizedBox(height: 16),
          Text(
            'juzz.no_juzz_found'.tr(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'search_results.try_different_keywords'.tr(),
            style: GoogleFonts.poppins(color: textColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
