import 'package:azkar/home/data/models/surah.dart';
import 'package:azkar/home/data/service/dio_client.dart';

class SurahRepository {
  final _apiService = DioClient().apiService;
  final _audioApiService = DioClient().audioApiService;

  Future<List<Surah>> getSurahs() async {
    try {
      final response = await _apiService.getSurahs();
      return response.data;
    } catch (e) {
      print('Error in getSurahs: $e');
      throw Exception('Failed to fetch surahs: $e');
    }
  }

  Future<SurahDetail> getSurah(int number) async {
    try {
      final response = await _apiService.getSurah(number);
      return response.data;
    } catch (e) {
      print('Error in getSurah: $e');
      throw Exception('Failed to fetch surah: $e');
    }
  }

  Future<SurahDetail> getSurahWithAudio(int number) async {
    try {
      final response = await _apiService.getSurahWithAudio(number);
      return response.data;
    } catch (e) {
      print('Error in getSurahWithAudio: $e');
      throw Exception('Failed to fetch surah with audio: $e');
    }
  }

  // Enhanced getReciters method with better error handling
  Future<List<Reciter>> getReciters() async {
    try {
      print('Calling audioApiService.getReciters()...');
      final reciters = await _audioApiService.getReciters();
      print('Raw API response type: ${reciters.runtimeType}');
      print('Number of reciters: ${reciters.length}');

      // Add validation
      for (int i = 0; i < reciters.length && i < 3; i++) {
        print('Reciter $i: ${reciters[i].name} (ID: ${reciters[i].id})');
      }

      return reciters;
    } catch (e, stackTrace) {
      print('Error in getReciters: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to fetch reciters: $e');
    }
  }

  Future<SurahAudioResponse> getSurahAudio(
    int reciterId,
    int chapterNumber,
  ) async {
    try {
      print('Getting audio for reciter $reciterId, chapter $chapterNumber');
      final response = await _audioApiService.getSurahAudio(
        reciterId,
        chapterNumber,
      );
      print('Audio response success: ${response.success}');
      return response;
    } catch (e, stackTrace) {
      print('Error in getSurahAudio: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to fetch surah audio: $e');
    }
  }
}
