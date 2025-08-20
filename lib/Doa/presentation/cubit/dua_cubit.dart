import '../../data/dua_model.dart';

// States
abstract class DuaState {}

class DuaInitial extends DuaState {}

class DuaLoading extends DuaState {}

class DuaLoaded extends DuaState {
  final Map<String, List<DuaModel>> groupedDuas;
  final List<DuaModel> filteredDuas;
  final String searchQuery;
  final String? selectedCategory;

  DuaLoaded({
    required this.groupedDuas,
    required this.filteredDuas,
    this.searchQuery = '',
    this.selectedCategory,
  });

  DuaLoaded copyWith({
    Map<String, List<DuaModel>>? groupedDuas,
    List<DuaModel>? filteredDuas,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return DuaLoaded(
      groupedDuas: groupedDuas ?? this.groupedDuas,
      filteredDuas: filteredDuas ?? this.filteredDuas,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class DuaError extends DuaState {
  final String message;
  DuaError(this.message);
}
