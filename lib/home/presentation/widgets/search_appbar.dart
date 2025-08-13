import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../pages/home_screen.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onToggleSearch;
  final ValueChanged<String> onSearchChanged;
  final bool canSearch;
  final String searchHint;

  const SearchAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onToggleSearch,
    required this.onSearchChanged,
    required this.canSearch,
    required this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: isSearching ? searchField() : normalTitle(context),
    );
  }

  Widget normalTitle(BuildContext context) {
    return Row(
      children: [
        // Menu button to open drawer using global key
        IconButton(
          onPressed: () {
            homeScaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: textColor, size: 24),
        ),
        Text(
          "Quran App", // Replace with your actual app name
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: canSearch ? onToggleSearch : null,
          icon: const Icon(Icons.search, color: textColor),
        ),
      ],
    );
  }

  Widget searchField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            autofocus: true,
            onChanged: onSearchChanged,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle: GoogleFonts.poppins(color: textColor, fontSize: 16),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        IconButton(
          onPressed: onToggleSearch,
          icon: const Icon(Icons.close, color: textColor),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}