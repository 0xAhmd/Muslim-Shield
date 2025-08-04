import 'package:azkar/constants.dart';
import 'package:azkar/home/data/models/surah.dart';
import 'package:azkar/home/data/repo/surah_repo.dart';
import 'package:azkar/home/data/service/last_read.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum SurahMode { read, listen }

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen>
    with SingleTickerProviderStateMixin {
  final SurahRepository _repository = SurahRepository();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late TabController _tabController;
  SurahDetail? surahDetail;
  SurahDetail? surahWithAudio;
  bool isLoading = true;
  String? error;
  SurahMode currentMode = SurahMode.read;
  bool isPlaying = false;
  int currentAyah = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadSurahDetail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.index == 0) {
      setState(() => currentMode = SurahMode.read);
      _audioPlayer.stop();
    } else {
      setState(() => currentMode = SurahMode.listen);
      if (surahWithAudio == null) {
        _loadSurahWithAudio();
      }
    }
  }

  Future<void> _loadSurahDetail() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final detail = await _repository.getSurah(widget.surah.number);
      setState(() {
        surahDetail = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadSurahWithAudio() async {
    try {
      final audioDetail = await _repository.getSurahWithAudio(
        widget.surah.number,
      );
      setState(() {
        surahWithAudio = audioDetail;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load audio: $e')));
    }
  }

  Future<void> _playPause() async {
    if (surahWithAudio == null) return;

    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      // For demonstration - you'd need actual audio URLs from the API
      // The Al-Quran API doesn't provide direct audio URLs in this format
      // You might need to use a different API or construct URLs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio playback would be implemented here'),
        ),
      );
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/svgs/back-icon.svg', color: primary),
        ),
        title: Text(
          widget.surah.englishName,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // Replace the existing body in your Scaffold with this:
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(children: [_buildHeader(), _buildTabBar()]),
          ),
          SliverFillRemaining(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDF98EA), Color(0XFFB070FD), Color(0xFF9055FF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
     
          Column(
            children: [
              Text(
                widget.surah.englishName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.surah.englishNameTranslation,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
              Divider(
                color: Colors.white.withOpacity(.35),
                thickness: 2,
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.surah.revelationType.toUpperCase()} • ${widget.surah.numberOfAyahs} VERSES',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (widget.surah.number != 1 && widget.surah.number != 9)
                SvgPicture.asset('assets/svgs/bismillah.svg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: gray,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primary,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: text,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Read'),
          Tab(text: 'Listen'),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: primary));
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading surah',
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
              onPressed: _loadSurahDetail,
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [_buildReadMode(), _buildListenMode()],
    );
  }
  // Add this method to the _SurahDetailScreenState class

  Future<void> _showSaveProgressDialog() async {
    int selectedAyah = 1;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: gray,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Save Reading Progress',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select the ayah you\'re currently reading:',
                    style: GoogleFonts.poppins(color: text, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primary.withOpacity(0.3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedAyah,
                        isExpanded: true,
                        dropdownColor: background,
                        style: GoogleFonts.poppins(color: Colors.white),
                        icon: Icon(Icons.keyboard_arrow_down, color: primary),
                        items: List.generate(
                          surahDetail?.ayahs.length ?? 0,
                          (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text(
                              'Ayah ${index + 1}',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                        onChanged: (int? value) {
                          setState(() {
                            selectedAyah = value ?? 1;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: primary, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Progress: ${((selectedAyah / (surahDetail?.ayahs.length ?? 1)) * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.poppins(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: text),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await LastReadService.saveLastReadFromSurah(
                      surah: widget.surah,
                      ayahNumber: selectedAyah,
                    );

                    Navigator.of(context).pop();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('Progress saved: Ayah $selectedAyah'),
                            ],
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReadMode() {
    if (surahDetail == null) return const SizedBox();

    return Column(
      children: [
        // Save Progress Button
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(24),
          child: ElevatedButton.icon(
            onPressed: () => _showSaveProgressDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.bookmark_add),
            label: Text(
              'Save Reading Progress',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ),

        // Ayahs List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: surahDetail!.ayahs.length,
            itemBuilder: (context, index) {
              final ayah = surahDetail!.ayahs[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: 20,
                  bottom: 0,
                ),
                decoration: BoxDecoration(
                  color: gray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${ayah.numberInSurah}',
                        style: GoogleFonts.poppins(
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      ayah.text,
                      style: GoogleFonts.amiri(
                        color: Colors.white,
                        fontSize: 24,
                        height: 1.9,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListenMode() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: gray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                'Audio Player',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (currentAyah > 0) {
                        setState(() => currentAyah--);
                        // Save progress when navigating ayahs
                        if (surahDetail != null) {
                          await LastReadService.saveLastReadFromSurah(
                            surah: widget.surah,
                            ayahNumber: currentAyah + 1,
                          );
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: _playPause,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: primary,
                      size: 64,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (surahDetail != null &&
                          currentAyah < surahDetail!.ayahs.length - 1) {
                        setState(() => currentAyah++);
                        // Save progress when navigating ayahs
                        await LastReadService.saveLastReadFromSurah(
                          surah: widget.surah,
                          ayahNumber: currentAyah + 1,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Ayah ${currentAyah + 1} of ${widget.surah.numberOfAyahs}',
                style: GoogleFonts.poppins(color: text),
              ),
            ],
          ),
        ),
        if (surahDetail != null)
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: gray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${currentAyah + 1}',
                      style: GoogleFonts.poppins(
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        surahDetail!.ayahs[currentAyah].text,
                        style: GoogleFonts.amiri(
                          color: Colors.white,
                          fontSize: 24,
                          height: 2,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
