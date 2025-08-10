import 'api_service.dart';
import 'audio_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;
  late final Dio _audioDio;
  late final ApiService _apiService;
  late final AudioApiService _audioApiService;

  factory DioClient() => _instance;

  DioClient._internal() {
    // Original API dio instance with fixed headers
    _dio = Dio();
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      // Use browser-like headers that work with the API
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      },
      // Remove Content-Type from default headers since it's causing issues
    );

    // Audio API dio instance
    _audioDio = Dio();
    _audioDio.options = BaseOptions(
      baseUrl: 'https://quranapi.pages.dev/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': '*/*',
      },
    );

    // Add interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint('[MAIN API] $o'),
      ),
    );

    _audioDio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint('[AUDIO API] $o'),
      ),
    );

    // Add request interceptor to ensure headers are applied correctly
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('🚀 [MAIN API REQUEST] ${options.method} ${options.uri}');
          debugPrint('   Headers: ${options.headers}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            '✅ [MAIN API SUCCESS] ${response.requestOptions.method} ${response.requestOptions.uri}',
          );
          debugPrint('   Status: ${response.statusCode}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint(
            '❌ [MAIN API ERROR] ${error.requestOptions.method} ${error.requestOptions.uri}',
          );
          debugPrint('   Type: ${error.type}');
          debugPrint('   Status: ${error.response?.statusCode}');
          debugPrint('   Message: ${error.message}');
          if (error.response?.data != null) {
            debugPrint('   Error Response: ${error.response?.data}');
          }
          handler.next(error);
        },
      ),
    );

    _apiService = ApiService(_dio);
    _audioApiService = AudioApiService(_audioDio);
  }

  ApiService get apiService => _apiService;
  AudioApiService get audioApiService => _audioApiService;
  Dio get audioDio => _audioDio;
}
