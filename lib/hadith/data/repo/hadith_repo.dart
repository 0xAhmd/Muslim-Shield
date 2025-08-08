import 'package:azkar/hadith/data/service/hadith_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/book.dart';
import '../models/hadith.dart';

class HadithRepository {
  late final HadithApiService _apiService;
  late final String _apiKey;

  HadithRepository() {
    final dio = Dio();
    _apiService = HadithApiService(dio);
    _apiKey = dotenv.env['HADITH_API_KEY'] ?? '';
  }

  Future<List<Book>> getBooks() async {
    try {
      final response = await _apiService.getBooks(_apiKey);
      return response.books;
    } catch (e) {
      throw Exception('Failed to fetch books: $e');
    }
  }

  Future<HadithsResponse> getHadiths(int bookId, int page) async {
    try {
      final response = await _apiService.getHadiths(_apiKey, bookId, page);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch hadiths: $e');
    }
  }
}