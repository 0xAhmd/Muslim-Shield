import 'package:azkar/home/data/service/dio_client.dart';

import '../models/surah.dart';

class SurahRepository {
  final _apiService = DioClient().apiService;
  final _audioApiService = DioClient().audioApiService;

  Future<List<Surah>> getSurahs() async {
    try {
      final response = await _apiService.getSurahs();
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch surahs: $e');
    }
  }

  Future<SurahDetail> getSurah(int number) async {
    try {
      final response = await _apiService.getSurah(number);
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch surah: $e');
    }
  }

  Future<SurahDetail> getSurahWithAudio(int number) async {
    try {
      final response = await _apiService.getSurahWithAudio(number);
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch surah with audio: $e');
    }
  }

  // New methods for audio support
  Future<List<Reciter>> getReciters() async {
    try {
      final reciters = await _audioApiService.getReciters();
      return reciters;
    } catch (e) {
      throw Exception('Failed to fetch reciters: $e');
    }
  }

  Future<SurahAudioResponse> getSurahAudio(
    int reciterId,
    int chapterNumber,
  ) async {
    try {
      final response = await _audioApiService.getSurahAudio(
        reciterId,
        chapterNumber,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to fetch surah audio: $e');
    }
  }
}
