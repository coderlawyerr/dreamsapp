// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ruya_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RuyaModelAdapter extends TypeAdapter<RuyaModel> {
  @override
  final int typeId = 0;

  @override
  RuyaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RuyaModel(
      baslik: fields[0] as String,
      icerik: fields[1] as String,
      kategori: fields[2] as String,
      tarih: fields[3] as String,
      yorum: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RuyaModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.baslik)
      ..writeByte(1)
      ..write(obj.icerik)
      ..writeByte(2)
      ..write(obj.kategori)
      ..writeByte(3)
      ..write(obj.tarih)
      ..writeByte(4)
      ..write(obj.yorum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuyaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
