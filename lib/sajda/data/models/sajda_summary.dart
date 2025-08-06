import 'sajda_ayah.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sajda_summary.g.dart';

@JsonSerializable()
class SajdaSummary {
  final int id;
  final String surahName;
  final String surahArabicName;
  final int surahNumber;
  final int ayahNumber;
  final String ayahText;
  final bool isObligatory;
  final bool isRecommended;
  final int juz;
  final int page;
  final String sajdaType;

  SajdaSummary({
    required this.id,
    required this.surahName,
    required this.surahArabicName,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahText,
    required this.isObligatory,
    required this.isRecommended,
    required this.juz,
    required this.page,
    required this.sajdaType,
  });

  factory SajdaSummary.fromJson(Map<String, dynamic> json) =>
      _$SajdaSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SajdaSummaryToJson(this);

  // Create from SajdaAyah
  factory SajdaSummary.fromSajdaAyah(SajdaAyah ayah) {
    return SajdaSummary(
      id: ayah.sajda.id,
      surahName: ayah.surah.englishName,
      surahArabicName: ayah.surah.name,
      surahNumber: ayah.surah.number,
      ayahNumber: ayah.numberInSurah,
      ayahText: ayah.text,
      isObligatory: ayah.sajda.obligatory,
      isRecommended: ayah.sajda.recommended,
      juz: ayah.juz,
      page: ayah.page,
      sajdaType: ayah.sajdaType,
    );
  }

  // Helper getter for display
  String get reference => '$surahName $ayahNumber:$surahNumber';

  String get shortText {
    if (ayahText.length <= 100) return ayahText;
    return '${ayahText.substring(0, 100)}...';
  }
}
