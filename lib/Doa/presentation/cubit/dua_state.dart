// Cubit
import 'package:azkar/Doa/data/dua_data.dart';
import 'package:azkar/Doa/data/dua_model.dart';
import 'package:azkar/Doa/presentation/cubit/dua_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

class DuaCubit extends Cubit<DuaState> {
  DuaCubit() : super(DuaInitial());

  void loadDuas() {
    try {
      emit(DuaLoading());

      final groupedDuas = DuasData.getDuasGroupedByCategory();
      final allDuas = DuasData.duas;

      emit(DuaLoaded(groupedDuas: groupedDuas, filteredDuas: allDuas));
    } catch (e) {
      emit(DuaError('Failed to load duas: ${e.toString()}'));
    }
  }

  void searchDuas(String query) {
    final currentState = state;
    if (currentState is DuaLoaded) {
      try {
        final filteredDuas = DuasData.searchDuas(query);

        emit(
          currentState.copyWith(
            filteredDuas: filteredDuas,
            searchQuery: query,
            selectedCategory: null, // Clear category filter when searching
          ),
        );
      } catch (e) {
        emit(DuaError('Search failed: ${e.toString()}'));
      }
    }
  }

  void filterByCategory(String? category) {
    final currentState = state;
    if (currentState is DuaLoaded) {
      try {
        List<DuaModel> filteredDuas;

        if (category == null || category.isEmpty) {
          // Show all duas
          filteredDuas = DuasData.duas;
        } else {
          // Filter by category
          filteredDuas = DuasData.getDuasByCategory(category);
        }

        emit(
          currentState.copyWith(
            filteredDuas: filteredDuas,
            selectedCategory: category,
            searchQuery: '', // Clear search when filtering by category
          ),
        );
      } catch (e) {
        emit(DuaError('Filter failed: ${e.toString()}'));
      }
    }
  }

  void clearFilters() {
    final currentState = state;
    if (currentState is DuaLoaded) {
      emit(
        currentState.copyWith(
          filteredDuas: DuasData.duas,
          searchQuery: '',
          selectedCategory: null,
        ),
      );
    }
  }

  // Get duas for a specific category (useful for category detail screens)
  List<DuaModel> getDuasForCategory(String category) {
    return DuasData.getDuasByCategory(category);
  }

  // Get all categories
  List<String> getCategories() {
    return DuasData.categories;
  }
}
