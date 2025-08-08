import '../services/sajda_service.dart';

import '../models/sajda.dart';
import '../models/sajda_ayah.dart';
import '../models/sajda_summary.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SajdaRepository {
  final SajdaService _sajdaService;
  Sajda? _sajdaCache;
  List<SajdaSummary>? _sajdaSummariesCache;

  SajdaRepository({SajdaService? sajdaService})
      : _sajdaService = sajdaService ?? SajdaService(_createDio());

  static Dio _createDio() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add logging interceptor for debugging
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => debugPrint(object.toString()),
      ),
    );

    return dio;
  }

  // Get all sajdas with caching
  Future<Sajda> getAllSajdas({String edition = 'en.asad'}) async {
    // Check cache first
    if (_sajdaCache != null) {
      debugPrint('Returning cached sajdas');
      return _sajdaCache!;
    }

    try {
      debugPrint('Fetching sajdas from API with edition: $edition');

      final response = await _sajdaService.getSajdas(edition);

      if (response.code != 200) {
        throw Exception('API returned error code: ${response.code}');
      }

      final sajdaData = response.data;

      // Cache the result
      _sajdaCache = sajdaData;

      debugPrint(
        'Successfully fetched and cached ${sajdaData.totalSajdas} sajdas',
      );
      return sajdaData;
    } on DioException catch (e) {
      debugPrint('Dio error fetching sajdas: ${e.message}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please try again.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Sajdas not found for edition: $edition');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Unexpected error fetching sajdas: $e');
      throw Exception('Failed to load sajdas: $e');
    }
  }

  // Get Arabic sajdas (convenience method)
  Future<Sajda> getSajdasArabic() async {
    return getAllSajdas(edition: 'quran-uthmani');
  }

  // Get English sajdas (convenience method)
  Future<Sajda> getSajdasEnglish() async {
    return getAllSajdas(edition: 'en.asad');
  }

  // Get sajda summaries for list view
  Future<List<SajdaSummary>> getSajdaSummaries({
    String edition = 'en.asad'
  }) async {
    // Check cache first
    if (_sajdaSummariesCache != null) {
      debugPrint('Returning cached sajda summaries');
      return _sajdaSummariesCache!;
    }

    try {
      final sajdaData = await getAllSajdas(edition: edition);
      
      final summaries = sajdaData.ayahs
          .map((ayah) => SajdaSummary.fromSajdaAyah(ayah))
          .toList();

      // Cache the summaries
      _sajdaSummariesCache = summaries;

      debugPrint('Successfully created ${summaries.length} sajda summaries');
      return summaries;
    } catch (e) {
      debugPrint('Error creating sajda summaries: $e');
      rethrow;
    }
  }

  // Get specific sajda by ID
  Future<SajdaAyah?> getSajdaById(int sajdaId) async {
    try {
      final sajdaData = await getAllSajdas();
      return sajdaData.ayahs.firstWhere(
        (ayah) => ayah.sajda.id == sajdaId,
      );
    } catch (e) {
      debugPrint('Sajda with ID $sajdaId not found: $e');
      return null;
    }
  }

  // Get obligatory sajdas only
  Future<List<SajdaAyah>> getObligatorySajdas({
    String edition = 'en.asad'
  }) async {
    final sajdaData = await getAllSajdas(edition: edition);
    return sajdaData.obligatorySajdas;
  }

  // Get recommended sajdas only
  Future<List<SajdaAyah>> getRecommendedSajdas({
    String edition = 'en.asad'
  }) async {
    final sajdaData = await getAllSajdas(edition: edition);
    return sajdaData.recommendedSajdas;
  }

  // Get sajdas by surah number
  Future<List<SajdaAyah>> getSajdasBySurah(
    int surahNumber, {
    String edition = 'en.asad'
  }) async {
    final sajdaData = await getAllSajdas(edition: edition);
    return sajdaData.ayahs
        .where((ayah) => ayah.surah.number == surahNumber)
        .toList();
  }

  // Get sajdas by Juz number
  Future<List<SajdaAyah>> getSajdasByJuz(
    int juzNumber, {
    String edition = 'en.asad'
  }) async {
    final sajdaData = await getAllSajdas(edition: edition);
    return sajdaData.ayahs
        .where((ayah) => ayah.juz == juzNumber)
        .toList();
  }

  // Clear cache
  void clearCache() {
    _sajdaCache = null;
    _sajdaSummariesCache = null;
    debugPrint('Sajda cache cleared');
  }

  // Check if sajdas are cached
  bool isCached() => _sajdaCache != null;

  // Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'sajdasCached': _sajdaCache != null,
      'summariesCached': _sajdaSummariesCache != null,
      'totalSajdas': _sajdaCache?.totalSajdas ?? 0,
      'obligatorySajdas': _sajdaCache?.obligatorySajdas.length ?? 0,
      'recommendedSajdas': _sajdaCache?.recommendedSajdas.length ?? 0,
    };
  }

  // Preload sajdas for faster access
  Future<void> preloadSajdas({String edition = 'en.asad'}) async {
    try {
      await getAllSajdas(edition: edition);
      await getSajdaSummaries(edition: edition);
      debugPrint('Preloaded sajdas successfully');
    } catch (e) {
      debugPrint('Error preloading sajdas: $e');
    }
  }

  // Filter sajdas by type (obligatory/recommended)
  List<SajdaSummary> filterSajdasByType(
    List<SajdaSummary> sajdas,
    bool showObligatory,
    bool showRecommended,
  ) {
    return sajdas.where((sajda) {
      if (showObligatory && sajda.isObligatory) return true;
      if (showRecommended && sajda.isRecommended) return true;
      return false;
    }).toList();
  }
}