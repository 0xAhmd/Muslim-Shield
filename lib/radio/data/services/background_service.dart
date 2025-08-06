// lib/radio/service/audio_handler.dart
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  RadioAudioHandler() {
    _init();
  }

  void _init() {
    // Listen to player state changes and update the system
    _audioPlayer.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      final processingState = _mapProcessingState(playerState.processingState);

      playbackState.add(
        playbackState.value.copyWith(
          playing: playing,
          processingState: processingState,
        ),
      );
    });

    // Set initial playbook state
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.play,
          MediaControl.pause,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
  }

  @override
  Future<void> play() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> playFromUrl(String url, {required String title}) async {
    // Set media item for notification
    mediaItem.add(
      MediaItem(
        id: url,
        album: 'Islamic Radio',
        title: title,
        artist: 'إذاعة القرآن الكريم من القاهرة',
        duration: null, // Live stream has no duration
        artUri: Uri.parse('https://via.placeholder.com/300x300.png?text=Radio'),
        playable: true,
      ),
    );

    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(url)),
      );
      await play();
    } catch (e) {
      // Handle error
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
        ),
      );
    }
  }

  AudioProcessingState _mapProcessingState(ProcessingState processingState) {
    switch (processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
    await super.onTaskRemoved();
  }

  @override
  Future<void> onNotificationDeleted() async {
    await stop();
    await super.onNotificationDeleted();
  }
}