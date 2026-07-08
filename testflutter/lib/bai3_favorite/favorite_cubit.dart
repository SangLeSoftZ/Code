import 'package:flutter_bloc/flutter_bloc.dart';

/// FavoriteCubit quản lý state yêu thích
/// state: bool - false = chưa yêu thích, true = đã yêu thích
class FavoriteCubit extends Cubit<bool> {
  // Khởi tạo state ban đầu là false (chưa yêu thích)
  FavoriteCubit() : super(false);

  /// Toggle trạng thái yêu thích
  void toggle() {
    emit(!state);
  }
}
