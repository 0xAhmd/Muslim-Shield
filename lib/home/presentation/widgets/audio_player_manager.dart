import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:azkar/home/audio/audio_state.dart';

class AudioPlayerManager {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Stream<PlaybackState> get playbackStateStream =>
      _audioPlayer.onPlayerStateChanged.map((state) {
        switch (state) {
          case PlayerState.playing:
            return PlaybackState.playing;
          case PlayerState.paused:
            return PlaybackState.paused;
          case PlayerState.stopped:
          case PlayerState.completed:
          case PlayerState.disposed:
            return PlaybackState.stopped;
        }
      });

  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;
  Stream<Duration?> get durationStream => _audioPlayer.onDurationChanged;

  Future<void> initialize(VoidCallback onCompleted) async {
    _audioPlayer.onPlayerComplete.listen((_) => onCompleted());
  }

  Future<void> play(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setPlaybackRate(double rate) async {
    await _audioPlayer.setPlaybackRate(rate);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
