import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'tasbih.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class TasbihModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String arabicText;

  @HiveField(3)
  final String transliteration;

  @HiveField(4)
  final String translation;

  @HiveField(5)
  final int targetCount;

  @HiveField(6)
  final int currentCount;

  @HiveField(7)
  final DateTime lastUpdated;

  const TasbihModel({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.targetCount,
    this.currentCount = 0,
    required this.lastUpdated,
  });

  factory TasbihModel.fromJson(Map<String, dynamic> json) =>
      _$TasbihModelFromJson(json);

  Map<String, dynamic> toJson() => _$TasbihModelToJson(this);

  TasbihModel copyWith({
    String? id,
    String? title,
    String? arabicText,
    String? transliteration,
    String? translation,
    int? targetCount,
    int? currentCount,
    DateTime? lastUpdated,
  }) {
    return TasbihModel(
      id: id ?? this.id,
      title: title ?? this.title,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
