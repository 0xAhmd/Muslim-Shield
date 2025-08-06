import '../../data/repo/hizb_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/models/hizb_summary.dart';
import 'hizb_state.dart';

class HizbCubit extends Cubit<HizbState> {
  final HizbRepository _repository;

  HizbCubit({required HizbRepository repository})
    : _repository = repository,
      super(HizbInitial());

  // Load all Hizb summaries
  Future<void> loadHizbSummaries() async {
    try {
      emit(HizbLoading());

      debugPrint('Loading Hizb summaries...');
      final hizbSummaries = await _repository.getAllHizbSummaries();

      debugPrint('Successfully loaded ${hizbSummaries.length} Hizb summaries');
      emit(
        HizbLoaded(hizbSummaries: hizbSummaries, filteredHizb: hizbSummaries),
      );
    } catch (e) {
      debugPrint('Error loading Hizb summaries: $e');
      emit(HizbError('Failed to load Hizb summaries: $e'));
    }
  }

  // Search Hizb by name, number, or contained surahs/juzz
  void searchHizb(String query) {
    final currentState = state;
    if (currentState is HizbLoaded) {
      final filteredHizb = _filterHizb(currentState.hizbSummaries, query);

      emit(
        currentState.copyWith(filteredHizb: filteredHizb, searchQuery: query),
      );
    }
  }

  // Clear search
  void clearSearch() {
    final currentState = state;
    if (currentState is HizbLoaded) {
      emit(
        currentState.copyWith(
          filteredHizb: currentState.hizbSummaries,
          searchQuery: '',
        ),
      );
    }
  }

  // Load specific Hizb details
  Future<void> loadHizbDetails(int hizbNumber) async {
    final currentState = state;
    List<HizbSummary> hizbSummaries = [];

    // Preserve the summaries list for navigation
    if (currentState is HizbLoaded) {
      hizbSummaries = currentState.hizbSummaries;
    }

    try {
      emit(HizbDetailLoading());

      debugPrint('Loading Hizb $hizbNumber details...');
      final hizb = await _repository.getHizbArabic(hizbNumber);

      debugPrint(
        'Successfully loaded Hizb $hizbNumber with ${hizb.totalAyahs} ayahs',
      );
      emit(HizbDetailLoaded(hizb: hizb, hizbSummaries: hizbSummaries));
    } catch (e) {
      debugPrint('Error loading Hizb $hizbNumber: $e');
      emit(
        HizbDetailError(
          message: 'Failed to load Hizb $hizbNumber: $e',
          hizbSummaries: hizbSummaries,
        ),
      );
    }
  }

  // Go back to Hizb list from detail view
  void backToHizbList() {
    final currentState = state;
    List<HizbSummary> hizbSummaries = [];

    if (currentState is HizbDetailLoaded) {
      hizbSummaries = currentState.hizbSummaries;
    } else if (currentState is HizbDetailError) {
      hizbSummaries = currentState.hizbSummaries;
    }

    if (hizbSummaries.isNotEmpty) {
      emit(
        HizbLoaded(hizbSummaries: hizbSummaries, filteredHizb: hizbSummaries),
      );
    } else {
      // Fallback: reload summaries
      loadHizbSummaries();
    }
  }

  // Retry loading on error
  void retry() {
    final currentState = state;

    if (currentState is HizbError) {
      loadHizbSummaries();
    } else if (currentState is HizbDetailError) {
      // Extract hizb number from the error message if possible
      final match = RegExp(r'Hizb (\d+)').firstMatch(currentState.message);
      if (match != null) {
        final hizbNumber = int.tryParse(match.group(1) ?? '');
        if (hizbNumber != null) {
          loadHizbDetails(hizbNumber);
          return;
        }
      }
      // Fallback to summaries
      backToHizbList();
    }
  }

  // Helper method to filter Hizb
  List<HizbSummary> _filterHizb(List<HizbSummary> hizbList, String query) {
    if (query.isEmpty) return hizbList;

    final lowerQuery = query.toLowerCase().trim();

    return hizbList.where((hizb) {
      // Search by hizb number
      if (hizb.number.toString().contains(lowerQuery)) return true;

      // Search by hizb name
      if (hizb.name.toLowerCase().contains(lowerQuery)) return true;

      // Search by description
      if (hizb.description.toLowerCase().contains(lowerQuery)) return true;

      // Search by contained surahs
      for (int surahNumber in hizb.containedSurahs) {
        if (surahNumber.toString().contains(lowerQuery)) return true;
      }

      // Search by contained juzz
      for (int juzzNumber in hizb.containedJuzz) {
        if (juzzNumber.toString().contains(lowerQuery)) return true;
      }

      return false;
    }).toList();
  }

  // Load multiple Hizb for offline caching (optional)
  Future<void> loadMultipleHizb(List<int> hizbNumbers) async {
    try {
      debugPrint('Loading multiple Hizb: $hizbNumbers');
      await _repository.getMultipleHizb(hizbNumbers);
      debugPrint('Successfully cached ${hizbNumbers.length} Hizb sections');
    } catch (e) {
      debugPrint('Error loading multiple Hizb: $e');
      // Don't emit error state for background caching
    }
  }

  // Get current search query
  String getCurrentSearchQuery() {
    final currentState = state;
    if (currentState is HizbLoaded) {
      return currentState.searchQuery;
    }
    return '';
  }

  // Check if currently searching
  bool get isSearching {
    final currentState = state;
    if (currentState is HizbLoaded) {
      return currentState.searchQuery.isNotEmpty;
    }
    return false;
  }

  // Get filtered results count
  int getFilteredCount() {
    final currentState = state;
    if (currentState is HizbLoaded) {
      return currentState.filteredHizb.length;
    }
    return 0;
  }

  // Get total Hizb count
  int getTotalCount() {
    final currentState = state;
    if (currentState is HizbLoaded) {
      return currentState.hizbSummaries.length;
    }
    return 60; // Standard number of Hizb in Quran
  }

  // Get Hizb by Juzz number
  void filterByJuzz(int juzzNumber) {
    try {
      final hizbNumbers = _repository.getHizbNumbersByJuzz(juzzNumber);
      final hizbQuery = hizbNumbers.map((n) => n.toString()).join(' ');
      searchHizb(hizbQuery);
    } catch (e) {
      debugPrint('Error filtering by Juzz $juzzNumber: $e');
    }
  }

  // Preload popular Hizb sections
  Future<void> preloadPopularHizb() async {
    try {
      await _repository.preloadPopularHizb();
      debugPrint('Preloaded popular Hizb sections');
    } catch (e) {
      debugPrint('Error preloading popular Hizb: $e');
    }
  }

  // Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return _repository.getCacheStats();
  }

  // Clear repository cache
  void clearCache() {
    _repository.clearCache();
  }
}
