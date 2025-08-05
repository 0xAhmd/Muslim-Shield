import 'package:azkar/surah/data/models/surah.dart';

class AyahManager {
  List<AudioAyah>? _currentAyahs;
  int _currentAyah = 0;

  int get currentAyah => _currentAyah;

  void setSurahAudio(List<AudioAyah> ayahs) {
    _currentAyahs = ayahs;
    _currentAyah = 0;
  }

  void setCurrentAyah(int index) {
    _currentAyah = index;
  }

  bool isValidIndex(int index) {
    return _currentAyahs != null && index >= 0 && index < _currentAyahs!.length;
  }

  String getCurrentAyahUrl() {
    if (_currentAyahs == null) throw Exception('No ayahs loaded');
    return _currentAyahs![_currentAyah].url;
  }

  int? getNextAyahIndex() {
    if (_currentAyahs == null) return null;
    final nextIndex = _currentAyah + 1;
    return nextIndex < _currentAyahs!.length ? nextIndex : null;
  }

  int? getPreviousAyahIndex() {
    if (_currentAyahs == null) return null;
    final prevIndex = _currentAyah - 1;
    return prevIndex >= 0 ? prevIndex : null;
  }
}
