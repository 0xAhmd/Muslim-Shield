import '../models/overpass_reponse.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'masjid_api_service.g.dart';

@RestApi(baseUrl: 'https://overpass-api.de/api/')
abstract class MasjidApiService {
  factory MasjidApiService(Dio dio) = _MasjidApiService;

  @POST('/interpreter')
  @FormUrlEncoded()
  Future<OverpassResponse> searchNearbyMasjids({
    @Field('data') required String query,
  });
}

class MasjidApiClient {
  late final MasjidApiService _apiService;

  MasjidApiClient() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';

    _apiService = MasjidApiService(dio);
  }

  Future<OverpassResponse> searchNearbyMasjids({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  }) async {
    // Convert km to meters for Overpass API
    final radiusInMeters = (radiusInKm * 1000).toInt();

    // Overpass QL query to find masjids/mosques
    final query =
        '''
[out:json][timeout:25];
(
  node["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusInMeters,$latitude,$longitude);
  way["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusInMeters,$latitude,$longitude);
  relation["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusInMeters,$latitude,$longitude);
);
out center meta;
''';

    return await _apiService.searchNearbyMasjids(query: query);
  }
}
