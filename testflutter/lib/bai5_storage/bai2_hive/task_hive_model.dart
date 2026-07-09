// ════════════════════════════════════════════════════════════════
// FILE: bai2_hive/task_hive_model.dart
// LOẠI: LOCAL STORAGE MODEL — Hive TypeAdapter
// PHÂN BIỆT:
//   • task_model.dart (bai4_api/)  → dùng cho API (fromJson/toJson)
//   • TaskHiveModel (file này)     → dùng cho Hive (local DB offline)
// ════════════════════════════════════════════════════════════════
import 'package:hive/hive.dart';

part 'task_hive_model.g.dart'; // file này do build_runner tự sinh

// typeId phải duy nhất trong toàn app — mỗi @HiveType một số khác nhau
@HiveType(typeId: 0)
class TaskHiveModel extends HiveObject {
  @HiveField(0)
  late String tieuDe;

  @HiveField(1)
  late String moTa;

  @HiveField(2)
  late String trangThai; // 'CHUA_XONG' | 'DANG_LAM' | 'HOAN_THANH'

  @HiveField(3)
  late DateTime taoLuc;

  // Constructor
  TaskHiveModel({
    required this.tieuDe,
    this.moTa = '',
    this.trangThai = 'CHUA_XONG',
    DateTime? taoLuc,
  }) : taoLuc = taoLuc ?? DateTime.now();

  @override
  String toString() => 'TaskHive(tieuDe: $tieuDe, trangThai: $trangThai)';
}
