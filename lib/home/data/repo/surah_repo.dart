import 'package:azkar/home/data/service/dio_client.dart';

import '../models/surah.dart';

class SurahRepository {
  final _apiService = DioClient().apiService;

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
}
