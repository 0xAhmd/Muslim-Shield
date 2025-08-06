import '../../data/repo/sajda_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/models/sajda_summary.dart';
import 'sajda_state.dart';

class SajdaCubit extends Cubit<SajdaState> {
  final SajdaRepository _repository;

  SajdaCubit({required SajdaRepository repository})
    : _repository = repository,
      super(SajdaInitial());

  // Load all sajda summaries
  Future<void> loadSajdaSummaries({String edition = 'en.asad'}) async {
    try {
      emit(SajdaLoading());

      debugPrint('Loading sajda summaries...');
      final sajdaSummaries = await _repository.getSajdaSummaries(
        edition: edition,
      );

      debugPrint(
        'Successfully loaded ${sajdaSummaries.length} sajda summaries',
      );
      emit(
        SajdaLoaded(
          sajdaSummaries: sajdaSummaries,
          filteredSajdas: sajdaSummaries,
        ),
      );
    } catch (e) {
      debugPrint('Error loading sajda summaries: $e');
      emit(SajdaError('Failed to load sajdas: $e'));
    }
  }

  // Search sajdas by text, surah name, or surah number
  void searchSajdas(String query) {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      final filteredSajdas = _filterSajdas(
        currentState.sajdaSummaries,
        query,
        currentState.showObligatory,
        currentState.showRecommended,
      );

      emit(
        currentState.copyWith(
          filteredSajdas: filteredSajdas,
          searchQuery: query,
        ),
      );
    }
  }

  // Clear search
  void clearSearch() {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      final filteredSajdas = _applyFilters(
        currentState.sajdaSummaries,
        currentState.showObligatory,
        currentState.showRecommended,
      );

      emit(
        currentState.copyWith(filteredSajdas: filteredSajdas, searchQuery: ''),
      );
    }
  }

  // Filter by sajda type (obligatory/recommended)
  void toggleObligatory() {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      final newShowObligatory = !currentState.showObligatory;
      final filteredSajdas = _filterSajdas(
        currentState.sajdaSummaries,
        currentState.searchQuery,
        newShowObligatory,
        currentState.showRecommended,
      );

      emit(
        currentState.copyWith(
          showObligatory: newShowObligatory,
          filteredSajdas: filteredSajdas,
        ),
      );
    }
  }

  void toggleRecommended() {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      final newShowRecommended = !currentState.showRecommended;
      final filteredSajdas = _filterSajdas(
        currentState.sajdaSummaries,
        currentState.searchQuery,
        currentState.showObligatory,
        newShowRecommended,
      );

      emit(
        currentState.copyWith(
          showRecommended: newShowRecommended,
          filteredSajdas: filteredSajdas,
        ),
      );
    }
  }

  // Load specific sajda details
  Future<void> loadSajdaDetails(int sajdaId) async {
    final currentState = state;
    List<SajdaSummary> sajdaSummaries = [];

    // Preserve the summaries list for navigation
    if (currentState is SajdaLoaded) {
      sajdaSummaries = currentState.sajdaSummaries;
    }

    try {
      emit(SajdaDetailLoading());

      debugPrint('Loading sajda $sajdaId details...');
      final sajdaAyah = await _repository.getSajdaById(sajdaId);

      if (sajdaAyah == null) {
        throw Exception('Sajda with ID $sajdaId not found');
      }

      debugPrint('Successfully loaded sajda $sajdaId details');
      emit(
        SajdaDetailLoaded(sajdaAyah: sajdaAyah, sajdaSummaries: sajdaSummaries),
      );
    } catch (e) {
      debugPrint('Error loading sajda $sajdaId: $e');
      emit(
        SajdaDetailError(
          message: 'Failed to load sajda $sajdaId: $e',
          sajdaSummaries: sajdaSummaries,
        ),
      );
    }
  }

  // Go back to sajda list from detail view
  void backToSajdaList() {
    final currentState = state;
    List<SajdaSummary> sajdaSummaries = [];

    if (currentState is SajdaDetailLoaded) {
      sajdaSummaries = currentState.sajdaSummaries;
    } else if (currentState is SajdaDetailError) {
      sajdaSummaries = currentState.sajdaSummaries;
    }

    if (sajdaSummaries.isNotEmpty) {
      emit(
        SajdaLoaded(
          sajdaSummaries: sajdaSummaries,
          filteredSajdas: sajdaSummaries,
        ),
      );
    } else {
      // Fallback: reload summaries
      loadSajdaSummaries();
    }
  }

  // Retry loading on error
  void retry() {
    final currentState = state;

    if (currentState is SajdaError) {
      loadSajdaSummaries();
    } else if (currentState is SajdaDetailError) {
      // Extract sajda ID from the error message if possible
      final match = RegExp(r'sajda (\d+)').firstMatch(currentState.message);
      if (match != null) {
        final sajdaId = int.tryParse(match.group(1) ?? '');
        if (sajdaId != null) {
          loadSajdaDetails(sajdaId);
          return;
        }
      }
      // Fallback to summaries
      backToSajdaList();
    }
  }

  // Helper method to filter sajdas
  List<SajdaSummary> _filterSajdas(
    List<SajdaSummary> sajdaList,
    String query,
    bool showObligatory,
    bool showRecommended,
  ) {
    // First apply type filters
    var filtered = _applyFilters(sajdaList, showObligatory, showRecommended);

    if (query.isEmpty) return filtered;

    final lowerQuery = query.toLowerCase().trim();

    return filtered.where((sajda) {
      // Search by sajda ID
      if (sajda.id.toString().contains(lowerQuery)) return true;

      // Search by surah name (English)
      if (sajda.surahName.toLowerCase().contains(lowerQuery)) return true;

      // Search by surah name (Arabic)
      if (sajda.surahArabicName.contains(query)) return true;

      // Search by surah number
      if (sajda.surahNumber.toString().contains(lowerQuery)) return true;

      // Search by ayah number
      if (sajda.ayahNumber.toString().contains(lowerQuery)) return true;

      // Search by juz number
      if (sajda.juz.toString().contains(lowerQuery)) return true;

      // Search by page number
      if (sajda.page.toString().contains(lowerQuery)) return true;

      // Search by sajda type
      if (sajda.sajdaType.toLowerCase().contains(lowerQuery)) return true;

      // Search in ayah text
      if (sajda.ayahText.toLowerCase().contains(lowerQuery)) return true;

      // Search by reference
      if (sajda.reference.toLowerCase().contains(lowerQuery)) return true;

      return false;
    }).toList();
  }

  // Helper method to apply type filters
  List<SajdaSummary> _applyFilters(
    List<SajdaSummary> sajdaList,
    bool showObligatory,
    bool showRecommended,
  ) {
    return sajdaList.where((sajda) {
      if (showObligatory && sajda.isObligatory) return true;
      if (showRecommended && sajda.isRecommended) return true;
      return false;
    }).toList();
  }

  // Get current search query
  String getCurrentSearchQuery() {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      return currentState.searchQuery;
    }
    return '';
  }

  // Check if currently searching
  bool get isSearching {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      return currentState.searchQuery.isNotEmpty;
    }
    return false;
  }

  // Get filtered results count
  int getFilteredCount() {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      return currentState.filteredSajdas.length;
    }
    return 0;
  }

  // Get total sajda count
  int getTotalCount() {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      return currentState.sajdaSummaries.length;
    }
    return 15; // Standard number of sajdas in Quran
  }

  // Get obligatory count
  int getObligatoryCount() {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      return currentState.sajdaSummaries.where((s) => s.isObligatory).length;
    }
    return 0;
  }

  // Get recommended count
  int getRecommendedCount() {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      return currentState.sajdaSummaries.where((s) => s.isRecommended).length;
    }
    return 0;
  }

  // Filter by surah number
  void filterBySurah(int surahNumber) {
    searchSajdas(surahNumber.toString());
  }

  // Filter by juz number
  void filterByJuz(int juzNumber) {
    searchSajdas('juz $juzNumber');
  }

  // Preload sajdas
  Future<void> preloadSajdas() async {
    try {
      await _repository.preloadSajdas();
      debugPrint('Preloaded sajdas');
    } catch (e) {
      debugPrint('Error preloading sajdas: $e');
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

  // Get filter status
  bool get showingObligatory {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      return currentState.showObligatory;
    }
    return true;
  }

  bool get showingRecommended {
    final currentState = state;
    if (currentState is SajdaLoaded) {
      return currentState.showRecommended;
    }
    return true;
  }
}
