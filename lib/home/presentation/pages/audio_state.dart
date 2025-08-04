import 'package:audioplayers/audioplayers.dart';
import 'package:azkar/home/data/models/surah.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PlaybackState { stopped, playing, paused, loading }

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  PlaybackState _playbackState = PlaybackState.stopped;
  int _currentAyah = 0;
  int _selectedReciterId = 1; // Default reciter
  String _selectedReciterName = 'AbdulBaset AbdulSamad';
  List<AudioAyah>? _currentAyahs;

  // Getters
  PlaybackState get playbackState => _playbackState;
  int get currentAyah => _currentAyah;
  int get selectedReciterId => _selectedReciterId;
  String get selectedReciterName => _selectedReciterName;

  // Stream controllers for state updates
  Stream<PlaybackState> get playbackStateStream =>
      _audioPlayer.onPlayerStateChanged.map((state) {
        switch (state) {
          case PlayerState.playing:
            return PlaybackState.playing;
          case PlayerState.paused:
            return PlaybackState.paused;
          case PlayerState.stopped:
          case PlayerState.completed:
            return PlaybackState.stopped;
          case PlayerState.disposed:
            return PlaybackState.stopped;
        }
      });

  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;
  Stream<Duration?> get durationStream => _audioPlayer.onDurationChanged;

  // Initialize audio player
  Future<void> initialize() async {
    await _loadSelectedReciter();

    // Handle audio completion
    _audioPlayer.onPlayerComplete.listen((_) {
      _onAyahCompleted();
    });
  }

  // Load saved reciter preference
  Future<void> _loadSelectedReciter() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedReciterId = prefs.getInt('selected_reciter_id') ?? 1;
    _selectedReciterName =
        prefs.getString('selected_reciter_name') ?? 'AbdulBaset AbdulSamad';
  }

  // Save reciter preference
  Future<void> setReciter(int reciterId, String reciterName) async {
    _selectedReciterId = reciterId;
    _selectedReciterName = reciterName;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_reciter_id', reciterId);
    await prefs.setString('selected_reciter_name', reciterName);
  }

  // Set current surah audio data
  void setSurahAudio(List<AudioAyah> ayahs) {
    _currentAyahs = ayahs;
    _currentAyah = 0;
  }

  // Play specific ayah
  Future<void> playAyah(int ayahIndex) async {
    if (_currentAyahs == null || ayahIndex >= _currentAyahs!.length) return;

    try {
      _playbackState = PlaybackState.loading;
      _currentAyah = ayahIndex;

      final audioUrl = _currentAyahs![ayahIndex].url;
      await _audioPlayer.play(UrlSource(audioUrl));

      _playbackState = PlaybackState.playing;
    } catch (e) {
      _playbackState = PlaybackState.stopped;
      throw Exception('Failed to play ayah: $e');
    }
  }

  // Play/pause current ayah
  Future<void> playPause() async {
    if (_playbackState == PlaybackState.playing) {
      await pause();
    } else if (_playbackState == PlaybackState.paused) {
      await resume();
    } else {
      // Start playing from current ayah
      await playAyah(_currentAyah);
    }
  }

  // Pause playback
  Future<void> pause() async {
    await _audioPlayer.pause();
    _playbackState = PlaybackState.paused;
  }

  // Resume playback
  Future<void> resume() async {
    await _audioPlayer.resume();
    _playbackState = PlaybackState.playing;
  }

  // Stop playback
  Future<void> stop() async {
    await _audioPlayer.stop();
    _playbackState = PlaybackState.stopped;
  }

  // Go to next ayah
  Future<void> nextAyah() async {
    if (_currentAyahs == null) return;

    if (_currentAyah < _currentAyahs!.length - 1) {
      await playAyah(_currentAyah + 1);
    }
  }

  // Go to previous ayah
  Future<void> previousAyah() async {
    if (_currentAyahs == null) return;

    if (_currentAyah > 0) {
      await playAyah(_currentAyah - 1);
    }
  }

  // Handle ayah completion
  void _onAyahCompleted() {
    if (_currentAyahs != null && _currentAyah < _currentAyahs!.length - 1) {
      // Auto-play next ayah
      Future.delayed(const Duration(milliseconds: 500), () {
        nextAyah();
      });
    } else {
      // End of surah
      _playbackState = PlaybackState.stopped;
    }
  }

  // Seek to position
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Set playback speed
  Future<void> setPlaybackRate(double rate) async {
    await _audioPlayer.setPlaybackRate(rate);
  }

  // Dispose resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
