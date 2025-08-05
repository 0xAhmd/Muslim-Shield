import 'package:azkar/surah/data/models/surah.dart';
import 'package:json_annotation/json_annotation.dart';

part 'juzz_ayah.g.dart';

@JsonSerializable()
class JuzzAyah {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;
  final Surah surah;

  JuzzAyah({
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

  factory JuzzAyah.fromJson(Map<String, dynamic> json) => _$JuzzAyahFromJson(json);
  Map<String, dynamic> toJson() => _$JuzzAyahToJson(this);
}






