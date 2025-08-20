import '../../data/models/names.dart';
import '../../data/repo/allah_names_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'allah_names_state.dart';

class AllahNamesCubit extends Cubit<AllahNamesState> {
  final AllahNamesRepository _repository;

  AllahNamesCubit(this._repository) : super(AllahNamesInitial()) {
    loadNames();
  }

  void loadNames() {
    emit(AllahNamesLoading());
    try {
      final names = _repository.getAllNames();
      emit(AllahNamesLoaded(names: names, filteredNames: names));
    } catch (e) {
      emit(AllahNamesError(message: 'Failed to load names: ${e.toString()}'));
    }
  }

  void searchNames(String query) {
    final currentState = state;
    if (currentState is AllahNamesLoaded) {
      emit(AllahNamesLoading());
      try {
        final filteredNames = _repository.searchNames(query);
        emit(
          currentState.copyWith(
            filteredNames: filteredNames,
            searchQuery: query,
          ),
        );
      } catch (e) {
        emit(AllahNamesError(message: 'Search failed: ${e.toString()}'));
      }
    }
  }

  void clearSearch() {
    final currentState = state;
    if (currentState is AllahNamesLoaded) {
      emit(
        currentState.copyWith(
          filteredNames: currentState.names,
          searchQuery: '',
        ),
      );
    }
  }
}
