import '../../data/models/radio.dart';

// States
abstract class RadioState {}

class RadioInitial extends RadioState {}

class RadioLoading extends RadioState {}

class RadioPlaying extends RadioState {
  final RadioModel station;
  final Duration position;

  RadioPlaying({required this.station, required this.position});
}

class RadioPaused extends RadioState {
  final RadioModel station;

  RadioPaused({required this.station});
}

class RadioStopped extends RadioState {}

class RadioError extends RadioState {
  final String message;

  RadioError(this.message);
}

class RadioBuffering extends RadioState {
  final RadioModel station;

  RadioBuffering({required this.station});
}
