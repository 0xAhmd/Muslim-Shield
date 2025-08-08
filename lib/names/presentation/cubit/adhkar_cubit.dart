import 'package:azkar/names/data/repo/adhkar_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/adhkar.dart';

part 'adhkar_state.dart';

class AdhkarCubit extends Cubit<AdhkarState> {
  final AdhkarRepository _repository;

  AdhkarCubit(this._repository) : super(AdhkarInitial()) {
    loadAdhkar();
  }

  void loadAdhkar() {
    emit(AdhkarLoading());
    try {
      final morningAdhkar = _repository.getMorningAdhkar();
      final eveningAdhkar = _repository.getEveningAdhkar();

      emit(
        AdhkarLoaded(
          morningAdhkar: morningAdhkar,
          eveningAdhkar: eveningAdhkar,
          filteredMorningAdhkar: morningAdhkar,
          filteredEveningAdhkar: eveningAdhkar,
        ),
      );
    } catch (e) {
      emit(AdhkarError(message: 'Failed to load adhkar: ${e.toString()}'));
    }
  }

  void searchAdhkar(String query, AdhkarType type) {
    final currentState = state;
    if (currentState is AdhkarLoaded) {
      emit(AdhkarLoading());
      try {
        if (type == AdhkarType.morning) {
          final filtered = _repository.searchAdhkar(
            currentState.morningAdhkar,
            query,
          );
          emit(
            currentState.copyWith(
              filteredMorningAdhkar: filtered,
              searchQuery: query,
            ),
          );
        } else {
          final filtered = _repository.searchAdhkar(
            currentState.eveningAdhkar,
            query,
          );
          emit(
            currentState.copyWith(
              filteredEveningAdhkar: filtered,
              searchQuery: query,
            ),
          );
        }
      } catch (e) {
        emit(AdhkarError(message: 'Search failed: ${e.toString()}'));
      }
    }
  }

  void clearSearch() {
    final currentState = state;
    if (currentState is AdhkarLoaded) {
      emit(
        currentState.copyWith(
          filteredMorningAdhkar: currentState.morningAdhkar,
          filteredEveningAdhkar: currentState.eveningAdhkar,
          searchQuery: '',
        ),
      );
    }
  }
}
