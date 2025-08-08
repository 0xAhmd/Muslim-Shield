import 'package:azkar/hadith/data/repo/hadith_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/book.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final HadithRepository _repository;
  List<Book> _validBooks = [];

  BooksCubit(this._repository) : super(BooksInitial());

  Future<void> loadBooks() async {
    emit(BooksLoading());
    try {
      // Get all books first
      final allBooks = await _repository.getBooks();

      // Filter books that have hadiths
      await _filterValidBooks(allBooks);

      emit(BooksLoaded(_validBooks));
    } catch (e) {
      emit(BooksError(e.toString()));
    }
  }

  Future<void> _filterValidBooks(List<Book> books) async {
    final validBooks = <Book>[];

    // Books known to have issues (you can add more to this list)
    final problematicBookSlugs = {
      'sahih-muslim',
      'musnad-ahmad',
      'al-silsila-sahiha',
    };

    // First, exclude known problematic books
    final booksToCheck = books
        .where(
          (book) => !problematicBookSlugs.contains(book.bookSlug.toLowerCase()),
        )
        .toList();

    // Add the remaining books (we can optionally verify each one)
    for (final book in booksToCheck) {
      try {
        // Quick check: try to load just 1 hadith to verify the book has data
        final response = await _repository.getHadiths(book.bookSlug, 1);
        if (response.hadithsList.isNotEmpty) {
          validBooks.add(book);
        }
      } catch (e) {
        // If there's an error loading hadiths, skip this book
        print('Skipping book ${book.name} due to error: $e');
        continue;
      }
    }

    _validBooks = validBooks;
  }

  void searchBooks(String query) {
    if (query.isEmpty) {
      emit(BooksLoaded(_validBooks));
    } else {
      final filteredBooks = _validBooks
          .where(
            (book) =>
                book.name.toLowerCase().contains(query.toLowerCase()) ||
                book.writerName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      emit(BooksLoaded(filteredBooks));
    }
  }

  // Method to manually refresh and re-filter books
  Future<void> refreshBooks() async {
    await loadBooks();
  }
}
