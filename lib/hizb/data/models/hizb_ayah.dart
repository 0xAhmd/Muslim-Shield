import 'package:azkar/surah/data/models/surah.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hizb_ayah.g.dart';

@JsonSerializable()
class HizbAyah {
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

  HizbAyah({
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

  factory HizbAyah.fromJson(Map<String, dynamic> json) =>
      _$HizbAyahFromJson(json);
  Map<String, dynamic> toJson() => _$HizbAyahToJson(this);
}
