import '../models/surah.dart';
import '../../../juzz/data/models/juzz_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'http://api.alquran.cloud/v1/')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/surah')
  Future<SurahsResponse> getSurahs();

  @GET('/surah/{number}')
  Future<SurahDetailResponse> getSurah(@Path('number') int number);

  @GET('/surah/{number}/ar.alafasy')
  Future<SurahDetailResponse> getSurahWithAudio(@Path('number') int number);
 @GET('/juz/{number}')
  Future<JuzzResponse> getJuzz(@Path('number') int number);
}