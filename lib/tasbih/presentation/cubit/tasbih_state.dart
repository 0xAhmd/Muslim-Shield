import '../../data/models/tasbih.dart';
import 'package:equatable/equatable.dart';

abstract class TasbihState extends Equatable {
  const TasbihState();

  @override
  List<Object> get props => [];
}

class TasbihInitial extends TasbihState {}

class TasbihLoading extends TasbihState {}

class TasbihLoaded extends TasbihState {
  final List<TasbihModel> tasbihList;
  final TasbihModel? selectedTasbih;
  final bool isCompleted;

  const TasbihLoaded({
    required this.tasbihList,
    this.selectedTasbih,
    this.isCompleted = false,
  });

  @override
  List<Object> get props => [tasbihList, selectedTasbih ?? '', isCompleted];

  TasbihLoaded copyWith({
    List<TasbihModel>? tasbihList,
    TasbihModel? selectedTasbih,
    bool? isCompleted,
  }) {
    return TasbihLoaded(
      tasbihList: tasbihList ?? this.tasbihList,
      selectedTasbih: selectedTasbih ?? this.selectedTasbih,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TasbihError extends TasbihState {
  final String message;

  const TasbihError(this.message);

  @override
  List<Object> get props => [message];
}
