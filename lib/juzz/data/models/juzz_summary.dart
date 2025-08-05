import 'package:azkar/juzz/data/models/juzz.dart';
import 'package:json_annotation/json_annotation.dart';
part 'juzz_summary.g.dart';

@JsonSerializable()
class JuzzSummary {
  final int number;
  final String name;
  final String description;
  final List<int> containedSurahs;
  final int approximateAyahs;

  JuzzSummary({
    required this.number,
    required this.name,
    required this.description,
    required this.containedSurahs,
    required this.approximateAyahs,
  });

  factory JuzzSummary.fromJson(Map<String, dynamic> json) =>
      _$JuzzSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$JuzzSummaryToJson(this);

  // Create from full Juzz data
  factory JuzzSummary.fromJuzz(Juzz juzz) {
    return JuzzSummary(
      number: juzz.number,
      name: 'Juzz ${juzz.number}',
      description: juzz.surahRange,
      containedSurahs: juzz.containedSurahs,
      approximateAyahs: juzz.totalAyahs,
    );
  }

  // Static data for all 30 Juzz sections
  static List<JuzzSummary> getAllJuzzSummaries() {
    return [
      JuzzSummary(
        number: 1,
        name: 'Alif Lam Meem',
        description: 'Al-Fatiha - Al-Baqarah (141)',
        containedSurahs: [1, 2],
        approximateAyahs: 148,
      ),
      JuzzSummary(
        number: 2,
        name: 'Sayaqool',
        description: 'Al-Baqarah (142-252)',
        containedSurahs: [2],
        approximateAyahs: 111,
      ),
      JuzzSummary(
        number: 3,
        name: 'Tilka Rusul',
        description: 'Al-Baqarah (253) - Al-Imran (92)',
        containedSurahs: [2, 3],
        approximateAyahs: 126,
      ),
      JuzzSummary(
        number: 4,
        name: 'Lan Tana Lu',
        description: 'Al-Imran (93) - An-Nisa (23)',
        containedSurahs: [3, 4],
        approximateAyahs: 131,
      ),
      JuzzSummary(
        number: 5,
        name: 'Wal Mohsanat',
        description: 'An-Nisa (24-147)',
        containedSurahs: [4],
        approximateAyahs: 124,
      ),
      JuzzSummary(
        number: 6,
        name: 'La Yuhibb Allah',
        description: 'An-Nisa (148) - Al-Ma\'idah (81)',
        containedSurahs: [4, 5],
        approximateAyahs: 111,
      ),
      JuzzSummary(
        number: 7,
        name: 'Wa Iza Sami\'u',
        description: 'Al-Ma\'idah (82) - Al-An\'am (110)',
        containedSurahs: [5, 6],
        approximateAyahs: 149,
      ),
      JuzzSummary(
        number: 8,
        name: 'Wa Lau Annana',
        description: 'Al-An\'am (111) - Al-A\'raf (87)',
        containedSurahs: [6, 7],
        approximateAyahs: 142,
      ),
      JuzzSummary(
        number: 9,
        name: 'Qal Al-Mala',
        description: 'Al-A\'raf (88) - Al-Anfal (40)',
        containedSurahs: [7, 8],
        approximateAyahs: 128,
      ),
      JuzzSummary(
        number: 10,
        name: 'Wa A\'lamu',
        description: 'Al-Anfal (41) - At-Tawbah (92)',
        containedSurahs: [8, 9],
        approximateAyahs: 129,
      ),
      JuzzSummary(
        number: 11,
        name: 'Ya\'tazir',
        description: 'At-Tawbah (93) - Hud (5)',
        containedSurahs: [9, 10, 11],
        approximateAyahs: 148,
      ),
      JuzzSummary(
        number: 12,
        name: 'Wa Ma Min Dabbah',
        description: 'Hud (6) - Yusuf (52)',
        containedSurahs: [11, 12],
        approximateAyahs: 170,
      ),
      JuzzSummary(
        number: 13,
        name: 'Wa Ma Ubri\'u',
        description: 'Yusuf (53) - Ibrahim (52)',
        containedSurahs: [12, 13, 14],
        approximateAyahs: 154,
      ),
      JuzzSummary(
        number: 14,
        name: 'Rubama',
        description: 'Al-Hijr - An-Nahl (128)',
        containedSurahs: [15, 16],
        approximateAyahs: 227,
      ),
      JuzzSummary(
        number: 15,
        name: 'Subhan Allazi',
        description: 'Al-Isra - Al-Kahf (74)',
        containedSurahs: [17, 18],
        approximateAyahs: 185,
      ),
      JuzzSummary(
        number: 16,
        name: 'Qal Alam',
        description: 'Al-Kahf (75) - Taha (135)',
        containedSurahs: [18, 19, 20],
        approximateAyahs: 160,
      ),
      JuzzSummary(
        number: 17,
        name: 'Iqtarab',
        description: 'Al-Anbiya - Al-Hajj (78)',
        containedSurahs: [21, 22],
        approximateAyahs: 190,
      ),
      JuzzSummary(
        number: 18,
        name: 'Qad Aflaha',
        description: 'Al-Mu\'minun - Al-Furqan (20)',
        containedSurahs: [23, 24, 25],
        approximateAyahs: 202,
      ),
      JuzzSummary(
        number: 19,
        name: 'Wa Qal Allazina',
        description: 'Al-Furqan (21) - An-Naml (55)',
        containedSurahs: [25, 26, 27],
        approximateAyahs: 249,
      ),
      JuzzSummary(
        number: 20,
        name: 'A\'man Khalaq',
        description: 'An-Naml (56) - Al-Ankabut (45)',
        containedSurahs: [27, 28, 29],
        approximateAyahs: 171,
      ),
      JuzzSummary(
        number: 21,
        name: 'Utlu Ma Uhiya',
        description: 'Al-Ankabut (46) - Al-Ahzab (30)',
        containedSurahs: [29, 30, 31, 32, 33],
        approximateAyahs: 194,
      ),
      JuzzSummary(
        number: 22,
        name: 'Wa Man Yaqnut',
        description: 'Al-Ahzab (31) - Ya-Sin (27)',
        containedSurahs: [33, 34, 35, 36],
        approximateAyahs: 171,
      ),
      JuzzSummary(
        number: 23,
        name: 'Wa Mali',
        description: 'Ya-Sin (28) - Az-Zumar (31)',
        containedSurahs: [36, 37, 38, 39],
        approximateAyahs: 177,
      ),
      JuzzSummary(
        number: 24,
        name: 'Fa-man Azlam',
        description: 'Az-Zumar (32) - Fussilat (46)',
        containedSurahs: [39, 40, 41],
        approximateAyahs: 173,
      ),
      JuzzSummary(
        number: 25,
        name: 'Ilayhi Yuraddu',
        description: 'Fussilat (47) - Al-Jathiyah (37)',
        containedSurahs: [41, 42, 43, 44, 45],
        approximateAyahs: 171,
      ),
      JuzzSummary(
        number: 26,
        name: 'Ha Meem',
        description: 'Al-Ahqaf - Az-Zariyat (30)',
        containedSurahs: [46, 47, 48, 49, 50, 51],
        approximateAyahs: 195,
      ),
      JuzzSummary(
        number: 27,
        name: 'Qala Fama Khatbukum',
        description: 'Az-Zariyat (31) - Al-Hadid (29)',
        containedSurahs: [51, 52, 53, 54, 55, 56, 57],
        approximateAyahs: 173,
      ),
      JuzzSummary(
        number: 28,
        name: 'Qad Sami\'a',
        description: 'Al-Mujadila - At-Tahrim',
        containedSurahs: [58, 59, 60, 61, 62, 63, 64, 65, 66],
        approximateAyahs: 182,
      ),
      JuzzSummary(
        number: 29,
        name: 'Tabarak Allazi',
        description: 'Al-Mulk - Al-Mursalat',
        containedSurahs: [67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77],
        approximateAyahs: 431,
      ),
      JuzzSummary(
        number: 30,
        name: 'Amma Yatasa\'alun',
        description: 'An-Naba - An-Nas',
        containedSurahs: [
          78,
          79,
          80,
          81,
          82,
          83,
          84,
          85,
          86,
          87,
          88,
          89,
          90,
          91,
          92,
          93,
          94,
          95,
          96,
          97,
          98,
          99,
          100,
          101,
          102,
          103,
          104,
          105,
          106,
          107,
          108,
          109,
          110,
          111,
          112,
          113,
          114,
        ],
        approximateAyahs: 564,
      ),
    ];
  }
}
