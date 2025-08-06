import '../../data/models/juzz.dart';
import '../../data/models/juzz_summary.dart';


// States
abstract class JuzzState {}

class JuzzInitial extends JuzzState {}

class JuzzLoading extends JuzzState {}

class JuzzLoaded extends JuzzState {
  final List<JuzzSummary> juzzSummaries;
  final List<JuzzSummary> filteredJuzz;
  final String searchQuery;

  JuzzLoaded({
    required this.juzzSummaries,
    required this.filteredJuzz,
    this.searchQuery = '',
  });

  JuzzLoaded copyWith({
    List<JuzzSummary>? juzzSummaries,
    List<JuzzSummary>? filteredJuzz,
    String? searchQuery,
  }) {
    return JuzzLoaded(
      juzzSummaries: juzzSummaries ?? this.juzzSummaries,
      filteredJuzz: filteredJuzz ?? this.filteredJuzz,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class JuzzError extends JuzzState {
  final String message;

  JuzzError(this.message);
}

class JuzzDetailLoading extends JuzzState {}

class JuzzDetailLoaded extends JuzzState {
  final Juzz juzz;
  final List<JuzzSummary> juzzSummaries; // Keep the list for navigation

  JuzzDetailLoaded({required this.juzz, required this.juzzSummaries});
}

class JuzzDetailError extends JuzzState {
  final String message;
  final List<JuzzSummary> juzzSummaries; // Keep the list for navigation

  JuzzDetailError({required this.message, required this.juzzSummaries});
}
