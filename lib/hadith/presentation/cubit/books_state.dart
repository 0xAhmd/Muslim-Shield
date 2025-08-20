part of 'books_cubit.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object> get props => [];
}

class BooksInitial extends BooksState {}

class BooksLoading extends BooksState {}

class BooksLoaded extends BooksState {
  final List<Book> books;

  const BooksLoaded(this.books);

  @override
  List<Object> get props => [books];
}

class BooksError extends BooksState {
  final String message;

  const BooksError(this.message);

  @override
  List<Object> get props => [message];
}
