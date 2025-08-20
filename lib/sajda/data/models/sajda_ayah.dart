import '../../../surah/data/models/surah.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sajda_ayah.g.dart';

@JsonSerializable()
class SajdaAyah {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final SajdaInfo sajda;
  final Surah surah;

  SajdaAyah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
    required this.surah,
  });

  factory SajdaAyah.fromJson(Map<String, dynamic> json) =>
      _$SajdaAyahFromJson(json);
  Map<String, dynamic> toJson() => _$SajdaAyahToJson(this);

  // Helper methods
  String get surahName => surah.englishName;
  String get surahArabicName => surah.name;
  bool get isObligatory => sajda.obligatory;
  bool get isRecommended => sajda.recommended;

  String get sajdaType => sajda.obligatory ? 'Obligatory' : 'Recommended';

  String get reference => '${surah.englishName} $numberInSurah:${surah.number}';
}

@JsonSerializable()
class SajdaInfo {
  final int id;
  final bool recommended;
  final bool obligatory;

  SajdaInfo({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });

  factory SajdaInfo.fromJson(Map<String, dynamic> json) =>
      _$SajdaInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SajdaInfoToJson(this);
}
