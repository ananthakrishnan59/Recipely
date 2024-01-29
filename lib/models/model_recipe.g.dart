// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipesAdapter extends TypeAdapter<Recipes> {
  @override
  final int typeId = 1;

  @override
  Recipes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipes(
      id: fields[9] as String?,
      timeKey: fields[7] as String?,
      title: fields[0] as String,
      description: fields[1] as String,
      photo: (fields[2] as List).cast<String>(),
      category: fields[3] as String,
      procedure: fields[4] as String,
      incredients: fields[5] as String,
      time: fields[6] as int,
      favoritesUserIds: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipes obj) {
    writer
      ..writeByte(10)
      ..writeByte(9)
      ..write(obj.id)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.photo)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.procedure)
      ..writeByte(5)
      ..write(obj.incredients)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.timeKey)
      ..writeByte(8)
      ..write(obj.favoritesUserIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
