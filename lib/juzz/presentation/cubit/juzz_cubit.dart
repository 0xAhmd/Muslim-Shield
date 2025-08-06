import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../surah/data/repo/surah_repo.dart';
import '../../data/models/juzz_summary.dart';
import 'juzz_state.dart';

class JuzzCubit extends Cubit<JuzzState> {
  final SurahRepository _repository;

  JuzzCubit({required SurahRepository repository})
    : _repository = repository,
      super(JuzzInitial());

  // Load all Juzz summaries
  Future<void> loadJuzzSummaries() async {
    try {
      emit(JuzzLoading());

      debugPrint('Loading Juzz summaries...');
      final juzzSummaries = await _repository.getAllJuzzSummaries();

      debugPrint('Successfully loaded ${juzzSummaries.length} Juzz summaries');
      emit(
        JuzzLoaded(juzzSummaries: juzzSummaries, filteredJuzz: juzzSummaries),
      );
    } catch (e) {
      debugPrint('Error loading Juzz summaries: $e');
      emit(JuzzError('Failed to load Juzz summaries: $e'));
    }
  }

  // Search Juzz by name, number, or contained surahs
  void searchJuzz(String query) {
    final currentState = state;
    if (currentState is JuzzLoaded) {
      final filteredJuzz = _filterJuzz(currentState.juzzSummaries, query);

      emit(
        currentState.copyWith(filteredJuzz: filteredJuzz, searchQuery: query),
      );
    }
  }

  // Clear search
  void clearSearch() {
    final currentState = state;
    if (currentState is JuzzLoaded) {
      emit(
        currentState.copyWith(
          filteredJuzz: currentState.juzzSummaries,
          searchQuery: '',
        ),
      );
    }
  }

  // Load specific Juzz details
  Future<void> loadJuzzDetails(int juzzNumber) async {
    final currentState = state;
    List<JuzzSummary> juzzSummaries = [];

    // Preserve the summaries list for navigation
    if (currentState is JuzzLoaded) {
      juzzSummaries = currentState.juzzSummaries;
    }

    try {
      emit(JuzzDetailLoading());

      debugPrint('Loading Juzz $juzzNumber details...');
      final juzz = await _repository.getJuzz(juzzNumber);

      debugPrint(
        'Successfully loaded Juzz $juzzNumber with ${juzz.totalAyahs} ayahs',
      );
      emit(JuzzDetailLoaded(juzz: juzz, juzzSummaries: juzzSummaries));
    } catch (e) {
      debugPrint('Error loading Juzz $juzzNumber: $e');
      emit(
        JuzzDetailError(
          message: 'Failed to load Juzz $juzzNumber: $e',
          juzzSummaries: juzzSummaries,
        ),
      );
    }
  }

  // Go back to Juzz list from detail view
  void backToJuzzList() {
    final currentState = state;
    List<JuzzSummary> juzzSummaries = [];

    if (currentState is JuzzDetailLoaded) {
      juzzSummaries = currentState.juzzSummaries;
    } else if (currentState is JuzzDetailError) {
      juzzSummaries = currentState.juzzSummaries;
    }

    if (juzzSummaries.isNotEmpty) {
      emit(
        JuzzLoaded(juzzSummaries: juzzSummaries, filteredJuzz: juzzSummaries),
      );
    } else {
      // Fallback: reload summaries
      loadJuzzSummaries();
    }
  }

  // Retry loading on error
  void retry() {
    final currentState = state;

    if (currentState is JuzzError) {
      loadJuzzSummaries();
    } else if (currentState is JuzzDetailError) {
      // Extract juzz number from the error message if possible
      final match = RegExp(r'Juzz (\d+)').firstMatch(currentState.message);
      if (match != null) {
        final juzzNumber = int.tryParse(match.group(1) ?? '');
        if (juzzNumber != null) {
          loadJuzzDetails(juzzNumber);
          return;
        }
      }
      // Fallback to summaries
      backToJuzzList();
    }
  }

  // Helper method to filter Juzz
  List<JuzzSummary> _filterJuzz(List<JuzzSummary> juzzList, String query) {
    if (query.isEmpty) return juzzList;

    final lowerQuery = query.toLowerCase().trim();

    return juzzList.where((juzz) {
      // Search by juzz number
      if (juzz.number.toString().contains(lowerQuery)) return true;

      // Search by juzz name
      if (juzz.name.toLowerCase().contains(lowerQuery)) return true;

      // Search by description
      if (juzz.description.toLowerCase().contains(lowerQuery)) return true;

      // Search by contained surahs
      for (int surahNumber in juzz.containedSurahs) {
        if (surahNumber.toString().contains(lowerQuery)) return true;
      }

      return false;
    }).toList();
  }

  // Load multiple Juzz for offline caching (optional)
  Future<void> loadMultipleJuzz(List<int> juzzNumbers) async {
    try {
      debugPrint('Loading multiple Juzz: $juzzNumbers');
      await _repository.getMultipleJuzz(juzzNumbers);
      debugPrint('Successfully cached ${juzzNumbers.length} Juzz sections');
    } catch (e) {
      debugPrint('Error loading multiple Juzz: $e');
      // Don't emit error state for background caching
    }
  }

  // Get current search query
  String getCurrentSearchQuery() {
    final currentState = state;
    if (currentState is JuzzLoaded) {
      return currentState.searchQuery;
    }
    return '';
  }

  // Check if currently searching
  bool get isSearching {
    final currentState = state;
    if (currentState is JuzzLoaded) {
      return currentState.searchQuery.isNotEmpty;
    }
    return false;
  }

  // Get filtered results count
  int getFilteredCount() {
    final currentState = state;
    if (currentState is JuzzLoaded) {
      return currentState.filteredJuzz.length;
    }
    return 0;
  }

  // Get total Juzz count
  int getTotalCount() {
    final currentState = state;
    if (currentState is JuzzLoaded) {
      return currentState.juzzSummaries.length;
    }
    return 30; // Standard number of Juzz in Quran
  }
}
