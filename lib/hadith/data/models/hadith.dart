import 'package:json_annotation/json_annotation.dart';

part 'hadith.g.dart';

@JsonSerializable()
class Hadith {
  final int id;
  @JsonKey(name: 'hadithNumber')
  final String hadithNumber;
  @JsonKey(name: 'englishNarrator')
  final String englishNarrator;
  @JsonKey(name: 'hadithEnglish')
  final String hadithEnglish;
  @JsonKey(name: 'hadithUrdu')
  final String? hadithUrdu;
  @JsonKey(name: 'urduNarrator')
  final String? urduNarrator;
  @JsonKey(name: 'hadithArabic')
  final String? hadithArabic;
  @JsonKey(name: 'headingArabic')
  final String? headingArabic;
  @JsonKey(name: 'headingUrdu')
  final String? headingUrdu;
  @JsonKey(name: 'headingEnglish')
  final String? headingEnglish;
  @JsonKey(name: 'chapterId')
  final String chapterId;
  @JsonKey(name: 'bookSlug')
  final String bookSlug;
  @JsonKey(name: 'volume')
  final String volume;
  @JsonKey(name: 'status')
  final String status;
  final HadithBook book;
  final HadithChapter chapter;

  const Hadith({
    required this.id,
    required this.hadithNumber,
    required this.englishNarrator,
    required this.hadithEnglish,
    this.hadithUrdu,
    this.urduNarrator,
    this.hadithArabic,
    this.headingArabic,
    this.headingUrdu,
    this.headingEnglish,
    required this.chapterId,
    required this.bookSlug,
    required this.volume,
    required this.status,
    required this.book,
    required this.chapter,
  });

  // Helper getters for compatibility with your existing widgets
  String get hadith => hadithEnglish;
  String get attribution => englishNarrator;
  String? get grade => status;

  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);
  Map<String, dynamic> toJson() => _$HadithToJson(this);
}

@JsonSerializable()
class HadithBook {
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

  const HadithBook({
    required this.id,
    required this.name,
    required this.writerName,
    this.aboutWriter,
    this.writerDeath,
    required this.bookSlug,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) => 
      _$HadithBookFromJson(json);
  Map<String, dynamic> toJson() => _$HadithBookToJson(this);
}

@JsonSerializable()
class HadithChapter {
  final int id;
  @JsonKey(name: 'chapterNumber')
  final String chapterNumber;
  @JsonKey(name: 'chapterEnglish')
  final String chapterEnglish;
  @JsonKey(name: 'chapterUrdu')
  final String? chapterUrdu;
  @JsonKey(name: 'chapterArabic')
  final String? chapterArabic;
  @JsonKey(name: 'bookSlug')
  final String bookSlug;

  const HadithChapter({
    required this.id,
    required this.chapterNumber,
    required this.chapterEnglish,
    this.chapterUrdu,
    this.chapterArabic,
    required this.bookSlug,
  });

  factory HadithChapter.fromJson(Map<String, dynamic> json) => 
      _$HadithChapterFromJson(json);
  Map<String, dynamic> toJson() => _$HadithChapterToJson(this);
}

@JsonSerializable()
class HadithData {
  @JsonKey(name: 'current_page')
  final int currentPage;
  final List<Hadith> data;

  const HadithData({
    required this.currentPage,
    required this.data,
  });

  factory HadithData.fromJson(Map<String, dynamic> json) => 
      _$HadithDataFromJson(json);
  Map<String, dynamic> toJson() => _$HadithDataToJson(this);
}

@JsonSerializable()
class HadithsResponse {
  final int status;
  final String message;
  final HadithData hadiths;

  const HadithsResponse({
    required this.status,
    required this.message,
    required this.hadiths,
  });

  // Helper getters for compatibility with your existing code
  List<Hadith> get hadithsList => hadiths.data;
  int get total => hadiths.data.length; // You might need to adjust this based on actual API pagination
  int get limit => 10; // Default limit, adjust as needed
  int get page => hadiths.currentPage;

  factory HadithsResponse.fromJson(Map<String, dynamic> json) => 
      _$HadithsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HadithsResponseToJson(this);
}