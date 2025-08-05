// lib/hizb/presentation/cubit/hizb_state.dart
import 'package:azkar/hizb/data/models/hizb.dart';
import 'package:azkar/hizb/data/models/hizb_summary.dart';

// States
abstract class HizbState {}

class HizbInitial extends HizbState {}

class HizbLoading extends HizbState {}

class HizbLoaded extends HizbState {
  final List<HizbSummary> hizbSummaries;
  final List<HizbSummary> filteredHizb;
  final String searchQuery;

  HizbLoaded({
    required this.hizbSummaries,
    required this.filteredHizb,
    this.searchQuery = '',
  });

  HizbLoaded copyWith({
    List<HizbSummary>? hizbSummaries,
    List<HizbSummary>? filteredHizb,
    String? searchQuery,
  }) {
    return HizbLoaded(
      hizbSummaries: hizbSummaries ?? this.hizbSummaries,
      filteredHizb: filteredHizb ?? this.filteredHizb,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HizbError extends HizbState {
  final String message;

  HizbError(this.message);
}

class HizbDetailLoading extends HizbState {}

class HizbDetailLoaded extends HizbState {
  final Hizb hizb;
  final List<HizbSummary> hizbSummaries; // Keep the list for navigation

  HizbDetailLoaded({required this.hizb, required this.hizbSummaries});
}

class HizbDetailError extends HizbState {
  final String message;
  final List<HizbSummary> hizbSummaries; // Keep the list for navigation

  HizbDetailError({required this.message, required this.hizbSummaries});
}

