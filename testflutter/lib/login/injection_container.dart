import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_usecase.dart';

/// Instance toàn cục của GetIt — dùng xuyên suốt app.
final GetIt getIt = GetIt.instance;

/// Đăng ký toàn bộ dependency cho tính năng Login.
///
/// Thứ tự đăng ký: External → DataSource → Repository → UseCase
///
/// Các loại đăng ký:
///   registerLazySingleton  → tạo 1 lần, dùng lại mãi (singleton lười)
///   registerFactory        → tạo mới mỗi lần gọi getIt[T]()
///   registerSingleton      → tạo ngay khi gọi setupLocator()
void setupLocator() {
  // ── External packages ──────────────────────────────────────────────
  // http.Client dùng chung cho toàn app, chỉ cần 1 instance
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // ── Data Sources ───────────────────────────────────────────────────
  // AuthRemoteDataSourceImpl nhận http.Client qua constructor
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: getIt<http.Client>()),
  );

  // ── Repositories ───────────────────────────────────────────────────
  // Đăng ký theo INTERFACE (AuthRepository), inject IMPL (AuthRepositoryImpl)
  // → Domain chỉ biết interface, không biết implementation cụ thể
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  // ── Use Cases ──────────────────────────────────────────────────────
  // LoginUseCase là logic nghiệp vụ — dùng factory để mỗi lần là instance mới
  getIt.registerFactory<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
}
