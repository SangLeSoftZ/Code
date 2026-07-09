/// Lớp cơ sở đại diện cho các loại lỗi trong ứng dụng.
/// Domain layer dùng Failure thay vì ném Exception trực tiếp.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Lỗi kết nối mạng (timeout, không có internet, v.v.)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Lỗi từ server (sai tài khoản/mật khẩu, 401, 403, v.v.)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Lỗi dữ liệu cache / local storage
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Lỗi xác thực đầu vào (email sai định dạng, mật khẩu quá ngắn, v.v.)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
