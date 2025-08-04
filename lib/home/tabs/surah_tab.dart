import 'package:azkar/constants.dart';
import 'package:azkar/home/data/models/surah.dart';
import 'package:azkar/home/data/repo/surah_repo.dart';
import 'package:azkar/home/data/service/last_read.dart';
import 'package:azkar/surah/pages/surah_details_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SurahTab extends StatefulWidget {
  const SurahTab({super.key});

  @override
  State<SurahTab> createState() => _SurahTabState();
}

class _SurahTabState extends State<SurahTab> {
  final SurahRepository _repository = SurahRepository();
  List<Surah> surahs = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedSurahs = await _repository.getSurahs();
      setState(() {
        surahs = fetchedSurahs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: primary));
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading surahs',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              style: GoogleFonts.poppins(color: text, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSurahs,
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 16),
      itemCount: surahs.length,
      separatorBuilder: (context, index) => Divider(
        color: const Color(0xFFAAAAAA).withOpacity(.35),
        thickness: 1,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final surah = surahs[index];
        return _SurahTile(
          surah: surah,
          onTap: () async {
            // Save as last read when tapping on a surah
            await LastReadService.saveLastReadFromSurah(
              surah: surah,
              ayahNumber: 1, // Start from first ayah when entering surah
            );

            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(surah: surah),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _SurahTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const _SurahTile({required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          SvgPicture.asset('assets/svgs/nomor-surah.svg'),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Text(
                "${surah.number}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        surah.englishName,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        "${surah.englishNameTranslation} • ${surah.numberOfAyahs} Ayahs",
        style: GoogleFonts.poppins(color: text, fontSize: 12),
      ),
      trailing: Text(
        surah.name,
        style: GoogleFonts.amiri(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
