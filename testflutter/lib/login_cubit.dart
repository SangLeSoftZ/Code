import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────
// 1. ĐỊNH NGHĨA CÁC LOẠI STATE
// ─────────────────────────────────────────────

// Lớp cha (abstract/sealed) — đại diện cho tất cả trạng thái đăng nhập
abstract class LoginState {}

// Trạng thái khởi đầu — chưa làm gì cả
class LoginInitial extends LoginState {}

// Đang xử lý — đang chờ API phản hồi
class LoginLoading extends LoginState {}

// Đăng nhập thành công
class LoginSuccess extends LoginState {}

// Đăng nhập thất bại — kèm thông báo lỗi
class LoginFailure extends LoginState {
  final String loi; // Thông báo lỗi trả về cho UI

  LoginFailure(this.loi);
}

// ─────────────────────────────────────────────
// 2. ĐỊNH NGHĨA CUBIT
// ─────────────────────────────────────────────

class LoginCubit extends Cubit<LoginState> {
  // Khởi tạo Cubit với state ban đầu là LoginInitial
  LoginCubit() : super(LoginInitial());

  /// Hàm xử lý đăng nhập
  /// [user] : tên tài khoản người dùng nhập
  /// [pass] : mật khẩu người dùng nhập
  Future<void> dangNhap(String user, String pass) async {
    // Bước 1: Phát state "đang tải" → UI hiển thị loading indicator
    emit(LoginLoading());

    // Bước 2: Giả lập độ trễ mạng 1 giây (thực tế là gọi API ở đây)
    await Future.delayed(const Duration(seconds: 1));

    // Bước 3: Kiểm tra thông tin đăng nhập
    if (user == 'admin' && pass == '123') {
      // Đúng tài khoản → phát LoginSuccess
      emit(LoginSuccess());
    } else {
      // Sai tài khoản → phát LoginFailure kèm thông báo lỗi
      emit(LoginFailure('Sai tài khoản'));
    }
  }

  /// Reset về trạng thái ban đầu (dùng khi người dùng muốn thử lại)
  void reset() {
    emit(LoginInitial());
  }
}
