import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/auth_remote_datasource.dart';

/// Triển khai [AuthRepository] ở Data layer.
///
/// Nhiệm vụ:
///   - Gọi [AuthRemoteDataSource] để lấy dữ liệu thô.
///   - Bắt Exception từ data source, chuyển thành [Failure] cho Domain.
///   - Domain layer CHỈ thấy [AuthRepository] abstract.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<(UserEntity?, Failure?)> login({
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(
        username: username,
        password: password,
      );
      return (userModel, null);
    } on Exception catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      if (msg.contains('Sai username') || msg.contains('401')) {
        return (null, ServerFailure(msg));
      }
      if (msg.contains('vô hiệu hoá') || msg.contains('403')) {
        return (null, ServerFailure(msg));
      }
      return (null, NetworkFailure('Không kết nối được: $msg'));
    }
  }

  @override
  Future<(bool, Failure?)> logout() async {
    try {
      return (true, null);
    } on Exception catch (e) {
      return (false, ServerFailure(e.toString()));
    }
  }
}
