import 'package:azkar/hadith/data/models/hadith.dart';
import 'package:azkar/hadith/data/repo/hadith_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hadith_state.dart';

class HadithsCubit extends Cubit<HadithsState> {
  final HadithRepository _repository;

  HadithsCubit(this._repository) : super(HadithsInitial());

  Future<void> loadHadiths(String bookSlug, {int paginate = 25}) async {
    emit(HadithsLoading());

    try {
      final response = await _repository.getHadiths(bookSlug, paginate);

      emit(
        HadithsLoaded(
          hadiths: response.hadithsList,
          hasMore: false, // API doesn't seem to support traditional pagination
          currentPage: 1,
          total: response.hadithsList.length,
        ),
      );
    } catch (e) {
      emit(HadithsError(e.toString()));
    }
  }

  void loadMore(String bookSlug) {
    // Since the API uses paginate parameter rather than page-based pagination,
    // we'll load more hadiths by increasing the paginate count
    if (state is HadithsLoaded) {
      final currentState = state as HadithsLoaded;
      final newPaginate = currentState.total + 25;

      emit(HadithsLoadingMore(currentState.hadiths));

      _loadMoreHadiths(bookSlug, newPaginate, currentState.hadiths);
    }
  }

  Future<void> _loadMoreHadiths(
    String bookSlug,
    int paginate,
    List<Hadith> currentHadiths,
  ) async {
    try {
      final response = await _repository.getHadiths(bookSlug, paginate);

      // Only add new hadiths that we don't already have
      final newHadiths = response.hadithsList
          .where(
            (hadith) =>
                !currentHadiths.any((existing) => existing.id == hadith.id),
          )
          .toList();

      final allHadiths = [...currentHadiths, ...newHadiths];

      emit(
        HadithsLoaded(
          hadiths: allHadiths,
          hasMore: newHadiths.isNotEmpty,
          currentPage: 1,
          total: allHadiths.length,
        ),
      );
    } catch (e) {
      emit(HadithsLoadMoreError(currentHadiths, e.toString()));
    }
  }
}
