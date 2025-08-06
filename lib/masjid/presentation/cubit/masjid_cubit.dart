import 'package:azkar/masjid/data/models/masjid.dart';
import 'package:azkar/masjid/data/repo/masjid_repo.dart';
import 'package:azkar/masjid/data/services/url_launcher.dart';
import 'package:azkar/masjid/presentation/cubit/masjid_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MasjidStateCubit extends Cubit<MasjidState> {
  final MasjidRepository _repository;
  final UrlLauncherService _urlLauncherService;

  MasjidStateCubit({
    MasjidRepository? repository,
    UrlLauncherService? urlLauncherService,
  })  : _repository = repository ?? MasjidRepository(),
        _urlLauncherService = urlLauncherService ?? UrlLauncherService(),
        super(MasjidInitial());

  /// Load nearby masjids
  Future<void> loadNearbyMasjids() async {
    try {
      emit(MasjidLoading());

      // Get current location
      final locationResult = await _repository.getCurrentLocation();
      if (!locationResult.isSuccess) {
        emit(MasjidError(
          locationResult.errorMessage ?? 'Failed to get location',
          isLocationError: true,
        ));
        return;
      }

      // Search for nearby masjids
      final masjids = await _repository.searchNearbyMasjids(
        latitude: locationResult.latitude!,
        longitude: locationResult.longitude!,
        radiusInKm: 5.0,
        limit: 5,
      );

      emit(MasjidLoaded(
        masjids: masjids,
        userLatitude: locationResult.latitude!,
        userLongitude: locationResult.longitude!,
      ));
    } catch (e) {
      emit(MasjidError('Failed to load nearby masjids: ${e.toString()}'));
    }
  }

  /// Refresh masjids list
  Future<void> refreshMasjids() async {
    final currentState = state;
    if (currentState is! MasjidLoaded) return;

    try {
      // Set refreshing state
      emit(currentState.copyWith(isRefreshing: true));

      // Get updated location
      final locationResult = await _repository.getCurrentLocation();
      if (!locationResult.isSuccess) {
        emit(MasjidError(
          locationResult.errorMessage ?? 'Failed to get location',
          isLocationError: true,
        ));
        return;
      }

      // Search for nearby masjids
      final masjids = await _repository.searchNearbyMasjids(
        latitude: locationResult.latitude!,
        longitude: locationResult.longitude!,
        radiusInKm: 5.0,
        limit: 5,
      );

      emit(MasjidLoaded(
        masjids: masjids,
        userLatitude: locationResult.latitude!,
        userLongitude: locationResult.longitude!,
      ));
    } catch (e) {
      // Return to previous state on error
      emit(currentState.copyWith(isRefreshing: false));
    }
  }

  /// Open masjid location in Google Maps
  Future<bool> openMasjidInMaps(MasjidModel masjid) async {
    return await _urlLauncherService.openGoogleMaps(
      latitude: masjid.latitude,
      longitude: masjid.longitude,
      placeName: masjid.name,
    );
  }

  /// Get directions to masjid
  Future<bool> getDirectionsToMasjid(MasjidModel masjid) async {
    final currentState = state;
    if (currentState is! MasjidLoaded) return false;

    return await _urlLauncherService.openGoogleMapsDirections(
      destinationLatitude: masjid.latitude,
      destinationLongitude: masjid.longitude,
      originLatitude: currentState.userLatitude,
      originLongitude: currentState.userLongitude,
      destinationName: masjid.name,
    );
  }

  /// Format distance for display
  String formatDistance(double? distanceKm) {
    if (distanceKm == null) return 'Unknown distance';
    return _repository.formatDistance(distanceKm);
  }

  /// Retry loading after error
  void retry() {
    loadNearbyMasjids();
  }
}