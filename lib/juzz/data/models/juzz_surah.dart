import 'package:json_annotation/json_annotation.dart';

part 'juzz_surah.g.dart';

@JsonSerializable()
class JuzzSurah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;

  JuzzSurah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  factory JuzzSurah.fromJson(Map<String, dynamic> json) => _$JuzzSurahFromJson(json);
  Map<String, dynamic> toJson() => _$JuzzSurahToJson(this);
}
