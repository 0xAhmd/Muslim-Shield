import '../service/hadith_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/book.dart';
import '../models/hadith.dart';

class HadithRepository {
  late final HadithApiService _apiService;
  late final String _apiKey;

  HadithRepository() {
    final dio = Dio();

    // Add interceptors for better error handling
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    _apiService = HadithApiService(dio);
    _apiKey = dotenv.env['HADITH_API_KEY'] ?? '';

    if (_apiKey.isEmpty) {
      throw Exception('API key not found in environment variables');
    }
  }

  Future<List<Book>> getBooks() async {
    try {
      final response = await _apiService.getBooks(_apiKey);

      if (response.status != 200) {
        throw Exception('API Error: ${response.message}');
      }

      return response.books;
    } on DioException catch (dioError) {
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception(
            'Connection timeout. Please check your internet connection.',
          );
        case DioExceptionType.badResponse:
          final statusCode = dioError.response?.statusCode;
          if (statusCode == 401) {
            throw Exception(
              'Invalid API key. Please check your configuration.',
            );
          } else if (statusCode == 429) {
            throw Exception('Too many requests. Please try again later.');
          } else {
            throw Exception(
              'Server error ($statusCode). Please try again later.',
            );
          }
        case DioExceptionType.cancel:
          throw Exception('Request was cancelled.');
        case DioExceptionType.unknown:
          if (dioError.message?.contains('SocketException') == true) {
            throw Exception(
              'No internet connection. Please check your network.',
            );
          }
          throw Exception('Network error. Please try again.');
        default:
          throw Exception('Unexpected error occurred.');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to fetch books: ${e.toString()}');
    }
  }

  Future<HadithsResponse> getHadiths(String bookSlug, int paginate) async {
    try {
      final response = await _apiService.getHadiths(
        _apiKey,
        bookSlug,
        paginate,
      );

      if (response.status != 200) {
        throw Exception('API Error: ${response.message}');
      }

      return response;
    } on DioException catch (dioError) {
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception(
            'Connection timeout. Please check your internet connection.',
          );
        case DioExceptionType.badResponse:
          final statusCode = dioError.response?.statusCode;
          if (statusCode == 401) {
            throw Exception(
              'Invalid API key. Please check your configuration.',
            );
          } else if (statusCode == 404) {
            throw Exception('Book not found or has no hadiths.');
          } else if (statusCode == 429) {
            throw Exception('Too many requests. Please try again later.');
          } else {
            throw Exception(
              'Server error ($statusCode). Please try again later.',
            );
          }
        case DioExceptionType.cancel:
          throw Exception('Request was cancelled.');
        case DioExceptionType.unknown:
          if (dioError.message?.contains('SocketException') == true) {
            throw Exception(
              'No internet connection. Please check your network.',
            );
          }
          throw Exception('Network error. Please try again.');
        default:
          throw Exception('Unexpected error occurred.');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to fetch hadiths: ${e.toString()}');
    }
  }
}
