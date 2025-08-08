// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hadith _$HadithFromJson(Map<String, dynamic> json) => Hadith(
      id: (json['id'] as num).toInt(),
      hadithNumber: json['hadithNumber'] as String,
      englishNarrator: json['englishNarrator'] as String,
      hadithEnglish: json['hadithEnglish'] as String,
      hadithUrdu: json['hadithUrdu'] as String?,
      urduNarrator: json['urduNarrator'] as String?,
      hadithArabic: json['hadithArabic'] as String?,
      headingArabic: json['headingArabic'] as String?,
      headingUrdu: json['headingUrdu'] as String?,
      headingEnglish: json['headingEnglish'] as String?,
      chapterId: json['chapterId'] as String,
      bookSlug: json['bookSlug'] as String,
      volume: json['volume'] as String,
      status: json['status'] as String,
      book: HadithBook.fromJson(json['book'] as Map<String, dynamic>),
      chapter: HadithChapter.fromJson(json['chapter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HadithToJson(Hadith instance) => <String, dynamic>{
      'id': instance.id,
      'hadithNumber': instance.hadithNumber,
      'englishNarrator': instance.englishNarrator,
      'hadithEnglish': instance.hadithEnglish,
      'hadithUrdu': instance.hadithUrdu,
      'urduNarrator': instance.urduNarrator,
      'hadithArabic': instance.hadithArabic,
      'headingArabic': instance.headingArabic,
      'headingUrdu': instance.headingUrdu,
      'headingEnglish': instance.headingEnglish,
      'chapterId': instance.chapterId,
      'bookSlug': instance.bookSlug,
      'volume': instance.volume,
      'status': instance.status,
      'book': instance.book,
      'chapter': instance.chapter,
    };

HadithBook _$HadithBookFromJson(Map<String, dynamic> json) => HadithBook(
      id: (json['id'] as num).toInt(),
      name: json['bookName'] as String,
      writerName: json['writerName'] as String,
      aboutWriter: json['aboutWriter'] as String?,
      writerDeath: json['writerDeath'] as String?,
      bookSlug: json['bookSlug'] as String,
    );

Map<String, dynamic> _$HadithBookToJson(HadithBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookName': instance.name,
      'writerName': instance.writerName,
      'aboutWriter': instance.aboutWriter,
      'writerDeath': instance.writerDeath,
      'bookSlug': instance.bookSlug,
    };

HadithChapter _$HadithChapterFromJson(Map<String, dynamic> json) =>
    HadithChapter(
      id: (json['id'] as num).toInt(),
      chapterNumber: json['chapterNumber'] as String,
      chapterEnglish: json['chapterEnglish'] as String,
      chapterUrdu: json['chapterUrdu'] as String?,
      chapterArabic: json['chapterArabic'] as String?,
      bookSlug: json['bookSlug'] as String,
    );

Map<String, dynamic> _$HadithChapterToJson(HadithChapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterNumber': instance.chapterNumber,
      'chapterEnglish': instance.chapterEnglish,
      'chapterUrdu': instance.chapterUrdu,
      'chapterArabic': instance.chapterArabic,
      'bookSlug': instance.bookSlug,
    };

HadithData _$HadithDataFromJson(Map<String, dynamic> json) => HadithData(
      currentPage: (json['current_page'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => Hadith.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HadithDataToJson(HadithData instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'data': instance.data,
    };

HadithsResponse _$HadithsResponseFromJson(Map<String, dynamic> json) =>
    HadithsResponse(
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      hadiths: HadithData.fromJson(json['hadiths'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HadithsResponseToJson(HadithsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'hadiths': instance.hadiths,
    };
