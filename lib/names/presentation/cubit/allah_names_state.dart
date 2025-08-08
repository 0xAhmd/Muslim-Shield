part of 'allah_names_cubit.dart';

abstract class AllahNamesState extends Equatable {
  const AllahNamesState();

  @override
  List<Object?> get props => [];
}

class AllahNamesInitial extends AllahNamesState {}

class AllahNamesLoading extends AllahNamesState {}

class AllahNamesLoaded extends AllahNamesState {
  final List<AllahName> names;
  final List<AllahName> filteredNames;
  final String? searchQuery;

  const AllahNamesLoaded({
    required this.names,
    required this.filteredNames,
    this.searchQuery,
  });

  AllahNamesLoaded copyWith({
    List<AllahName>? names,
    List<AllahName>? filteredNames,
    String? searchQuery,
  }) {
    return AllahNamesLoaded(
      names: names ?? this.names,
      filteredNames: filteredNames ?? this.filteredNames,
      searchQuery: searchQuery,
    );
  }

  @override
  List<Object?> get props => [names, filteredNames, searchQuery];
}

class AllahNamesError extends AllahNamesState {
  final String message;

  const AllahNamesError({required this.message});

  @override
  List<Object?> get props => [message];
}