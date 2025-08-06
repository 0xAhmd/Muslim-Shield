import '../models/surah.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'audio_api_service.g.dart';

@RestApi(baseUrl: 'https://quranapi.pages.dev/api/')
abstract class AudioApiService {
  factory AudioApiService(Dio dio, {String baseUrl}) = _AudioApiService;

  @GET('/reciters.json')
  Future<Map<String, String>> getRecitersRaw();

  @GET('/{reciterId}/{chapterNumber}.json')
  Future<SurahAudioResponse> getSurahAudio(
    @Path('reciterId') int reciterId,
    @Path('chapterNumber') int chapterNumber,
  );
}
