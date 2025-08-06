import 'sajda_ayah.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sajda.g.dart';

@JsonSerializable()
class Sajda {
  final List<SajdaAyah> ayahs;
  final SajdaEdition edition;

  Sajda({required this.ayahs, required this.edition});

  factory Sajda.fromJson(Map<String, dynamic> json) => _$SajdaFromJson(json);
  Map<String, dynamic> toJson() => _$SajdaToJson(this);

  // Helper methods
  int get totalSajdas => ayahs.length;

  List<int> get containedSurahs {
    return ayahs.map((ayah) => ayah.surah.number).toSet().toList()..sort();
  }

  String get surahRange {
    final surahs = containedSurahs;
    if (surahs.isEmpty) return '';
    if (surahs.length == 1) return 'Surah ${surahs.first}';
    return 'Surah ${surahs.first} - ${surahs.last}';
  }

  List<int> get containedJuzz {
    return ayahs.map((ayah) => ayah.juz).toSet().toList()..sort();
  }

  String get juzzRange {
    final juzzs = containedJuzz;
    if (juzzs.isEmpty) return '';
    if (juzzs.length == 1) return 'Juzz ${juzzs.first}';
    return 'Juzz ${juzzs.first} - ${juzzs.last}';
  }

  // Get obligatory sajdas only
  List<SajdaAyah> get obligatorySajdas {
    return ayahs.where((ayah) => ayah.sajda.obligatory).toList();
  }

  // Get recommended sajdas only
  List<SajdaAyah> get recommendedSajdas {
    return ayahs.where((ayah) => ayah.sajda.recommended).toList();
  }
}

@JsonSerializable()
class SajdaEdition {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String direction;

  SajdaEdition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    required this.direction,
  });

  factory SajdaEdition.fromJson(Map<String, dynamic> json) =>
      _$SajdaEditionFromJson(json);
  Map<String, dynamic> toJson() => _$SajdaEditionToJson(this);
}
