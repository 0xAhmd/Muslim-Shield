import 'package:azkar/hadith/data/models/book.dart';
import 'package:azkar/hadith/data/models/hadith.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';


part 'hadith_api_service.g.dart';

@RestApi(baseUrl: "https://hadithapi.com/api/")
abstract class HadithApiService {
  factory HadithApiService(Dio dio, {String baseUrl}) = _HadithApiService;

  @GET("books")
  Future<BooksResponse> getBooks(@Query("apiKey") String apiKey);

  @GET("hadiths/")
  Future<HadithsResponse> getHadiths(
    @Query("apiKey") String apiKey,
    @Query("book") String bookSlug, // Changed from int to String
    @Query("paginate") int paginate, // Changed from page to paginate
  );
}