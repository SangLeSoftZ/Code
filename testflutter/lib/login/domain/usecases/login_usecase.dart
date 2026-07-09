import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/errors/failures.dart';

/// Params chứa dữ liệu đầu vào cho LoginUseCase.
/// Dùng username thay email vì bảng users trong shop_db xác thực qua username.
class LoginParams {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});
}

/// UseCase xử lý nghiệp vụ đăng nhập.
///
/// Quy tắc Clean Architecture:
///   - UseCase chỉ biết đến [AuthRepository] (abstract) — không biết impl.
///   - UseCase KHÔNG chứa logic UI hay logic network.
///   - Mọi validate nghiệp vụ viết ở đây.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Thực thi đăng nhập.
  /// Trả về [UserEntity] nếu thành công, [Failure] nếu thất bại.
  Future<(UserEntity?, Failure?)> call(LoginParams params) async {
    // ── Validate nghiệp vụ ───────────────────────────────────────────
    if (params.username.trim().isEmpty) {
      return (null, const ValidationFailure('Username không được để trống'));
    }
    if (params.username.trim().length < 3) {
      return (
        null,
        const ValidationFailure('Username phải có ít nhất 3 ký tự'),
      );
    }
    if (params.password.isEmpty) {
      return (null, const ValidationFailure('Mật khẩu không được để trống'));
    }
    if (params.password.length < 6) {
      return (
        null,
        const ValidationFailure('Mật khẩu phải có ít nhất 6 ký tự'),
      );
    }

    // ── Gọi repository ───────────────────────────────────────────────
    return _repository.login(
      username: params.username.trim(),
      password: params.password,
    );
  }
}
