// ════════════════════════════════════════════════════════════════
// FILE: bai3_multi_bloc/theme_cubit.dart
// LOẠI: STATE MANAGEMENT (Bloc/Cubit)
// state = bool isDark — chỉ tồn tại trong RAM.
// Nếu muốn nhớ theme sau khi tắt app → cần SharedPreferences.
// ════════════════════════════════════════════════════════════════
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false = light mode mặc định

  void toggleTheme() => emit(!state);
  void setDark()     => emit(true);
  void setLight()    => emit(false);
}
