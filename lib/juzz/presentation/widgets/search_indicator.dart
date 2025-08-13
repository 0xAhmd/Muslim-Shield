import '../../../constants.dart';
import '../cubit/juzz_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzSearchIndicator extends StatelessWidget {
  final JuzzLoaded state;

  const JuzzSearchIndicator({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // ignore: prefer_const_constructors
          Icon(Icons.search, color: primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${state.filteredJuzz.length} ${state.filteredJuzz.length == 1 ? 'result' : 'results'} for "${state.searchQuery}"',
              style: GoogleFonts.poppins(
                color: primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
