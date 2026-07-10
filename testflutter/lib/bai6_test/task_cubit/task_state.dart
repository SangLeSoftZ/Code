// ════════════════════════════════════════════════════════════════
// FILE: lib/bai6_test/task_cubit/task_state.dart
// LOẠI: State class cho TaskCubit
//
// Cấu trúc sealed class — mỗi subclass là 1 trạng thái rõ ràng:
//   TaskInitial  → chưa làm gì (state ban đầu)
//   TaskLoading  → đang gọi API/repository
//   TaskLoaded   → tải xong, có dữ liệu
//   TaskError    → tải thất bại, có thông báo lỗi
//
// Test sẽ kiểm tra đúng thứ tự emit: [TaskLoading, TaskLoaded]
// hoặc [TaskLoading, TaskError]
// ════════════════════════════════════════════════════════════════

import '../../bai4_api/task_model.dart';

/// State cơ sở — dùng abstract để không ai tạo trực tiếp
abstract class TaskState {}

/// Trạng thái ban đầu khi Cubit vừa được khởi tạo
class TaskInitial extends TaskState {}

/// Đang tải dữ liệu — UI hiển thị loading spinner
class TaskLoading extends TaskState {}

/// Tải thành công — UI hiển thị danh sách task
class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded(this.tasks);

  // Cần override == để blocTest so sánh đúng
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskLoaded &&
          runtimeType == other.runtimeType &&
          tasks.length == other.tasks.length;

  @override
  int get hashCode => tasks.hashCode;
}

/// Tải thất bại — UI hiển thị thông báo lỗi
class TaskError extends TaskState {
  final String message;
  TaskError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
