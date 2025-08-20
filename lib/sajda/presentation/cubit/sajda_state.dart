import '../../data/models/sajda_summary.dart';
import '../../data/models/sajda_ayah.dart';

// States
abstract class SajdaState {}

class SajdaInitial extends SajdaState {}

class SajdaLoading extends SajdaState {}

class SajdaLoaded extends SajdaState {
  final List<SajdaSummary> sajdaSummaries;
  final List<SajdaSummary> filteredSajdas;
  final String searchQuery;
  final bool showObligatory;
  final bool showRecommended;

  SajdaLoaded({
    required this.sajdaSummaries,
    required this.filteredSajdas,
    this.searchQuery = '',
    this.showObligatory = true,
    this.showRecommended = true,
  });

  SajdaLoaded copyWith({
    List<SajdaSummary>? sajdaSummaries,
    List<SajdaSummary>? filteredSajdas,
    String? searchQuery,
    bool? showObligatory,
    bool? showRecommended,
  }) {
    return SajdaLoaded(
      sajdaSummaries: sajdaSummaries ?? this.sajdaSummaries,
      filteredSajdas: filteredSajdas ?? this.filteredSajdas,
      searchQuery: searchQuery ?? this.searchQuery,
      showObligatory: showObligatory ?? this.showObligatory,
      showRecommended: showRecommended ?? this.showRecommended,
    );
  }
}

class SajdaError extends SajdaState {
  final String message;

  SajdaError(this.message);
}

class SajdaDetailLoading extends SajdaState {}

class SajdaDetailLoaded extends SajdaState {
  final SajdaAyah sajdaAyah;
  final List<SajdaSummary> sajdaSummaries; // Keep the list for navigation

  SajdaDetailLoaded({required this.sajdaAyah, required this.sajdaSummaries});
}

class SajdaDetailError extends SajdaState {
  final String message;
  final List<SajdaSummary> sajdaSummaries; // Keep the list for navigation

  SajdaDetailError({required this.message, required this.sajdaSummaries});
}
