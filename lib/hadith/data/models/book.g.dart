// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: (json['id'] as num).toInt(),
  name: json['bookName'] as String,
  writerName: json['writerName'] as String,
  aboutWriter: json['aboutWriter'] as String?,
  writerDeath: json['writerDeath'] as String?,
  bookSlug: json['bookSlug'] as String,
  hadithsCount: json['hadiths_count'] as String,
  chaptersCount: json['chapters_count'] as String,
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'id': instance.id,
  'bookName': instance.name,
  'writerName': instance.writerName,
  'aboutWriter': instance.aboutWriter,
  'writerDeath': instance.writerDeath,
  'bookSlug': instance.bookSlug,
  'hadiths_count': instance.hadithsCount,
  'chapters_count': instance.chaptersCount,
};

BooksResponse _$BooksResponseFromJson(Map<String, dynamic> json) =>
    BooksResponse(
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      books: (json['books'] as List<dynamic>)
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BooksResponseToJson(BooksResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'books': instance.books,
    };
