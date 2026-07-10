// ════════════════════════════════════════════════════════════════
// FILE: lib/bai6_test/task_cubit/task_cubit.dart
// LOẠI: STATE MANAGEMENT — Cubit
//
// TaskCubit quản lý trạng thái danh sách Task.
// Nhận TaskRepository qua constructor (Dependency Injection)
// → Khi test: inject MockTaskRepository
// → Khi chạy thật: inject TaskRepositoryImpl
//
// Luồng state khi gọi layDanhSach():
//   TaskInitial → TaskLoading → TaskLoaded  (thành công)
//   TaskInitial → TaskLoading → TaskError   (thất bại)
// ════════════════════════════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_repository.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _repository;

  /// DI qua constructor — dễ mock trong test
  TaskCubit(this._repository) : super(TaskInitial());

  /// Tải danh sách task từ repository.
  /// Emit [TaskLoading] trước, sau đó emit [TaskLoaded] hoặc [TaskError].
  Future<void> layDanhSach() async {
    emit(TaskLoading()); // ← state 1: đang tải

    try {
      final tasks = await _repository.layDanhSachTask();
      emit(TaskLoaded(tasks)); // ← state 2a: tải thành công
    } catch (e) {
      emit(TaskError(e.toString())); // ← state 2b: tải thất bại
    }
  }

  /// Tạo task mới rồi reload danh sách.
  Future<void> taoTask(String tieuDe) async {
    emit(TaskLoading());

    try {
      await _repository.taoTask(tieuDe);
      // Sau khi tạo xong → tải lại danh sách mới
      final tasks = await _repository.layDanhSachTask();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
