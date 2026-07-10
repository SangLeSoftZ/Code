// ════════════════════════════════════════════════════════════════
// FILE: lib/bai6_test/task_cubit/task_repository.dart
// LOẠI: Abstract Repository (Domain layer)
//
// TẠI SAO PHẢI CÓ FILE NÀY?
//   - TaskCubit chỉ phụ thuộc vào INTERFACE này (không biết impl cụ thể)
//   - Trong test, mocktail sẽ tạo MockTaskRepository implements file này
//   - Đây chính là "cổng" để inject dependency khi test
//
// PHÂN BIỆT:
//   lib/bai4_api/api_client.dart  → gọi HTTP thật (không dùng trong test)
//   TaskRepository (file này)     → abstract contract, mock dễ dàng
// ════════════════════════════════════════════════════════════════

import '../../bai4_api/task_model.dart';

abstract class TaskRepository {
  /// Lấy toàn bộ danh sách task.
  /// Thành công → [List<Task>]
  /// Thất bại   → ném [Exception]
  Future<List<Task>> layDanhSachTask();

  /// Tạo task mới.
  /// Thành công → [Task] vừa tạo (có id từ server)
  /// Thất bại   → ném [Exception]
  Future<Task> taoTask(String tieuDe);
}
