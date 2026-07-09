// GENERATED CODE - DO NOT MODIFY BY HAND
// Thường do `flutter pub run build_runner build` sinh ra tự động.
// Viết tay ở đây để không cần chạy build_runner vẫn compile được.

part of 'task_hive_model.dart';

class TaskHiveModelAdapter extends TypeAdapter<TaskHiveModel> {
  @override
  final int typeId = 0;

  @override
  TaskHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskHiveModel(
      tieuDe:    fields[0] as String,
      moTa:      fields[1] as String,
      trangThai: fields[2] as String,
      taoLuc:    fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TaskHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tieuDe)
      ..writeByte(1)
      ..write(obj.moTa)
      ..writeByte(2)
      ..write(obj.trangThai)
      ..writeByte(3)
      ..write(obj.taoLuc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
