// Cubit
import 'package:azkar/prayer/data/repo/prayer_repo.dart';
import 'package:azkar/prayer/presentation/cubit/prayer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerRepository _repository;

  PrayerTimesCubit(this._repository) : super(PrayerTimesInitial());

  Future<void> fetchPrayerTimes() async {
    try {
      emit(PrayerTimesLoading());

      // Get current location
      final location = await _repository.getCurrentLocation();

      // Fetch prayer times
      final prayerTimes = await _repository.getPrayerTimes(
        location.latitude,
        location.longitude,
      );

      // Get today's prayers list
      final prayersList = await _repository.getTodayPrayersList(
        prayerTimes.data.timings,
      );

      // Get next prayer
      final nextPrayer = await _repository.getNextPrayer(
        prayerTimes.data.timings,
      );

      emit(
        PrayerTimesLoaded(
          prayerTimes: prayerTimes,
          location: location,
          prayersList: prayersList,
          nextPrayer: nextPrayer,
        ),
      );
      
    } catch (e) {
      emit(PrayerTimesError(e.toString()));
    }
  }

  Future<void> refreshPrayerTimes() async {
    await fetchPrayerTimes();
  }
}

// Location Cubit (separate for reusability)
class LocationCubit extends Cubit<LocationState> {
  final PrayerRepository _repository;

  LocationCubit(this._repository) : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    try {
      emit(LocationLoading());
      final location = await _repository.getCurrentLocation();
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
