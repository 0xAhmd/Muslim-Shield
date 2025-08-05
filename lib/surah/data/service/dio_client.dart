import 'package:azkar/surah/data/service/api_service.dart';
import 'package:azkar/surah/data/service/audio_api_service.dart';
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
    // Original API dio instance
    _dio = Dio();
    _dio.options = BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    );

    // Audio API dio instance
    _audioDio = Dio();
    _audioDio.options = BaseOptions(
      baseUrl: 'https://quranapi.pages.dev/api',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
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

    _apiService = ApiService(_dio);
    _audioApiService = AudioApiService(_audioDio);
  }

  ApiService get apiService => _apiService;
  AudioApiService get audioApiService => _audioApiService;
  Dio get audioDio => _audioDio; // Add this getter
}
