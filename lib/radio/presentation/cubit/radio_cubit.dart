import 'package:audio_service/audio_service.dart';
import 'package:azkar/radio/data/models/radio.dart';
import 'package:azkar/radio/data/models/radio_data.dart';
import 'package:azkar/radio/data/services/background_service.dart';
import 'package:azkar/radio/presentation/cubit/radio_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class RadioCubit extends Cubit<RadioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  RadioAudioHandler? _audioHandler;
  RadioModel? _currentStation;

  RadioCubit() : super(RadioInitial()) {
    _init();
  }

  Future<void> _init() async {
    try {
      _audioHandler = await AudioService.init(
        builder: () => RadioAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.muslim_shield.radio',
          androidNotificationChannelName: 'Muslim Shield Radio',
          androidNotificationOngoing: true,
          androidShowNotificationBadge: true,
          androidNotificationIcon: 'drawable/ic_notification',
          fastForwardInterval: Duration(seconds: 10),
          rewindInterval: Duration(seconds: 10),
        ),
      );
      _setupAudioServiceListeners();
    } catch (e) {
      // Fallback to regular audio player if audio service fails
      debugPrint('Audio service initialization failed: $e');
      _setupAudioPlayerListeners();
    }
  }

  void _setupAudioServiceListeners() {
    if (_audioHandler == null) return;

    _audioHandler!.playbackState.listen((playbackState) {
      if (_currentStation != null) {
        switch (playbackState.processingState) {
          case AudioProcessingState.loading:
          case AudioProcessingState.buffering:
            emit(RadioBuffering(station: _currentStation!));
            break;
          case AudioProcessingState.ready:
            if (playbackState.playing) {
              emit(
                RadioPlaying(
                  station: _currentStation!,
                  position: Duration.zero,
                ),
              );
            } else {
              emit(RadioPaused(station: _currentStation!));
            }
            break;
          case AudioProcessingState.completed:
          case AudioProcessingState.idle:
          case AudioProcessingState.error:
            if (playbackState.processingState == AudioProcessingState.error) {
              emit(RadioError('Playback error occurred'));
            } else {
              emit(RadioStopped());
            }
            break;
        }
      }
    });
  }

  void _setupAudioPlayerListeners() {
    // Listen to player state changes with error handling
    _audioPlayer.playerStateStream.listen(
      (playerState) {
        if (_currentStation != null) {
          switch (playerState.processingState) {
            case ProcessingState.loading:
            case ProcessingState.buffering:
              emit(RadioBuffering(station: _currentStation!));
              break;
            case ProcessingState.ready:
              if (playerState.playing) {
                emit(
                  RadioPlaying(
                    station: _currentStation!,
                    position: _audioPlayer.position,
                  ),
                );
              } else {
                emit(RadioPaused(station: _currentStation!));
              }
              break;
            case ProcessingState.completed:
            case ProcessingState.idle:
              emit(RadioStopped());
              break;
          }
        }
      },
      onError: (error) {
        emit(RadioError('Audio player error: ${error.toString()}'));
      },
    );

    // Listen to position changes with error handling
    _audioPlayer.positionStream.listen(
      (position) {
        if (state is RadioPlaying && _currentStation != null) {
          emit(RadioPlaying(station: _currentStation!, position: position));
        }
      },
      onError: (error) {
        // Handle position stream errors silently
        debugPrint('Position stream error: $error');
      },
    );
  }

  Future<void> playStation(RadioModel station) async {
    try {
      emit(RadioLoading());
      _currentStation = station;

      if (_audioHandler != null) {
        // Use audio service for background playback
        await _audioHandler!.playFromUrl(station.url, title: station.name);
      } else {
        // Fallback to regular audio player
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(station.url),
            headers: {'User-Agent': 'Muslim Shield Radio Player/1.0'},
          ),
          preload: false,
        );
        await _audioPlayer.play();
      }
    } catch (e) {
      emit(RadioError('Failed to play radio: ${e.toString()}'));
      _currentStation = null;
    }
  }

  Future<void> pause() async {
    try {
      if (_audioHandler != null) {
        await _audioHandler!.pause();
      } else {
        await _audioPlayer.pause();
      }

      if (_currentStation != null) {
        emit(RadioPaused(station: _currentStation!));
      }
    } catch (e) {
      emit(RadioError('Failed to pause: ${e.toString()}'));
    }
  }

  Future<void> resume() async {
    try {
      if (_audioHandler != null) {
        await _audioHandler!.play();
      } else {
        await _audioPlayer.play();
      }

      if (_currentStation != null) {
        emit(
          RadioPlaying(
            station: _currentStation!,
            position: _audioPlayer.position,
          ),
        );
      }
    } catch (e) {
      emit(RadioError('Failed to resume: ${e.toString()}'));
    }
  }

  Future<void> stop() async {
    try {
      if (_audioHandler != null) {
        await _audioHandler!.stop();
      } else {
        await _audioPlayer.stop();
      }

      _currentStation = null;
      emit(RadioStopped());
    } catch (e) {
      emit(RadioError('Failed to stop: ${e.toString()}'));
    }
  }

  bool get isPlaying {
    if (_audioHandler != null) {
      return _audioHandler!.playbackState.value.playing;
    }
    return _audioPlayer.playing;
  }

  RadioModel get defaultStation => RadioData.defaultStation;

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    return super.close();
  }
}
