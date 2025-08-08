import 'package:json_annotation/json_annotation.dart';

part 'hadith.g.dart';

@JsonSerializable()
class Hadith {
  final int id;
  final String hadith;
  final String attribution;
  @JsonKey(name: 'grade')
  final String? grade;
  @JsonKey(name: 'book')
  final HadithBook book;

  const Hadith({
    required this.id,
    required this.hadith,
    required this.attribution,
    this.grade,
    required this.book,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);
  Map<String, dynamic> toJson() => _$HadithToJson(this);
}

@JsonSerializable()
class HadithBook {
  final int id;
  final String name;

  const HadithBook({
    required this.id,
    required this.name,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) => 
      _$HadithBookFromJson(json);
  Map<String, dynamic> toJson() => _$HadithBookToJson(this);
}

@JsonSerializable()
class HadithsResponse {
  final List<Hadith> hadiths;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'page')
  final int page;

  const HadithsResponse({
    required this.hadiths,
    required this.total,
    required this.limit,
    required this.page,
  });

  factory HadithsResponse.fromJson(Map<String, dynamic> json) => 
      _$HadithsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HadithsResponseToJson(this);
}