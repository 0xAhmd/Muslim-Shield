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
  int _currentStationIndex = 0;
  bool _isRetrying = false;

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
              emit(RadioPlaying(station: _currentStation!, position: Duration.zero));
            } else {
              emit(RadioPaused(station: _currentStation!));
            }
            break;
          case AudioProcessingState.completed:
          case AudioProcessingState.idle:
          case AudioProcessingState.error:
            if (playbackState.processingState == AudioProcessingState.error) {
              _handlePlaybackError();
            } else {
              emit(RadioStopped());
            }
            break;
        }
      }
    });
  }

  void _setupAudioPlayerListeners() {
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
                emit(RadioPlaying(station: _currentStation!, position: _audioPlayer.position));
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
        _handlePlaybackError();
      },
    );

    _audioPlayer.positionStream.listen(
      (position) {
        if (state is RadioPlaying && _currentStation != null) {
          emit(RadioPlaying(station: _currentStation!, position: position));
        }
      },
      onError: (error) {
        debugPrint('Position stream error: $error');
      },
    );
  }

  Future<void> _handlePlaybackError() async {
    if (_isRetrying) return; // Prevent infinite retry loop
    
    _isRetrying = true;
    emit(RadioError('Station unavailable, trying next station...'));
    
    // Wait a moment before retrying
    await Future.delayed(const Duration(seconds: 2));
    
    // Try next station
    await nextStation();
    _isRetrying = false;
  }

  Future<void> playStation(RadioModel station) async {
    try {
      emit(RadioLoading());
      _currentStation = station;
      _currentStationIndex = RadioData.stations.indexOf(station);

      if (_audioHandler != null) {
        await _audioHandler!.playFromUrl(station.url, title: station.name);
      } else {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(station.url),
            headers: {
              'User-Agent': 'Muslim Shield Radio Player/1.0',
              'Accept': '*/*',
              'Connection': 'keep-alive',
            },
          ),
          preload: false,
        );
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Failed to play station ${station.name}: $e');
      
      // If current station fails and we're not already retrying, try next station
      if (!_isRetrying && RadioData.stations.length > 1) {
        _isRetrying = true;
        emit(RadioError('Station failed, trying next...'));
        await Future.delayed(const Duration(seconds: 1));
        await nextStation();
        _isRetrying = false;
      } else {
        emit(RadioError('All stations unavailable. Please check your connection.'));
        _currentStation = null;
      }
    }
  }

  Future<void> nextStation() async {
    const stations = RadioData.stations;
    if (stations.isEmpty) return;

    final nextIndex = (_currentStationIndex + 1) % stations.length;
    await switchToStation(nextIndex);
  }

  Future<void> previousStation() async {
    const stations = RadioData.stations;
    if (stations.isEmpty) return;

    final prevIndex = (_currentStationIndex - 1 + stations.length) % stations.length;
    await switchToStation(prevIndex);
  }

  Future<void> switchToStation(int index) async {
    const stations = RadioData.stations;
    if (index < 0 || index >= stations.length) return;

    _currentStationIndex = index;
    final station = stations[index];
    
    // Stop current playback first
    if (_currentStation != null) {
      await stop();
    }
    
    // Small delay to ensure clean stop
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Play new station
    await playStation(station);
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
        emit(RadioPlaying(station: _currentStation!, position: _audioPlayer.position));
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

  Future<void> retryCurrentStation() async {
    if (_currentStation != null) {
      await playStation(_currentStation!);
    } else {
      await playStation(defaultStation);
    }
  }

  bool get isPlaying {
    if (_audioHandler != null) {
      return _audioHandler!.playbackState.value.playing;
    }
    return _audioPlayer.playing;
  }

  RadioModel get defaultStation => RadioData.defaultStation;
  RadioModel get currentStation => _currentStation ?? defaultStation;
  List<RadioModel> get availableStations => RadioData.stations;
  int get currentStationIndex => _currentStationIndex;

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    return super.close();
  }
}