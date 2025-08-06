import 'package:azkar/radio/data/models/radio.dart';
import 'package:azkar/radio/data/models/radio_data.dart';
import 'package:azkar/radio/presentation/cubit/radio_state.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';

class RadioCubit extends Cubit<RadioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  RadioModel? _currentStation;

  RadioCubit() : super(RadioInitial()) {
    _setupAudioPlayerListeners();
  }

  void _setupAudioPlayerListeners() {
    _audioPlayer.playerStateStream.listen((playerState) {
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
    });

    _audioPlayer.positionStream.listen((position) {
      if (state is RadioPlaying && _currentStation != null) {
        emit(RadioPlaying(station: _currentStation!, position: position));
      }
    });
  }

  Future<void> playStation(RadioModel station) async {
    try {
      emit(RadioLoading());
      _currentStation = station;

      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(station.url)),
        preload: false,
      );

      await _audioPlayer.play();
    } catch (e) {
      emit(RadioError('Failed to play radio: ${e.toString()}'));
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      if (_currentStation != null) {
        emit(RadioPaused(station: _currentStation!));
      }
    } catch (e) {
      emit(RadioError('Failed to pause: ${e.toString()}'));
    }
  }

  Future<void> resume() async {
    try {
      await _audioPlayer.play();
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
      await _audioPlayer.stop();
      _currentStation = null;
      emit(RadioStopped());
    } catch (e) {
      emit(RadioError('Failed to stop: ${e.toString()}'));
    }
  }

  bool get isPlaying => _audioPlayer.playing;

  RadioModel get defaultStation => RadioData.defaultStation;

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    return super.close();
  }
}
