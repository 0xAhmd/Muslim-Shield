import '../models/muslim_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';

part 'events_api_service.g.dart';

@RestApi(baseUrl: 'https://api.islamicfinder.us/v1/')
abstract class EventsApiService {
  factory EventsApiService(Dio dio) = _EventsApiService;

  @GET('/calendar/events')
  Future<List<MuslimEvent>> getIslamicEvents(
    @Query('year') int year,
    @Query('month') int month,
  );
}

class EventsApiServiceFactory {
  static EventsApiService create() {
    final dio = Dio();

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          debugPrint('API LOG: $object');
        },
      ),
    );

    return EventsApiService(dio);
  }
}
