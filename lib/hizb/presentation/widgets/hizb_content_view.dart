// ignore_for_file: unused_field

import 'package:azkar/constants.dart';
import 'package:azkar/hizb/data/models/hizb.dart';
import 'package:azkar/hizb/data/models/hizb_ayah.dart';
import 'package:azkar/hizb/presentation/widgets/hizb_detaild_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HizbContentView extends StatefulWidget {
  final Hizb hizb;
  final int hizbNumber;
  final ScrollController scrollController;
  final int? lastReadAyahIndex;
  final Function(int) onLastReadChanged;

  const HizbContentView({
    super.key,
    required this.hizb,
    required this.hizbNumber,
    required this.scrollController,
    this.lastReadAyahIndex,
    required this.onLastReadChanged,
  });

  @override
  State<HizbContentView> createState() => _HizbContentViewState();
}

class _HizbContentViewState extends State<HizbContentView> {
  double _fontSize = 18.0;
  String? _currentSurahName;
  int _currentSurahNumber = 0;

  @override
  void initState() {
    super.initState();
    if (widget.hizb.ayahs.isNotEmpty) {
      _currentSurahName = widget.hizb.ayahs.first.surah.englishName;
      _currentSurahNumber = widget.hizb.ayahs.first.surah.number;
    }
  }

  void _onRefresh() {
    // Trigger refresh from parent
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: HizbDetailAppBar(
        hizbNumber: widget.hizbNumber,
        onRefresh: _onRefresh,
      ),
      body: Column(
        children: [
          _buildHizbHeader(),
          _buildControlsBar(),
          Expanded(child: _buildAyahsList()),
        ],
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildHizbHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.1), primary.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            'حزب ${_convertToArabicNumbers(widget.hizbNumber)}',
            style: GoogleFonts.amiri(
              color: primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hizb ${widget.hizbNumber}',
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatChip(
                icon: Icons.format_list_numbered,
                label: 'Ayahs',
                value: '${widget.hizb.totalAyahs}',
              ),
              _buildStatChip(
                icon: Icons.book_outlined,
                label: 'Surahs',
                value: '${widget.hizb.containedSurahs.length}',
              ),
              _buildStatChip(
                icon: Icons.bookmark_outline,
                label: 'Juzz',
                value: widget.hizb.juzzRange.replaceAll('Juzz ', ''),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Row(children: [_buildFontControls()]),
    );
  }

  Widget _buildFontControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            if (_fontSize > 12) {
              setState(() => _fontSize -= 2);
            }
          },
          icon: const Icon(Icons.text_decrease, color: textColor, size: 20),
        ),
        Text(
          '${_fontSize.toInt()}',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          onPressed: () {
            if (_fontSize < 32) {
              setState(() => _fontSize += 2);
            }
          },
          icon: const Icon(Icons.text_increase, color: textColor, size: 20),
        ),
      ],
    );
  }

  Widget _buildAyahsList() {
    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.hizb.ayahs.length,
      itemBuilder: (context, index) {
        final ayah = widget.hizb.ayahs[index];
        final isLastRead = widget.lastReadAyahIndex == index;
        final isNewSurah =
            index == 0 ||
            ayah.surah.number != widget.hizb.ayahs[index - 1].surah.number;

        return Column(
          children: [
            if (isNewSurah) _buildSurahHeader(ayah),
            _buildAyahCard(ayah, index, isLastRead),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _buildSurahHeader(HizbAyah ayah) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [orange.withOpacity(0.1), orange.withOpacity(0.05)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${ayah.surah.number}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ayah.surah.englishName,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  ayah.surah.name,
                  style: GoogleFonts.amiri(
                    color: textColor.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahCard(HizbAyah ayah, int index, bool isLastRead) {
    return GestureDetector(
      onTap: () => widget.onLastReadChanged(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLastRead ? primary.withOpacity(0.1) : grey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLastRead
                ? primary.withOpacity(0.3)
                : grey.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAyahHeader(ayah, index, isLastRead),
            const SizedBox(height: 12),
            _buildAyahText(ayah),

            if (ayah.sajda) _buildSajdaIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildAyahHeader(HizbAyah ayah, int index, bool isLastRead) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLastRead ? primary : orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${ayah.numberInSurah}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Ayah ${ayah.numberInSurah}',
          style: GoogleFonts.poppins(
            color: textColor.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (isLastRead)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Last Read',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        IconButton(
          onPressed: () => _showAyahOptions(ayah, index),
          icon: Icon(
            Icons.more_vert,
            color: textColor.withOpacity(0.6),
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildAyahText(HizbAyah ayah) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        ayah.text,
        style: GoogleFonts.amiri(
          color: textColor,
          fontSize: _fontSize,
          height: 2.0,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildSajdaIndicator() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: orange),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.keyboard_arrow_down, color: orange, size: 16),
          const SizedBox(width: 4),
          Text(
            'Sajdah',
            style: GoogleFonts.poppins(
              color: orange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "scroll_to_top",
          mini: true,
          backgroundColor: primary,
          onPressed: () {
            widget.scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: "scroll_to_bottom",
          mini: true,
          backgroundColor: orange,
          onPressed: () {
            widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ),
      ],
    );
  }

  void _showAyahOptions(HizbAyah ayah, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: grey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ayah ${ayah.numberInSurah} Options',
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              icon: Icons.bookmark,
              title: 'Mark as Last Read',
              onTap: () {
                widget.onLastReadChanged(index);
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: primary),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String _convertToArabicNumbers(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join('');
  }
}
