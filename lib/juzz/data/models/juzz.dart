import 'juzz_ayah.dart';
import 'package:json_annotation/json_annotation.dart';
part 'juzz.g.dart';

@JsonSerializable()
class Juzz {
  final int number;
  final List<JuzzAyah> ayahs;

  Juzz({required this.number, required this.ayahs});

  factory Juzz.fromJson(Map<String, dynamic> json) => _$JuzzFromJson(json);
  Map<String, dynamic> toJson() => _$JuzzToJson(this);

  // Helper methods
  int get totalAyahs => ayahs.length;

  List<int> get containedSurahs {
    return ayahs.map((ayah) => ayah.surah.number).toSet().toList()..sort();
  }

  String get surahRange {
    final surahs = containedSurahs;
    if (surahs.isEmpty) return '';
    if (surahs.length == 1) return 'Surah ${surahs.first}';
    return 'Surah ${surahs.first} - ${surahs.last}';
  }
}
