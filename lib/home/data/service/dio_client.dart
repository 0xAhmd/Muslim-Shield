import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'audio_api_service.dart';

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

    // Add interceptors for logging (optional)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );

    _audioDio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );

    _apiService = ApiService(_dio);
    _audioApiService = AudioApiService(_audioDio);
  }

  ApiService get apiService => _apiService;
  AudioApiService get audioApiService => _audioApiService;
}
