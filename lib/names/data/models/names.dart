import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'names.g.dart';

@JsonSerializable()
class AllahName extends Equatable {
  final int id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String description;

  const AllahName({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.description,
  });

  factory AllahName.fromJson(Map<String, dynamic> json) => _$AllahNameFromJson(json);
  Map<String, dynamic> toJson() => _$AllahNameToJson(this);

  @override
  List<Object> get props => [id, arabic, transliteration, meaning, description];
}

