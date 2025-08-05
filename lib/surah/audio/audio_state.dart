import 'package:azkar/surah/data/models/surah.dart';
import 'package:azkar/home/presentation/widgets/audio_player_manager.dart';
import 'package:azkar/home/presentation/widgets/audio_prefs.dart';
import 'package:azkar/home/presentation/widgets/ayah_manager.dart';

enum PlaybackState { stopped, playing, paused, loading }

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  late final AudioPreferences _preferences;
  late final AudioPlayerManager _playerManager;
  late final AyahManager _ayahManager;

  PlaybackState _playbackState = PlaybackState.stopped;

  // Getters
  PlaybackState get playbackState => _playbackState;
  int get currentAyah => _ayahManager.currentAyah;
  int get selectedReciterId => _preferences.selectedReciterId;
  String get selectedReciterName => _preferences.selectedReciterName;

  // Streams
  Stream<PlaybackState> get playbackStateStream =>
      _playerManager.playbackStateStream;
  Stream<Duration> get positionStream => _playerManager.positionStream;
  Stream<Duration?> get durationStream => _playerManager.durationStream;

  // Initialize
  Future<void> initialize() async {
    _preferences = AudioPreferences();
    _playerManager = AudioPlayerManager();
    _ayahManager = AyahManager();

    await _preferences.initialize();
    await _playerManager.initialize(_onAyahCompleted);
  }

  // Reciter management
  Future<void> setReciter(int reciterId, String reciterName) async {
    await _preferences.setReciter(reciterId, reciterName);
  }

  // Audio playback
  void setSurahAudio(List<AudioAyah> ayahs) {
    _ayahManager.setSurahAudio(ayahs);
  }

  Future<void> playAyah(int ayahIndex) async {
    if (!_ayahManager.isValidIndex(ayahIndex)) return;

    try {
      _playbackState = PlaybackState.loading;
      _ayahManager.setCurrentAyah(ayahIndex);

      final audioUrl = _ayahManager.getCurrentAyahUrl();
      await _playerManager.play(audioUrl);

      _playbackState = PlaybackState.playing;
    } catch (e) {
      _playbackState = PlaybackState.stopped;
      throw Exception('Failed to play ayah: $e');
    }
  }

  Future<void> playPause() async {
    switch (_playbackState) {
      case PlaybackState.playing:
        await pause();
        break;
      case PlaybackState.paused:
        await resume();
        break;
      default:
        await playAyah(currentAyah);
    }
  }

  Future<void> pause() async {
    await _playerManager.pause();
    _playbackState = PlaybackState.paused;
  }

  Future<void> resume() async {
    await _playerManager.resume();
    _playbackState = PlaybackState.playing;
  }

  Future<void> stop() async {
    await _playerManager.stop();
    _playbackState = PlaybackState.stopped;
  }

  Future<void> nextAyah() async {
    final nextIndex = _ayahManager.getNextAyahIndex();
    if (nextIndex != null) {
      await playAyah(nextIndex);
    }
  }

  Future<void> previousAyah() async {
    final prevIndex = _ayahManager.getPreviousAyahIndex();
    if (prevIndex != null) {
      await playAyah(prevIndex);
    }
  }

  Future<void> seek(Duration position) async {
    await _playerManager.seek(position);
  }

  Future<void> setPlaybackRate(double rate) async {
    await _playerManager.setPlaybackRate(rate);
  }

  void _onAyahCompleted() {
    final nextIndex = _ayahManager.getNextAyahIndex();
    if (nextIndex != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        nextAyah();
      });
    } else {
      _playbackState = PlaybackState.stopped;
    }
  }

  Future<void> dispose() async {
    await _playerManager.dispose();
  }
}
