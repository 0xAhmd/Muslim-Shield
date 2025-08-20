// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasbih.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasbihModelAdapter extends TypeAdapter<TasbihModel> {
  @override
  final int typeId = 3;

  @override
  TasbihModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasbihModel(
      id: fields[0] as String,
      title: fields[1] as String,
      arabicText: fields[2] as String,
      transliteration: fields[3] as String,
      translation: fields[4] as String,
      targetCount: fields[5] as int,
      currentCount: fields[6] as int,
      lastUpdated: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TasbihModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.arabicText)
      ..writeByte(3)
      ..write(obj.transliteration)
      ..writeByte(4)
      ..write(obj.translation)
      ..writeByte(5)
      ..write(obj.targetCount)
      ..writeByte(6)
      ..write(obj.currentCount)
      ..writeByte(7)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasbihModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TasbihModel _$TasbihModelFromJson(Map<String, dynamic> json) => TasbihModel(
  id: json['id'] as String,
  title: json['title'] as String,
  arabicText: json['arabicText'] as String,
  transliteration: json['transliteration'] as String,
  translation: json['translation'] as String,
  targetCount: (json['targetCount'] as num).toInt(),
  currentCount: (json['currentCount'] as num?)?.toInt() ?? 0,
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$TasbihModelToJson(TasbihModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'arabicText': instance.arabicText,
      'transliteration': instance.transliteration,
      'translation': instance.translation,
      'targetCount': instance.targetCount,
      'currentCount': instance.currentCount,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
