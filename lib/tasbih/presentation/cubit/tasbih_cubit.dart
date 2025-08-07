import 'package:azkar/tasbih/data/repo/tasbih_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'tasbih_state.dart';

class TasbihCubit extends Cubit<TasbihState> {
  final TasbihRepository _repository;

  TasbihCubit(this._repository) : super(TasbihInitial());

  Future<void> initializeTasbih() async {
    emit(TasbihLoading());
    try {
      await _repository.initialize();
      final tasbihList = _repository.getAllTasbih();
      if (tasbihList.isNotEmpty) {
        emit(TasbihLoaded(
          tasbihList: tasbihList,
          selectedTasbih: tasbihList.first,
        ));
      }
    } catch (e) {
      emit(TasbihError('Failed to initialize tasbih: ${e.toString()}'));
    }
  }

  void selectTasbih(String id) {
    final currentState = state;
    if (currentState is TasbihLoaded) {
      final selectedTasbih = currentState.tasbihList
          .firstWhere((tasbih) => tasbih.id == id);
      emit(currentState.copyWith(
        selectedTasbih: selectedTasbih,
        isCompleted: selectedTasbih.currentCount >= selectedTasbih.targetCount,
      ));
    }
  }

  Future<void> incrementCount() async {
    final currentState = state;
    if (currentState is TasbihLoaded && currentState.selectedTasbih != null) {
      try {
        // Haptic feedback
        HapticFeedback.mediumImpact();
        
        await _repository.incrementCount(currentState.selectedTasbih!.id);
        await _refreshCurrentState();
      } catch (e) {
        emit(TasbihError('Failed to increment count: ${e.toString()}'));
      }
    }
  }

  Future<void> resetCount() async {
    final currentState = state;
    if (currentState is TasbihLoaded && currentState.selectedTasbih != null) {
      try {
        await _repository.resetCount(currentState.selectedTasbih!.id);
        await _refreshCurrentState();
      } catch (e) {
        emit(TasbihError('Failed to reset count: ${e.toString()}'));
      }
    }
  }

  Future<void> resetAllCounts() async {
    try {
      await _repository.resetAllCounts();
      await _refreshCurrentState();
    } catch (e) {
      emit(TasbihError('Failed to reset all counts: ${e.toString()}'));
    }
  }

  Future<void> _refreshCurrentState() async {
    final currentState = state;
    if (currentState is TasbihLoaded) {
      final tasbihList = _repository.getAllTasbih();
      final updatedSelectedTasbih = currentState.selectedTasbih != null
          ? _repository.getTasbihById(currentState.selectedTasbih!.id)
          : null;
      
      emit(currentState.copyWith(
        tasbihList: tasbihList,
        selectedTasbih: updatedSelectedTasbih,
        isCompleted: updatedSelectedTasbih != null && 
                    updatedSelectedTasbih.currentCount >= updatedSelectedTasbih.targetCount,
      ));
    }
  }
}