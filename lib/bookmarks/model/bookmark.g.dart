// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkModelAdapter extends TypeAdapter<BookmarkModel> {
  @override
  final int typeId = 0;

  @override
  BookmarkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkModel(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      snippet: fields[3] as String,
      type: fields[4] as BookmarkType,
      reference: fields[5] as String?,
      category: fields[6] as String?,
      createdAt: fields[7] as DateTime,
      metadata: (fields[8] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.snippet)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.reference)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookmarkTypeAdapter extends TypeAdapter<BookmarkType> {
  @override
  final int typeId = 1;

  @override
  BookmarkType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookmarkType.ayah;
      case 1:
        return BookmarkType.dua;
      case 2:
        return BookmarkType.hadith;
      case 3:
        return BookmarkType.other;
      default:
        return BookmarkType.ayah;
    }
  }

  @override
  void write(BinaryWriter writer, BookmarkType obj) {
    switch (obj) {
      case BookmarkType.ayah:
        writer.writeByte(0);
        break;
      case BookmarkType.dua:
        writer.writeByte(1);
        break;
      case BookmarkType.hadith:
        writer.writeByte(2);
        break;
      case BookmarkType.other:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
