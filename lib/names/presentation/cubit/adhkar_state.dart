

// lib/adhkar/presentation/cubit/adhkar_state.dart (part of above file)
part of 'adhkar_cubit.dart';

abstract class AdhkarState extends Equatable {
  const AdhkarState();

  @override
  List<Object?> get props => [];
}

class AdhkarInitial extends AdhkarState {}

class AdhkarLoading extends AdhkarState {}

class AdhkarLoaded extends AdhkarState {
  final List<Adhkar> morningAdhkar;
  final List<Adhkar> eveningAdhkar;
  final List<Adhkar> filteredMorningAdhkar;
  final List<Adhkar> filteredEveningAdhkar;
  final String? searchQuery;

  const AdhkarLoaded({
    required this.morningAdhkar,
    required this.eveningAdhkar,
    required this.filteredMorningAdhkar,
    required this.filteredEveningAdhkar,
    this.searchQuery,
  });

  AdhkarLoaded copyWith({
    List<Adhkar>? morningAdhkar,
    List<Adhkar>? eveningAdhkar,
    List<Adhkar>? filteredMorningAdhkar,
    List<Adhkar>? filteredEveningAdhkar,
    String? searchQuery,
  }) {
    return AdhkarLoaded(
      morningAdhkar: morningAdhkar ?? this.morningAdhkar,
      eveningAdhkar: eveningAdhkar ?? this.eveningAdhkar,
      filteredMorningAdhkar: filteredMorningAdhkar ?? this.filteredMorningAdhkar,
      filteredEveningAdhkar: filteredEveningAdhkar ?? this.filteredEveningAdhkar,
      searchQuery: searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    morningAdhkar, 
    eveningAdhkar, 
    filteredMorningAdhkar, 
    filteredEveningAdhkar, 
    searchQuery
  ];
}

class AdhkarError extends AdhkarState {
  final String message;

  const AdhkarError({required this.message});

  @override
  List<Object?> get props => [message];
}