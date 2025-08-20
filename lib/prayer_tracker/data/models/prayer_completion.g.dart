// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_completion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerCompletionAdapter extends TypeAdapter<PrayerCompletion> {
  @override
  final int typeId = 10;

  @override
  PrayerCompletion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerCompletion(
      date: fields[0] as String,
      completions: (fields[1] as Map).cast<PrayerType, bool>(),
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerCompletion obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.completions)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerCompletionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrayerStreakAdapter extends TypeAdapter<PrayerStreak> {
  @override
  final int typeId = 12;

  @override
  PrayerStreak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerStreak(
      currentStreak: fields[0] as int,
      longestStreak: fields[1] as int,
      lastCompletionDate: fields[2] as String?,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      totalCompleteDays: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerStreak obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.currentStreak)
      ..writeByte(1)
      ..write(obj.longestStreak)
      ..writeByte(2)
      ..write(obj.lastCompletionDate)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.totalCompleteDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerStreakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrayerTypeAdapter extends TypeAdapter<PrayerType> {
  @override
  final int typeId = 11;

  @override
  PrayerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PrayerType.fajr;
      case 1:
        return PrayerType.dhuhr;
      case 2:
        return PrayerType.asr;
      case 3:
        return PrayerType.maghrib;
      case 4:
        return PrayerType.isha;
      default:
        return PrayerType.fajr;
    }
  }

  @override
  void write(BinaryWriter writer, PrayerType obj) {
    switch (obj) {
      case PrayerType.fajr:
        writer.writeByte(0);
        break;
      case PrayerType.dhuhr:
        writer.writeByte(1);
        break;
      case PrayerType.asr:
        writer.writeByte(2);
        break;
      case PrayerType.maghrib:
        writer.writeByte(3);
        break;
      case PrayerType.isha:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerCompletion _$PrayerCompletionFromJson(Map<String, dynamic> json) =>
    PrayerCompletion(
      date: json['date'] as String,
      completions: (json['completions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$PrayerTypeEnumMap, k), e as bool),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PrayerCompletionToJson(PrayerCompletion instance) =>
    <String, dynamic>{
      'date': instance.date,
      'completions': instance.completions.map(
        (k, e) => MapEntry(_$PrayerTypeEnumMap[k]!, e),
      ),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PrayerTypeEnumMap = {
  PrayerType.fajr: 'fajr',
  PrayerType.dhuhr: 'dhuhr',
  PrayerType.asr: 'asr',
  PrayerType.maghrib: 'maghrib',
  PrayerType.isha: 'isha',
};

PrayerStreak _$PrayerStreakFromJson(Map<String, dynamic> json) => PrayerStreak(
  currentStreak: (json['currentStreak'] as num).toInt(),
  longestStreak: (json['longestStreak'] as num).toInt(),
  lastCompletionDate: json['lastCompletionDate'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  totalCompleteDays: (json['totalCompleteDays'] as num).toInt(),
);

Map<String, dynamic> _$PrayerStreakToJson(PrayerStreak instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastCompletionDate': instance.lastCompletionDate,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'totalCompleteDays': instance.totalCompleteDays,
    };
