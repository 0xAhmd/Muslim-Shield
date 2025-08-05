import 'package:azkar/hizb/data/models/hizb_reponse.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'hizb_service.g.dart';

@RestApi(baseUrl: 'https://api.alquran.cloud/v1/')
abstract class HizbService {
  factory HizbService(Dio dio, {String baseUrl}) = _HizbService;

  @GET('hizb/{hizbNumber}/{edition}')
  Future<HizbResponse> getHizb(
    @Path('hizbNumber') int hizbNumber,
    @Path('edition') String edition,
  );

  @GET('hizb/{hizbNumber}/quran-uthmani')
  Future<HizbResponse> getHizbArabic(@Path('hizbNumber') int hizbNumber);
}
