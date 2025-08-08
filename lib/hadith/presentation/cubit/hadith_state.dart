part of 'hadith_cubit.dart';



abstract class HadithsState extends Equatable {
  const HadithsState();

  @override
  List<Object> get props => [];
}

class HadithsInitial extends HadithsState {}

class HadithsLoading extends HadithsState {}

class HadithsLoadingMore extends HadithsState {
  final List<Hadith> hadiths;

  const HadithsLoadingMore(this.hadiths);

  @override
  List<Object> get props => [hadiths];
}

class HadithsLoaded extends HadithsState {
  final List<Hadith> hadiths;
  final bool hasMore;
  final int currentPage;
  final int total;

  const HadithsLoaded({
    required this.hadiths,
    required this.hasMore,
    required this.currentPage,
    required this.total,
  });

  @override
  List<Object> get props => [hadiths, hasMore, currentPage, total];
}

class HadithsError extends HadithsState {
  final String message;

  const HadithsError(this.message);

  @override
  List<Object> get props => [message];
}

class HadithsLoadMoreError extends HadithsState {
  final List<Hadith> hadiths;
  final String message;

  const HadithsLoadMoreError(this.hadiths, this.message);

  @override
  List<Object> get props => [hadiths, message];
}