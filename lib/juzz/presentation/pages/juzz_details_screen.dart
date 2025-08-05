import 'package:azkar/constants.dart';
import 'package:azkar/home/data/service/last_read.dart';
import 'package:azkar/juzz/data/models/juzz.dart';
import 'package:azkar/juzz/data/models/juzz_ayah.dart';
import 'package:azkar/juzz/presentation/cubit/juzz_cubit.dart';
import 'package:azkar/juzz/presentation/cubit/juzz_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class JuzzDetailScreen extends StatefulWidget {
  final int juzzNumber;
  final JuzzCubit juzzCubit;

  const JuzzDetailScreen({
    super.key,
    required this.juzzNumber,
    required this.juzzCubit,
  });

  @override
  State<JuzzDetailScreen> createState() => _JuzzDetailScreenState();
}

class _JuzzDetailScreenState extends State<JuzzDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _lastReadAyahIndex;

  @override
  void initState() {
    super.initState();
    widget.juzzCubit.loadJuzzDetails(widget.juzzNumber);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveLastRead(JuzzAyah ayah) async {
    try {
      await LastReadService.saveLastReadFromJuzzAyah(
        juzzAyah: ayah,
        juzzNumber: widget.juzzNumber,
      );

      setState(() {
        _lastReadAyahIndex = ayah.number;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Bookmark saved',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving last read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocProvider.value(
        value: widget.juzzCubit,
        child: BlocBuilder<JuzzCubit, JuzzState>(
          builder: (context, state) {
            if (state is JuzzDetailLoading) {
              return _buildLoadingState();
            }

            if (state is JuzzDetailError) {
              return _buildErrorState(state);
            }

            if (state is JuzzDetailLoaded) {
              return _buildJuzzContent(state.juzz);
            }

            return _buildInitialState();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: background,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: SvgPicture.asset(
          'assets/svgs/back-icon.svg',
          // ignore: deprecated_member_use
          color: Colors.white,
        ),
      ),
      title: Text(
        'Juzz ${widget.juzzNumber}',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            widget.juzzCubit.loadJuzzDetails(widget.juzzNumber);
          },
          icon: Icon(Icons.refresh, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primary),
          const SizedBox(height: 24),
          Text(
            'Loading Juzz ${widget.juzzNumber}...',
            style: GoogleFonts.poppins(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we fetch the verses',
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(JuzzDetailError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Error Loading Juzz',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: GoogleFonts.poppins(color: textColor, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => widget.juzzCubit.retry(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.refresh, size: 18),
                  label: Text('Retry'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: textColor),
                    foregroundColor: textColor,
                  ),
                  icon: Icon(Icons.arrow_back, size: 18),
                  label: Text('Go Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Text(
        'Initializing...',
        style: GoogleFonts.poppins(color: textColor),
      ),
    );
  }

  Widget _buildJuzzContent(Juzz juzz) {
    return Column(
      children: [
        _buildJuzzHeader(juzz),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: juzz.ayahs.length,
            itemBuilder: (context, index) {
              final ayah = juzz.ayahs[index];
              final isNewSurah =
                  index == 0 ||
                  juzz.ayahs[index - 1].surah.number != ayah.surah.number;

              return Column(
                children: [
                  if (isNewSurah) _buildSurahHeader(ayah),
                  _buildAyahTile(ayah, index),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJuzzHeader(Juzz juzz) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary.withOpacity(0.8), primary],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Juzz ${juzz.number}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${juzz.totalAyahs} Ayahs • ${juzz.containedSurahs.length} Surahs',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            juzz.surahRange,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahHeader(JuzzAyah ayah) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset('assets/svgs/nomor-surah.svg'),
              Text(
                "${ayah.surah.number}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ayah.surah.englishName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  ayah.surah.englishNameTranslation,
                  style: GoogleFonts.poppins(color: textColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            ayah.surah.name,
            style: GoogleFonts.amiri(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahTile(JuzzAyah ayah, int index) {
    final isBookmarked = _lastReadAyahIndex == ayah.number;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBookmarked ? primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isBookmarked
            ? Border.all(color: primary.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ayah header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${ayah.numberInSurah}',
                  style: GoogleFonts.poppins(
                    color: primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              if (isBookmarked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Last Read',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _saveLastRead(ayah),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: primary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Arabic text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              ayah.text,
              style: GoogleFonts.amiri(
                fontSize: 20,
                color: Colors.white,
                height: 1.8,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),

          const SizedBox(height: 12),

          // Metadata
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildMetadataChip('Page ${ayah.page}', Icons.book),
              _buildMetadataChip('Ruku ${ayah.ruku}', Icons.bookmark_outlined),
              if (ayah.sajda)
                _buildMetadataChip(
                  'Sajda',
                  Icons.keyboard_arrow_down,
                  color: orange,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataChip(String label, IconData icon, {Color? color}) {
    final chipColor = color ?? textColor.withOpacity(0.7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: chipColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: chipColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to add to LastReadService for Juzz support
extension LastReadJuzzExtension on LastReadService {
  static Future<void> saveLastReadFromJuzzAyah({
    required JuzzAyah juzzAyah,
    required int juzzNumber,
  }) async {
    final lastReadData = LastReadData(
      surahNumber: juzzAyah.surah.number,
      surahEnglishName: juzzAyah.surah.englishName,
      ayahNumber: juzzAyah.numberInSurah,
      progressPercentage:
          (juzzAyah.numberInSurah / juzzAyah.surah.numberOfAyahs) * 100,
      lastReadAt: DateTime.now(),
      juzzNumber: juzzNumber,
    );

    await LastReadService.saveLastRead(lastReadData);
  }
}
