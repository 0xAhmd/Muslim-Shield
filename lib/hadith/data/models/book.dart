import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  final int id;
  @JsonKey(name: 'bookName')
  final String name;
  @JsonKey(name: 'writerName')
  final String writerName;
  @JsonKey(name: 'aboutWriter')
  final String? aboutWriter;
  @JsonKey(name: 'writerDeath')
  final String? writerDeath;
  @JsonKey(name: 'bookSlug')
  final String bookSlug;
  @JsonKey(name: 'hadiths_count')
  final String hadithsCount;
  @JsonKey(name: 'chapters_count')
  final String chaptersCount;

  const Book({
    required this.id,
    required this.name,
    required this.writerName,
    this.aboutWriter,
    this.writerDeath,
    required this.bookSlug,
    required this.hadithsCount,
    required this.chaptersCount,
  });

  // Helper getters
  int get hadithsCountInt => int.tryParse(hadithsCount) ?? 0;
  int get chaptersCountInt => int.tryParse(chaptersCount) ?? 0;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);
}

@JsonSerializable()
class BooksResponse {
  final int status;
  final String message;
  final List<Book> books;

  const BooksResponse({
    required this.status,
    required this.message,
    required this.books,
  });

  factory BooksResponse.fromJson(Map<String, dynamic> json) =>
      _$BooksResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BooksResponseToJson(this);
}
