import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

/// Abstract contract cho remote data source.
/// Cho phép mock dễ dàng khi viết test.
abstract class AuthRemoteDataSource {
  /// Gọi API đăng nhập bằng [username] và [password].
  /// Thành công → trả về [UserModel].
  /// Thất bại  → ném [Exception] (AuthRepositoryImpl sẽ bắt và đổi thành Failure).
  Future<UserModel> login({required String username, required String password});
}

/// Triển khai thực tế — gọi HTTP tới Spring Boot backend.
///
/// Spring Boot endpoint: POST /api/auth/login
/// Request body: { "username": "...", "password": "..." }
/// Response:     { "id": 1, "username": "...", "email": "...",
///                 "role": "ADMIN", "active": true, "token": "..." }
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Emulator Android dùng 10.0.2.2 thay cho localhost của máy host
  static const String _baseUrl = 'http://10.0.2.2:8080/api';

  final http.Client _client;

  AuthRemoteDataSourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/login');

    final response = await _client
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          // Gửi username + password khớp với bảng users trong shop_db
          body: jsonEncode({'username': username, 'password': password}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return UserModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else if (response.statusCode == 401) {
      throw Exception('Sai username hoặc mật khẩu');
    } else if (response.statusCode == 403) {
      throw Exception('Tài khoản bị vô hiệu hoá (active = false)');
    } else {
      throw Exception('Lỗi server: ${response.statusCode} — ${response.body}');
    }
  }
}
