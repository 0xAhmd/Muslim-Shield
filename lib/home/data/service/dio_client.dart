import 'package:azkar/home/data/service/api_service.dart';
import 'package:azkar/home/data/service/audio_api_service.dart';
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
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    );

    // Add detailed interceptors for debugging
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

    // Add response interceptor to debug the actual response structure
    _audioDio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          debugPrint('[AUDIO API RESPONSE] Status: ${response.statusCode}');
          debugPrint(
            '[AUDIO API RESPONSE] Data type: ${response.data.runtimeType}',
          );
          if (response.data is List) {
            debugPrint(
              '[AUDIO API RESPONSE] List length: ${(response.data as List).length}',
            );
          } else if (response.data is Map) {
            debugPrint(
              '[AUDIO API RESPONSE] Map keys: ${(response.data as Map).keys}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('[AUDIO API ERROR] ${error.message}');
          debugPrint('[AUDIO API ERROR] Response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );

    _apiService = ApiService(_dio);
    _audioApiService = AudioApiService(_audioDio);
  }

  ApiService get apiService => _apiService;
  AudioApiService get audioApiService => _audioApiService;
}
