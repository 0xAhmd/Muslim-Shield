import 'package:azkar/hadith/data/repo/hadith_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/book.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final HadithRepository _repository;

  BooksCubit(this._repository) : super(BooksInitial());

  Future<void> loadBooks() async {
    emit(BooksLoading());
    try {
      final books = await _repository.getBooks();
      emit(BooksLoaded(books));
    } catch (e) {
      emit(BooksError(e.toString()));
    }
  }

  void searchBooks(String query) {
    if (state is BooksLoaded) {
      final books = (state as BooksLoaded).books;
      if (query.isEmpty) {
        emit(BooksLoaded(books));
      } else {
        final filteredBooks = books
            .where((book) =>
                book.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        emit(BooksLoaded(filteredBooks));
      }
    }
  }
}
