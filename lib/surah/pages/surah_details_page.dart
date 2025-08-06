import 'package:azkar/bookmarks/presentation/cubit/bookmark_cubit.dart';
import 'package:azkar/bookmarks/presentation/cubit/bookmark_state.dart';
import 'package:azkar/bookmarks/service/bookmark_service.dart';
import 'package:azkar/constants.dart';
import 'package:azkar/surah/data/models/surah.dart';
import 'package:azkar/surah/data/repo/surah_repo.dart';
import 'package:azkar/surah/data/service/last_read.dart';
import 'package:azkar/surah/widgets/reciter_dialog.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  List<Reciter> reciters = [];
  SurahAudioResponse? audioResponse;

  bool isLoading = true;
  bool isLoadingAudio = false;
  bool isLoadingReciters = false;
  String? error;

  SurahMode currentMode = SurahMode.read;
  bool isPlaying = false;
  bool isPaused = false;
  int currentAyah = 0;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  // Default reciter (you can change this ID based on your preferred default)
  Reciter? selectedReciter;
  int defaultReciterId = 1; // Mishary Rashid Alafasy

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _setupAudioPlayer();
    _loadSurahDetail();
    _loadReciters();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        // Check if widget is still mounted
        setState(() {
          isPlaying = state == PlayerState.playing;
          isPaused = state == PlayerState.paused;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        // Check if widget is still mounted
        setState(() {
          currentPosition = position;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        // Check if widget is still mounted
        setState(() {
          totalDuration = duration;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        // Check if widget is still mounted
        _onAyahComplete();
      }
    });
  }

  void _onTabChanged() {
    if (_tabController.index == 0) {
      setState(() => currentMode = SurahMode.read);
      _audioPlayer.stop();
    } else {
      setState(() => currentMode = SurahMode.listen);
      if (audioResponse == null && selectedReciter != null) {
        _loadSurahAudio();
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

  Future<void> _loadReciters() async {
    try {
      setState(() {
        isLoadingReciters = true;
      });

      debugPrint('Starting to load reciters...');
      final fetchedReciters = await _repository.getReciters();
      debugPrint('Loaded ${fetchedReciters.length} reciters successfully');

      setState(() {
        reciters = fetchedReciters;
        // Set default reciter with better null safety
        if (reciters.isNotEmpty) {
          selectedReciter = reciters.firstWhere(
            (r) => r.id == defaultReciterId,
            orElse: () => reciters.first,
          );
          debugPrint('Selected reciter: ${selectedReciter?.name}');
        }
        isLoadingReciters = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error loading reciters: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        isLoadingReciters = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load reciters: $e')));
      }
    }
  }

  Future<void> _loadSurahAudio() async {
    if (selectedReciter == null) return;

    try {
      setState(() {
        isLoadingAudio = true;
      });

      final response = await _repository.getSurahAudio(
        selectedReciter!.id,
        widget.surah.number,
      );

      setState(() {
        audioResponse = response;
        isLoadingAudio = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAudio = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load audio: $e')));
      }
    }
  }

  Future<void> _playPause() async {
    if (audioResponse == null || selectedReciter == null) {
      await _loadSurahAudio();
      return;
    }

    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else if (isPaused) {
        await _audioPlayer.resume();
      } else {
        // Play current ayah
        if (currentAyah < audioResponse!.data.verses.length) {
          final audioAyah = audioResponse!.data.verses[currentAyah];
          await _audioPlayer.play(UrlSource(audioAyah.url));

          // Save progress when starting to play
          await LastReadService.saveLastReadFromSurah(
            surah: widget.surah,
            ayahNumber: currentAyah + 1,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Audio playback error: $e')));
      }
    }
  }

  Future<void> _playAyah(int ayahIndex) async {
    if (audioResponse == null ||
        ayahIndex >= audioResponse!.data.verses.length) {
      return;
    }

    try {
      setState(() {
        currentAyah = ayahIndex;
      });

      final audioAyah = audioResponse!.data.verses[ayahIndex];
      await _audioPlayer.play(UrlSource(audioAyah.url));

      // Save progress
      await LastReadService.saveLastReadFromSurah(
        surah: widget.surah,
        ayahNumber: ayahIndex + 1,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to play ayah: $e')));
      }
    }
  }

  void _onAyahComplete() {
    // Auto-play next ayah if available
    if (currentAyah < (audioResponse?.data.verses.length ?? 0) - 1) {
      setState(() {
        currentAyah++;
      });
      _playAyah(currentAyah);
    } else {
      // End of surah
      setState(() {
        isPlaying = false;
        isPaused = false;
        currentPosition = Duration.zero;
      });
    }
  }

  Future<void> _previousAyah() async {
    if (currentAyah > 0) {
      await _playAyah(currentAyah - 1);
    }
  }

  Future<void> _nextAyah() async {
    if (audioResponse != null &&
        currentAyah < audioResponse!.data.verses.length - 1) {
      await _playAyah(currentAyah + 1);
    }
  }

  void _showReciterDialog() {
    if (reciters.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => ReciterSelectionDialog(
        reciters: reciters,
        selectedReciterId: selectedReciter?.id ?? defaultReciterId,
        onReciterSelected: (Reciter reciter) {
          setState(() {
            selectedReciter = reciter;
            audioResponse = null; // Clear current audio
          });
          // Load new audio with selected reciter
          if (_tabController.index == 1) {
            _loadSurahAudio();
          }
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
        actions: [
          // Reciter selection button (only show in listen mode)
          if (_tabController.index == 1 && reciters.isNotEmpty)
            IconButton(
              onPressed: _showReciterDialog,
              icon: const Icon(Icons.person, color: primary),
              tooltip: 'Select Reciter',
            ),
        ],
      ),
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
        unselectedLabelColor: textColor,
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
      return const Center(child: CircularProgressIndicator(color: primary));
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
              style: GoogleFonts.poppins(color: textColor, fontSize: 12),
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
                    style: GoogleFonts.poppins(color: textColor, fontSize: 14),
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
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: primary,
                        ),
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
                        const Icon(
                          Icons.info_outline,
                          color: primary,
                          size: 16,
                        ),
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
                    style: GoogleFonts.poppins(color: textColor),
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
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
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
                    // Header with ayah number and bookmark button
                    Row(
                      children: [
                        // Bookmark button
                        BlocProvider(
                          create: (context) =>
                              BookmarksCubit(BookmarksService()),
                          child: BlocBuilder<BookmarksCubit, BookmarksState>(
                            builder: (context, bookmarkState) {
                              return FutureBuilder<bool>(
                                future: context
                                    .read<BookmarksCubit>()
                                    .isAyahBookmarked(
                                      widget.surah.number,
                                      ayah.numberInSurah,
                                    ),
                                builder: (context, snapshot) {
                                  final isBookmarked = snapshot.data ?? false;

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: isBookmarked
                                          ? primary.withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      onPressed: () => _toggleAyahBookmark(
                                        ayah,
                                        isBookmarked,
                                        context.read<BookmarksCubit>(),
                                      ),
                                      icon: Icon(
                                        isBookmarked
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: isBookmarked
                                            ? primary
                                            : textColor.withOpacity(0.7),
                                        size: 20,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        const Spacer(),

                        // Ayah number
                        Container(
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
                      ],
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
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Add this method to SurahDetailScreen class
  void _toggleAyahBookmark(
    dynamic ayah,
    bool isCurrentlyBookmarked,
    BookmarksCubit bookmarksCubit,
  ) async {
    try {
      if (isCurrentlyBookmarked) {
        await bookmarksCubit.removeAyahBookmark(
          widget.surah.number,
          ayah.numberInSurah,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.bookmark_remove, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Bookmark removed'),
                ],
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red.withOpacity(0.8),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        await bookmarksCubit.bookmarkAyah(
          surahNumber: widget.surah.number,
          ayahNumber: ayah.numberInSurah,
          surahName: widget.surah.englishName,
          ayahText: ayah.text,
          translation: '', // Provide an empty string as a fallback
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.bookmark_added, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Ayah bookmarked'),
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
      }
      // Force rebuild
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildListenMode() {
    return Column(
      children: [
        const SizedBox(height: 10),
        // Reciter Selection
        if (selectedReciter != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: gray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.person, color: primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedReciter!.name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _showReciterDialog,
                  child: Text(
                    'Change',
                    style: GoogleFonts.poppins(
                      color: primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: gray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              if (isLoadingAudio)
                Column(
                  children: [
                    const CircularProgressIndicator(color: primary),
                    const SizedBox(height: 12),
                    Text(
                      'Loading audio...',
                      style: GoogleFonts.poppins(color: textColor),
                    ),
                  ],
                )
              else ...[
                Text(
                  'Now Playing',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ayah ${currentAyah + 1} of ${widget.surah.numberOfAyahs}',
                  style: GoogleFonts.poppins(color: textColor),
                ),
                const SizedBox(height: 20),

                // Progress slider
                if (totalDuration.inSeconds > 0)
                  Column(
                    children: [
                      Slider(
                        value: currentPosition.inSeconds.toDouble(),
                        max: totalDuration.inSeconds.toDouble(),
                        activeColor: primary,
                        inactiveColor: textColor.withOpacity(0.3),
                        onChanged: (value) async {
                          await _audioPlayer.seek(
                            Duration(seconds: value.toInt()),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(currentPosition),
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDuration(totalDuration),
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: currentAyah > 0 ? _previousAyah : null,
                      icon: Icon(
                        Icons.skip_previous,
                        color: currentAyah > 0
                            ? Colors.white
                            : textColor.withOpacity(0.5),
                        size: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: selectedReciter != null ? _playPause : null,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: selectedReciter != null
                            ? primary
                            : textColor.withOpacity(0.5),
                        size: 64,
                      ),
                    ),
                    IconButton(
                      onPressed:
                          (audioResponse != null &&
                              currentAyah <
                                  audioResponse!.data.verses.length - 1)
                          ? _nextAyah
                          : null,
                      icon: Icon(
                        Icons.skip_next,
                        color:
                            (audioResponse != null &&
                                currentAyah <
                                    audioResponse!.data.verses.length - 1)
                            ? Colors.white
                            : textColor.withOpacity(0.5),
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Ayahs List with play buttons
        if (surahDetail != null && !isLoadingAudio)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: surahDetail!.ayahs.length,
              itemBuilder: (context, index) {
                final ayah = surahDetail!.ayahs[index];
                final isCurrentAyah = index == currentAyah && isPlaying;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCurrentAyah ? primary.withOpacity(0.1) : gray,
                    borderRadius: BorderRadius.circular(10),
                    border: isCurrentAyah
                        ? Border.all(color: primary, width: 2)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isCurrentAyah
                                  ? primary
                                  : primary.withOpacity(.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${ayah.numberInSurah}',
                              style: GoogleFonts.poppins(
                                color: isCurrentAyah ? Colors.white : primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _playAyah(index),
                            icon: Icon(
                              isCurrentAyah ? Icons.pause : Icons.play_arrow,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ayah.text,
                        style: GoogleFonts.amiri(
                          color: Colors.white,
                          fontSize: 22,
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
}
