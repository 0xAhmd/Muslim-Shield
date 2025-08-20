import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'adhkar.g.dart';

enum AdhkarType { morning, evening }

@JsonSerializable()
class Adhkar extends Equatable {
  final int id;
  final String arabic;
  final String transliteration;
  final String translation;
  final String reference;
  final int repetition;
  final AdhkarType type;

  const Adhkar({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.reference,
    required this.repetition,
    required this.type,
  });

  factory Adhkar.fromJson(Map<String, dynamic> json) => _$AdhkarFromJson(json);
  Map<String, dynamic> toJson() => _$AdhkarToJson(this);

  @override
  List<Object> get props => [
    id,
    arabic,
    transliteration,
    translation,
    reference,
    repetition,
    type,
  ];
}
