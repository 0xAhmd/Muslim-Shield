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

  // Updated getReciters method to handle the correct API response
  Future<List<Reciter>> getReciters() async {
    try {
      print('Calling audioApiService.getRecitersRaw()...');
      final Map<String, String> reciterMap = await _audioApiService
          .getRecitersRaw();
      print('Raw API response: $reciterMap');

      final List<Reciter> reciters = [];

      reciterMap.forEach((id, name) {
        try {
          final reciter = Reciter.fromApiResponse(id, name);
          reciters.add(reciter);
          print('Added reciter: ${reciter.name} (ID: ${reciter.id})');
        } catch (e) {
          print('Error parsing reciter ID $id, name $name: $e');
        }
      });

      // Sort by ID for consistent ordering
      reciters.sort((a, b) => a.id.compareTo(b.id));

      print('Successfully loaded ${reciters.length} reciters');
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
