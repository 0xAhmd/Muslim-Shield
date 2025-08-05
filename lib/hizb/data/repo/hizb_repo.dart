import 'package:azkar/hizb/data/models/hizb.dart';
import 'package:azkar/hizb/data/models/hizb_summary.dart';
import 'package:azkar/hizb/data/service/hizb_service.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HizbRepository {
  final HizbService _hizbService;
  final Map<int, Hizb> _hizbCache = {};
  List<HizbSummary>? _hizbSummariesCache;

  HizbRepository({HizbService? hizbService})
    : _hizbService = hizbService ?? HizbService(_createDio());

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

  // Get all Hizb summaries (static data)
  Future<List<HizbSummary>> getAllHizbSummaries() async {
    _hizbSummariesCache ??= HizbSummary.getAllHizbSummaries();
    return _hizbSummariesCache!;
  }

  // Get specific Hizb with caching
  Future<Hizb> getHizb(
    int hizbNumber, {
    String edition = 'quran-uthmani',
  }) async {
    // Validate Hizb number
    if (hizbNumber < 1 || hizbNumber > 60) {
      throw ArgumentError('Hizb number must be between 1 and 60');
    }

    // Check cache first
    final cacheKey = hizbNumber;
    if (_hizbCache.containsKey(cacheKey)) {
      debugPrint('Returning cached Hizb $hizbNumber');
      return _hizbCache[cacheKey]!;
    }

    try {
      debugPrint('Fetching Hizb $hizbNumber from API...');

      final response = await _hizbService.getHizb(hizbNumber, edition);

      if (response.code != 200) {
        throw Exception('API returned error code: ${response.code}');
      }

      final hizb = response.data;

      // Cache the result
      _hizbCache[cacheKey] = hizb;

      debugPrint('Successfully fetched and cached Hizb $hizbNumber');
      return hizb;
    } on DioException catch (e) {
      debugPrint('Dio error fetching Hizb $hizbNumber: ${e.message}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please try again.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Hizb $hizbNumber not found.');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Unexpected error fetching Hizb $hizbNumber: $e');
      throw Exception('Failed to load Hizb $hizbNumber: $e');
    }
  }

  // Get Arabic Hizb (convenience method)
  Future<Hizb> getHizbArabic(int hizbNumber) async {
    return getHizb(hizbNumber, edition: 'quran-uthmani');
  }

  // Get multiple Hizb sections for caching
  Future<List<Hizb>> getMultipleHizb(
    List<int> hizbNumbers, {
    String edition = 'quran-uthmani',
  }) async {
    final List<Hizb> hizbSections = [];

    for (final hizbNumber in hizbNumbers) {
      try {
        final hizb = await getHizb(hizbNumber, edition: edition);
        hizbSections.add(hizb);
      } catch (e) {
        debugPrint('Failed to load Hizb $hizbNumber: $e');
        // Continue with other Hizb sections
      }
    }

    return hizbSections;
  }

  // Clear cache
  void clearCache() {
    _hizbCache.clear();
    _hizbSummariesCache = null;
    debugPrint('Hizb cache cleared');
  }

  // Get cached Hizb count
  int getCachedHizbCount() => _hizbCache.length;

  // Check if Hizb is cached
  bool isHizbCached(int hizbNumber) => _hizbCache.containsKey(hizbNumber);

  // Preload popular Hizb sections (first few)
  Future<void> preloadPopularHizb({String edition = 'quran-uthmani'}) async {
    final popularHizbNumbers = [1, 2, 3, 4, 5]; // First 5 Hizb sections

    try {
      await getMultipleHizb(popularHizbNumbers, edition: edition);
      debugPrint(
        'Preloaded ${popularHizbNumbers.length} popular Hizb sections',
      );
    } catch (e) {
      debugPrint('Error preloading popular Hizb sections: $e');
    }
  }

  // Get Hizb by Juzz (helper method)
  List<int> getHizbNumbersByJuzz(int juzzNumber) {
    if (juzzNumber < 1 || juzzNumber > 30) {
      throw ArgumentError('Juzz number must be between 1 and 30');
    }

    // Each Juzz contains 2 Hizb sections
    final firstHizb = (juzzNumber - 1) * 2 + 1;
    final secondHizb = firstHizb + 1;

    return [firstHizb, secondHizb];
  }

  // Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cachedHizbCount': _hizbCache.length,
      'totalHizbSections': 60,
      'cacheHitRate': _hizbCache.length / 60,
      'summariesCached': _hizbSummariesCache != null,
    };
  }
}
