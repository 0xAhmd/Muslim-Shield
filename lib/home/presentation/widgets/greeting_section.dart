import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../surah/widgets/last_read_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText(
              'greeting.assalamu_alaikum'.tr(),
              textAlign: TextAlign.left,
              textStyle: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText(
              'greeting.bless_muhammad'.tr(),
              textAlign: TextAlign.left,
              textStyle: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const LastReadCard(),
      ],
    );
  }
}