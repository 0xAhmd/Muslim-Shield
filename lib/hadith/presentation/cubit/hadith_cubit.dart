import 'package:azkar/hadith/data/models/hadith.dart';
import 'package:azkar/hadith/data/repo/hadith_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'hadith_state.dart';

class HadithsCubit extends Cubit<HadithsState> {
  final HadithRepository _repository;

  HadithsCubit(this._repository) : super(HadithsInitial());

  Future<void> loadHadiths(int bookId, {int page = 1}) async {
    if (page == 1) {
      emit(HadithsLoading());
    } else {
      emit(HadithsLoadingMore((state as HadithsLoaded).hadiths));
    }

    try {
      final response = await _repository.getHadiths(bookId, page);
      
      if (page == 1) {
        emit(HadithsLoaded(
          hadiths: response.hadiths,
          hasMore: response.hadiths.length < response.total,
          currentPage: page,
          total: response.total,
        ));
      } else {
        final currentState = state as HadithsLoaded;
        final allHadiths = [...currentState.hadiths, ...response.hadiths];
        emit(HadithsLoaded(
          hadiths: allHadiths,
          hasMore: allHadiths.length < response.total,
          currentPage: page,
          total: response.total,
        ));
      }
    } catch (e) {
      if (page == 1) {
        emit(HadithsError(e.toString()));
      } else {
        emit(HadithsLoadMoreError((state as HadithsLoaded).hadiths, e.toString()));
      }
    }
  }

  void loadMore(int bookId) {
    if (state is HadithsLoaded) {
      final currentState = state as HadithsLoaded;
      if (currentState.hasMore) {
        loadHadiths(bookId, page: currentState.currentPage + 1);
      }
    }
  }
}
