import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  final int id;
  final String name;
  @JsonKey(name: 'available_translations')
  final List<String> availableTranslations;

  const Book({
    required this.id,
    required this.name,
    required this.availableTranslations,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);
}

@JsonSerializable()
class BooksResponse {
  final List<Book> books;

  const BooksResponse({required this.books});

  factory BooksResponse.fromJson(Map<String, dynamic> json) => 
      _$BooksResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BooksResponseToJson(this);
}