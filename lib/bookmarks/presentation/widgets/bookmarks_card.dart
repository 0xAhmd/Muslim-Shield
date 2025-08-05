// lib/bookmarks/presentation/widgets/bookmark_card.dart
import 'package:azkar/bookmarks/model/bookmark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';

class BookmarkCard extends StatelessWidget {
  final BookmarkModel bookmark;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool showRemoveButton;

  const BookmarkCard({
    super.key,
    required this.bookmark,
    this.onTap,
    this.onRemove,
    this.showRemoveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: gray,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primary.withOpacity(0.1), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with type, title and actions
                Row(
                  children: [
                    // Type indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bookmark.type.icon,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            bookmark.type.displayName,
                            style: TextStyle(
                              color: _getTypeColor(),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Category (if available)
                    if (bookmark.category != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          bookmark.category!,
                          style: const TextStyle(
                            color: primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Spacer(),
                    // Actions
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Copy button
                        IconButton(
                          onPressed: () => _copyToClipboard(context),
                          icon: Icon(
                            Icons.copy,
                            color: textColor.withOpacity(0.7),
                            size: 18,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        // Remove button
                        if (showRemoveButton)
                          IconButton(
                            onPressed: () => _showRemoveDialog(context),
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red.withOpacity(0.7),
                              size: 18,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  bookmark.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // Content preview based on type
                _buildContentPreview(),

                const SizedBox(height: 12),

                // Footer with reference and date
                Row(
                  children: [
                    // Reference
                    if (bookmark.reference != null) ...[
                      const Icon(Icons.book, color: orange, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          bookmark.reference!,
                          style: GoogleFonts.poppins(
                            color: orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else
                      const Spacer(),

                    // Date
                    Text(
                      _formatDate(bookmark.createdAt),
                      style: GoogleFonts.poppins(
                        color: textColor.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentPreview() {
    switch (bookmark.type) {
      case BookmarkType.ayah:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arabic text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primary.withOpacity(0.2), width: 1),
              ),
              child: Text(
                _truncateText(bookmark.content, 80),
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 8),
            // Translation
            if (bookmark.translation != null)
              Text(
                _truncateText(bookmark.translation!, 120),
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
          ],
        );

      case BookmarkType.dua:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arabic text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primary.withOpacity(0.2), width: 1),
              ),
              child: Text(
                _truncateText(bookmark.content, 80),
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 8),
            // Translation
            if (bookmark.translation != null)
              Text(
                _truncateText(bookmark.translation!, 120),
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
          ],
        );

      default:
        return Text(
          bookmark.snippet,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 14,
            height: 1.5,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        );
    }
  }

  Color _getTypeColor() {
    switch (bookmark.type) {
      case BookmarkType.ayah:
        return primary;
      case BookmarkType.dua:
        return orange;
      case BookmarkType.hadith:
        return const Color(0xFF4CAF50);
      case BookmarkType.other:
        return textColor;
    }
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;

    // Find the last space before maxLength to avoid cutting words
    int cutoff = maxLength;
    while (cutoff > 0 && text[cutoff] != ' ') {
      cutoff--;
    }

    if (cutoff == 0) cutoff = maxLength;
    return '${text.substring(0, cutoff)}...';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final bookmarkDate = DateTime(date.year, date.month, date.day);

    if (bookmarkDate == today) {
      return 'Today';
    } else if (bookmarkDate == yesterday) {
      return 'Yesterday';
    } else {
      final difference = today.difference(bookmarkDate).inDays;
      if (difference < 7) {
        return '${difference}d ago';
      } else if (difference < 30) {
        return '${(difference / 7).floor()}w ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    }
  }

  void _copyToClipboard(BuildContext context) {
    String textToCopy = '';

    switch (bookmark.type) {
      case BookmarkType.ayah:
        textToCopy =
            '${bookmark.title}\n\n'
            '${bookmark.content}\n\n'
            '${bookmark.translation ?? ""}'
            '${bookmark.reference != null ? "\n\n${bookmark.reference}" : ""}';
        break;
      case BookmarkType.dua:
        textToCopy =
            '${bookmark.title}\n\n'
            '${bookmark.content}\n\n'
            '${bookmark.translation ?? ""}'
            '${bookmark.transliteration != null ? "\n\nTransliteration: ${bookmark.transliteration}" : ""}'
            '${bookmark.reference != null ? "\n\nReference: ${bookmark.reference}" : ""}';
        break;
      default:
        textToCopy = '${bookmark.title}\n\n${bookmark.content}';
    }

    Clipboard.setData(ClipboardData(text: textToCopy));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Copied to clipboard'),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: gray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Remove Bookmark',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: Text(
            'Are you sure you want to remove this bookmark?',
            style: GoogleFonts.poppins(color: textColor, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: textColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRemove?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Remove',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
