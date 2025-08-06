import 'package:azkar/sajda/data/models/sajda_reponse.dart';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'sajda_service.g.dart';

@RestApi(baseUrl: 'https://api.alquran.cloud/v1/')
abstract class SajdaService {
  factory SajdaService(Dio dio, {String baseUrl}) = _SajdaService;

  // Get all sajdas with specific edition (translation)
  @GET('sajda/{edition}')
  Future<SajdaResponse> getSajdas(@Path('edition') String edition);

  // Get sajdas with default Arabic edition
  @GET('sajda/quran-uthmani')
  Future<SajdaResponse> getSajdasArabic();

  // Get sajdas with English translation (Muhammad Asad)
  @GET('sajda/en.asad')
  Future<SajdaResponse> getSajdasEnglish();

  // Get sajdas with specific translation
  @GET('sajda/en.pickthall')
  Future<SajdaResponse> getSajdasPickthall();

  @GET('sajda/en.sahih')
  Future<SajdaResponse> getSajdasSahih();

  @GET('sajda/en.yusufali')
  Future<SajdaResponse> getSajdasYusufAli();
}