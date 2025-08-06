import '../models/hizb.dart';
import '../models/hizb_ayah.dart';
import '../models/hizb_summary.dart';
import '../service/hizb_service.dart';

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
  // Since there's no direct Hizb endpoint, we'll use Juz and split it
  Future<Hizb> getHizb(
    int hizbNumber, {
    String edition = 'quran-uthmani',
  }) async {
    // Validate Hizb number (1-60, since 30 Juz × 2 Hizb per Juz = 60 Hizb)
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

      // Calculate which Juz this Hizb belongs to
      final juzNumber = ((hizbNumber - 1) ~/ 2) + 1;
      final isFirstHalf = hizbNumber % 2 == 1;

      debugPrint(
        'Hizb $hizbNumber is ${isFirstHalf ? "first" : "second"} half of Juz $juzNumber',
      );

      final response = await _hizbService.getJuz(juzNumber, edition);

      if (response.code != 200) {
        throw Exception('API returned error code: ${response.code}');
      }

      final juzData = response.data;

      // Split the Juz data into two halves to get the specific Hizb
      final halfPoint = juzData.ayahs.length ~/ 2;
      final List<HizbAyah> hizbAyahs;

      if (isFirstHalf) {
        hizbAyahs = juzData.ayahs.sublist(0, halfPoint);
      } else {
        hizbAyahs = juzData.ayahs.sublist(halfPoint);
      }

      // Create Hizb object
      final hizb = Hizb(number: hizbNumber, ayahs: hizbAyahs);

      // Cache the result
      _hizbCache[cacheKey] = hizb;

      debugPrint(
        'Successfully fetched and cached Hizb $hizbNumber with ${hizb.totalAyahs} ayahs',
      );
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

  // Alternative method using HizbQuarter endpoint (more accurate)
  Future<Hizb> getHizbUsingQuarters(
    int hizbNumber, {
    String edition = 'quran-uthmani',
  }) async {
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
      debugPrint('Fetching Hizb $hizbNumber using quarters from API...');

      // Each Hizb consists of 4 quarters
      // Hizb 1 = Quarters 1,2,3,4
      // Hizb 2 = Quarters 5,6,7,8, etc.
      final startQuarter = (hizbNumber - 1) * 4 + 1;
      final endQuarter = hizbNumber * 4;

      debugPrint(
        'Fetching quarters $startQuarter to $endQuarter for Hizb $hizbNumber',
      );

      List<HizbAyah> allAyahs = [];

      // Fetch all 4 quarters for this Hizb
      for (int quarter = startQuarter; quarter <= endQuarter; quarter++) {
        try {
          final response = await _hizbService.getHizbQuarter(quarter, edition);
          if (response.code == 200) {
            allAyahs.addAll(response.data.ayahs);
          }
        } catch (e) {
          debugPrint('Error fetching quarter $quarter: $e');
        }
      }

      if (allAyahs.isEmpty) {
        throw Exception('No ayahs found for Hizb $hizbNumber');
      }

      // Create Hizb object
      final hizb = Hizb(number: hizbNumber, ayahs: allAyahs);

      // Cache the result
      _hizbCache[cacheKey] = hizb;

      debugPrint(
        'Successfully fetched and cached Hizb $hizbNumber with ${hizb.totalAyahs} ayahs',
      );
      return hizb;
    } catch (e) {
      debugPrint('Error fetching Hizb $hizbNumber using quarters: $e');
      // Fallback to Juz method
      return getHizb(hizbNumber, edition: edition);
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
