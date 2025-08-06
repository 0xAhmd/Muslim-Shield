import 'package:flutter/material.dart';
import '../../data/dua_model.dart';
import '../../../constants.dart';

class DuaCard extends StatelessWidget {
  final DuaModel dua;
  final VoidCallback? onTap;

  const DuaCard({super.key, required this.dua, this.onTap});

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
              color: grey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primary.withOpacity(0.1), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and category
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dua.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        dua.category,
                        style: const TextStyle(
                          color: primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Arabic text (truncated)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _truncateArabic(dua.arabic),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 12),

                // Translation preview
                Text(
                  _truncateTranslation(dua.translation),
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Bottom row with reference and read more indicator
                Row(
                  children: [
                    if (dua.reference != null) ...[
                      const Icon(Icons.book, color: orange, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          dua.reference!,
                          style: const TextStyle(
                            color: orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else
                      const Spacer(),

                    const Row(
                      children: [
                        Text(
                          'Read more',
                          style: TextStyle(
                            color: primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, color: primary, size: 12),
                      ],
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

  String _truncateArabic(String text) {
    const maxLength = 80;
    if (text.length <= maxLength) return text;

    // Find the last space before maxLength to avoid cutting words
    int cutoff = maxLength;
    while (cutoff > 0 && text[cutoff] != ' ') {
      cutoff--;
    }

    if (cutoff == 0) cutoff = maxLength;
    return '${text.substring(0, cutoff)}...';
  }

  String _truncateTranslation(String text) {
    const maxLength = 100;
    if (text.length <= maxLength) return text;

    // Find the last space before maxLength to avoid cutting words
    int cutoff = maxLength;
    while (cutoff > 0 && text[cutoff] != ' ') {
      cutoff--;
    }

    if (cutoff == 0) cutoff = maxLength;
    return '${text.substring(0, cutoff)}...';
  }
}
