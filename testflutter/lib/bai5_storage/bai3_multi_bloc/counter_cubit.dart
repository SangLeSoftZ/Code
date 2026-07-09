// ════════════════════════════════════════════════════════════════
// FILE: bai3_multi_bloc/counter_cubit.dart
// LOẠI: STATE MANAGEMENT (Bloc/Cubit)
// Dữ liệu chỉ tồn tại trong RAM — mất khi tắt app.
// Muốn lưu lại phải dùng Hive hoặc SharedPreferences.
// ════════════════════════════════════════════════════════════════
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state > 0 ? state - 1 : 0);
  void reset()     => emit(0);
}
