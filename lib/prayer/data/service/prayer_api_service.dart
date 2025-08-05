import 'package:azkar/prayer/data/models/prayer_time.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';

part 'prayer_api_service.g.dart';

@RestApi(baseUrl: 'https://api.aladhan.com/v1/')
abstract class PrayerApiService {
  factory PrayerApiService(Dio dio) = _PrayerApiService;

  @GET('/timings')
  Future<PrayerTimesResponse> getPrayerTimes(
    @Query('latitude') double latitude,
    @Query('longitude') double longitude,
    @Query('method') int method,
  );

  @GET('/timings/{timestamp}')
  Future<PrayerTimesResponse> getPrayerTimesForDate(
    @Path('timestamp') int timestamp,
    @Query('latitude') double latitude,
    @Query('longitude') double longitude,
    @Query('method') int method,
  );
}

// Service factory
class PrayerApiServiceFactory {
  static PrayerApiService create() {
    final dio = Dio();

    // Add interceptors for debugging
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          // Only log in debug mode
          // ignore: avoid_print
          debugPrint(object.toString());
        },
      ),
    );

    return PrayerApiService(dio);
  }
}
