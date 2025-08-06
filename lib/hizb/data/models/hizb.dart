import 'hizb_ayah.dart';
import 'package:json_annotation/json_annotation.dart';
part 'hizb.g.dart';

@JsonSerializable()
class Hizb {
  final int number;
  final List<HizbAyah> ayahs;

  Hizb({required this.number, required this.ayahs});

  factory Hizb.fromJson(Map<String, dynamic> json) => _$HizbFromJson(json);
  Map<String, dynamic> toJson() => _$HizbToJson(this);

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

  List<int> get containedJuzz {
    return ayahs.map((ayah) => ayah.juz).toSet().toList()..sort();
  }

  String get juzzRange {
    final juzzs = containedJuzz;
    if (juzzs.isEmpty) return '';
    if (juzzs.length == 1) return 'Juzz ${juzzs.first}';
    return 'Juzz ${juzzs.first} - ${juzzs.last}';
  }
}
