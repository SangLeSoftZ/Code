import '../entities/user_entity.dart';
import '../../core/errors/failures.dart';

/// Abstract contract của AuthRepository — định nghĩa ở Domain layer.
/// Data layer sẽ implement interface này.
abstract class AuthRepository {
  /// Đăng nhập với [username] và [password] (khớp với bảng users trong shop_db).
  /// Thành công → trả về [UserEntity].
  /// Thất bại → trả về [Failure].
  Future<(UserEntity?, Failure?)> login({
    required String username,
    required String password,
  });

  /// Đăng xuất người dùng hiện tại.
  Future<(bool, Failure?)> logout();
}
