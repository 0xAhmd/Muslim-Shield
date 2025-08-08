// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hadith _$HadithFromJson(Map<String, dynamic> json) => Hadith(
      id: (json['id'] as num).toInt(),
      hadith: json['hadith'] as String,
      attribution: json['attribution'] as String,
      grade: json['grade'] as String?,
      book: HadithBook.fromJson(json['book'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HadithToJson(Hadith instance) => <String, dynamic>{
      'id': instance.id,
      'hadith': instance.hadith,
      'attribution': instance.attribution,
      'grade': instance.grade,
      'book': instance.book,
    };

HadithBook _$HadithBookFromJson(Map<String, dynamic> json) => HadithBook(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$HadithBookToJson(HadithBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

HadithsResponse _$HadithsResponseFromJson(Map<String, dynamic> json) =>
    HadithsResponse(
      hadiths: (json['hadiths'] as List<dynamic>)
          .map((e) => Hadith.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      page: (json['page'] as num).toInt(),
    );

Map<String, dynamic> _$HadithsResponseToJson(HadithsResponse instance) =>
    <String, dynamic>{
      'hadiths': instance.hadiths,
      'total': instance.total,
      'limit': instance.limit,
      'page': instance.page,
    };
