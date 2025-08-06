import 'hizb.dart';
import 'package:json_annotation/json_annotation.dart';
part 'hizb_summary.g.dart';

@JsonSerializable()
class HizbSummary {
  final int number;
  final String name;
  final String description;
  final List<int> containedSurahs;
  final List<int> containedJuzz;
  final int approximateAyahs;

  HizbSummary({
    required this.number,
    required this.name,
    required this.description,
    required this.containedSurahs,
    required this.containedJuzz,
    required this.approximateAyahs,
  });

  factory HizbSummary.fromJson(Map<String, dynamic> json) =>
      _$HizbSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$HizbSummaryToJson(this);

  // Create from full Hizb data
  factory HizbSummary.fromHizb(Hizb hizb) {
    return HizbSummary(
      number: hizb.number,
      name: 'Hizb ${hizb.number}',
      description: hizb.surahRange,
      containedSurahs: hizb.containedSurahs,
      containedJuzz: hizb.containedJuzz,
      approximateAyahs: hizb.totalAyahs,
    );
  }

  // Static data for all 60 Hizb sections
  static List<HizbSummary> getAllHizbSummaries() {
    return List.generate(60, (index) {
      final hizbNumber = index + 1;
      final juzzNumber = ((hizbNumber - 1) ~/ 2) + 1;
      final isFirstHalf = hizbNumber % 2 == 1;

      return HizbSummary(
        number: hizbNumber,
        name: 'Hizb $hizbNumber',
        description:
            'Juzz $juzzNumber ${isFirstHalf ? "(First Half)" : "(Second Half)"}',
        containedSurahs: _getContainedSurahs(hizbNumber),
        containedJuzz: [juzzNumber],
        approximateAyahs: _getApproximateAyahs(hizbNumber),
      );
    });
  }

  static List<int> _getContainedSurahs(int hizbNumber) {
    // This is a simplified mapping - in a real app you'd have the exact data
    // For now, we'll provide estimated ranges based on Juzz structure
    switch (hizbNumber) {
      case 1:
        return [1, 2];
      case 2:
        return [2];
      case 3:
        return [2];
      case 4:
        return [2, 3];
      case 5:
        return [3];
      case 6:
        return [3, 4];
      case 7:
        return [4];
      case 8:
        return [4];
      case 9:
        return [4, 5];
      case 10:
        return [5];
      case 11:
        return [5, 6];
      case 12:
        return [6];
      case 13:
        return [6, 7];
      case 14:
        return [7];
      case 15:
        return [7, 8];
      case 16:
        return [8];
      case 17:
        return [8, 9];
      case 18:
        return [9];
      case 19:
        return [9, 10];
      case 20:
        return [10];
      default:
        final juzzNumber = ((hizbNumber - 1) ~/ 2) + 1;
        return [juzzNumber]; // Simplified mapping
    }
  }

  static int _getApproximateAyahs(int hizbNumber) {
    // Average ayahs per hizb varies, but roughly 100-150
    return 120; // Simplified - in real app this would be more accurate
  }
}
