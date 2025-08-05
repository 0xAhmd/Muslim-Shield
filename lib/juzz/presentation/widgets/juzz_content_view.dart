import 'package:azkar/juzz/data/models/juzz.dart';
import 'package:azkar/juzz/data/models/juzz_ayah.dart';
import 'package:azkar/juzz/presentation/widgets/ayah_tile.dart';
import 'package:azkar/juzz/presentation/widgets/juzz_header_car.dart';
import 'package:azkar/juzz/presentation/widgets/surah_header_car.dart';
import 'package:flutter/material.dart';

class JuzzContentView extends StatelessWidget {
  final Juzz juzz;
  final int juzzNumber;
  final ScrollController scrollController;
  final int? lastReadAyahIndex;
  final Function(int) onLastReadChanged;

  const JuzzContentView({
    super.key,
    required this.juzz,
    required this.juzzNumber,
    required this.scrollController,
    required this.lastReadAyahIndex,
    required this.onLastReadChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JuzzHeaderCard(juzz: juzz),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: juzz.ayahs.length,
            itemBuilder: (context, index) {
              final ayah = juzz.ayahs[index];
              final isNewSurah = _isNewSurah(index, ayah);

              return Column(
                children: [
                  if (isNewSurah) SurahHeaderCard(ayah: ayah),
                  AyahTile(
                    ayah: ayah,
                    juzzNumber: juzzNumber,
                    isBookmarked: lastReadAyahIndex == ayah.number,
                    onBookmarkChanged: () => onLastReadChanged(ayah.number),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isNewSurah(int index, JuzzAyah ayah) {
    return index == 0 ||
        juzz.ayahs[index - 1].surah.number != ayah.surah.number;
  }
}
