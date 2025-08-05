// lib/home/presentation/widgets/search_app_bar.dart
import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
      title: isSearching ? searchField() : normalTitle(),
    );
  }

  Widget normalTitle() {
    return Row(
      children: [
        const SizedBox(width: 8),
        Text(
          "Azkar",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: canSearch ? onToggleSearch : null,
          icon: SvgPicture.asset(
            'assets/svgs/search-icon.svg',
            // ignore: deprecated_member_use
            color: canSearch ? null : textColor.withOpacity(0.5),
          ),
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        IconButton(
          onPressed: onToggleSearch,
          icon: Icon(Icons.close, color: textColor),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
