import '../../data/models/masjid.dart';


// States
abstract class MasjidState {}

class MasjidInitial extends MasjidState {}

class MasjidLoading extends MasjidState {}

class MasjidLocationLoading extends MasjidState {}

class MasjidLoaded extends MasjidState {
  final List<MasjidModel> masjids;
  final double userLatitude;
  final double userLongitude;
  final bool isRefreshing;

  MasjidLoaded({
    required this.masjids,
    required this.userLatitude,
    required this.userLongitude,
    this.isRefreshing = false,
  });

  MasjidLoaded copyWith({
    List<MasjidModel>? masjids,
    double? userLatitude,
    double? userLongitude,
    bool? isRefreshing,
  }) {
    return MasjidLoaded(
      masjids: masjids ?? this.masjids,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class MasjidError extends MasjidState {
  final String message;
  final bool isLocationError;

  MasjidError(this.message, {this.isLocationError = false});
}