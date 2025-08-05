import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final Color normalColor;
  final double fontSize;
  final FontWeight fontWeight;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.normalColor = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return _buildNormalText();
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return _buildNormalText();
    }

    return _buildHighlightedText(lowerText, lowerQuery);
  }

  Widget _buildNormalText() {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: normalColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }

  Widget _buildHighlightedText(String lowerText, String lowerQuery) {
    final index = lowerText.indexOf(lowerQuery);
    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return RichText(
      text: TextSpan(
        children: [
          _buildTextSpan(before, normalColor),
          _buildHighlightedSpan(match),
          _buildTextSpan(after, normalColor),
        ],
      ),
    );
  }

  TextSpan _buildTextSpan(String text, Color color) {
    return TextSpan(
      text: text,
      style: GoogleFonts.poppins(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }

  TextSpan _buildHighlightedSpan(String text) {
    return TextSpan(
      text: text,
      style: GoogleFonts.poppins(
        color: primary,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        backgroundColor: primary.withOpacity(0.2),
      ),
    );
  }
}
