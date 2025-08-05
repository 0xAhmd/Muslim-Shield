import 'package:azkar/hizb/data/models/hizb_reponse.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'hizb_service.g.dart';

@RestApi(baseUrl: 'https://api.alquran.cloud/v1/')
abstract class HizbService {
  factory HizbService(Dio dio, {String baseUrl}) = _HizbService;

  // The correct endpoint is hizbQuarter, not hizb
  // There are 240 hizb quarters (1-240), where each 4 quarters = 1 Hizb
  @GET('hizbQuarter/{hizbQuarterNumber}/{edition}')
  Future<HizbResponse> getHizbQuarter(
    @Path('hizbQuarterNumber') int hizbQuarterNumber,
    @Path('edition') String edition,
  );

  @GET('hizbQuarter/{hizbQuarterNumber}/quran-uthmani')
  Future<HizbResponse> getHizbQuarterArabic(
    @Path('hizbQuarterNumber') int hizbQuarterNumber,
  );

  // Alternative: Use Juz endpoint since 1 Hizb = 1/2 Juz
  @GET('juz/{juzNumber}/{edition}')
  Future<HizbResponse> getJuz(
    @Path('juzNumber') int juzNumber,
    @Path('edition') String edition,
  );

  @GET('juz/{juzNumber}/quran-uthmani')
  Future<HizbResponse> getJuzArabic(@Path('juzNumber') int juzNumber);
}
