import 'package:dio/dio.dart';
import 'api_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;
  late final ApiService _apiService;

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio();
    _dio.options = BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Add interceptors for logging (optional)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (o) => print(o),
    ));

    _apiService = ApiService(_dio);
  }

  ApiService get apiService => _apiService;
}