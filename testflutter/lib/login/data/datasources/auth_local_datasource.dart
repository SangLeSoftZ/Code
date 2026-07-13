// ════════════════════════════════════════════════════════════════
// FILE: data/datasources/auth_local_datasource.dart
// LOẠI: LOCAL STORAGE — flutter_secure_storage
//
// PHÂN BIỆT với SharedPreferences:
//   SharedPreferences  → lưu plain text (ai có device đọc được)
//   SecureStorage      → mã hoá bằng Keystore (Android) / Keychain (iOS)
//                        phù hợp để lưu JWT token, password, secret key
//
// BUG #1 từ checklist: "Đóng app, mở lại → vẫn ở trạng thái đã đăng nhập"
//   → Fix: lưu token vào SecureStorage sau login,
//          đọc lại token khi khởi động để quyết định màn hình nào hiện
// ════════════════════════════════════════════════════════════════

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Keys lưu trong SecureStorage
const String kTokenKey    = 'auth_token';
const String kUsernameKey = 'auth_username';
const String kRoleKey     = 'auth_role';
const String kUserIdKey   = 'auth_user_id';

class AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthLocalDataSource({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  // ── GHI token sau khi login thành công ────────────────────────
  Future<void> saveAuthInfo({
    required String token,
    required String username,
    required String role,
    required String userId,
  }) async {
    await Future.wait([
      _storage.write(key: kTokenKey,    value: token),
      _storage.write(key: kUsernameKey, value: username),
      _storage.write(key: kRoleKey,     value: role),
      _storage.write(key: kUserIdKey,   value: userId),
    ]);
  }

  // ── ĐỌC token (dùng để gắn vào Authorization header) ─────────
  Future<String?> getToken() => _storage.read(key: kTokenKey);

  // ── ĐỌC toàn bộ thông tin user đã lưu ────────────────────────
  Future<Map<String, String?>> getAuthInfo() async {
    final results = await Future.wait([
      _storage.read(key: kTokenKey),
      _storage.read(key: kUsernameKey),
      _storage.read(key: kRoleKey),
      _storage.read(key: kUserIdKey),
    ]);
    return {
      'token':    results[0],
      'username': results[1],
      'role':     results[2],
      'userId':   results[3],
    };
  }

  // ── KIỂM TRA đã đăng nhập chưa ───────────────────────────────
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── XÓA token khi logout ─────────────────────────────────────
  Future<void> clearAuthInfo() async {
    await Future.wait([
      _storage.delete(key: kTokenKey),
      _storage.delete(key: kUsernameKey),
      _storage.delete(key: kRoleKey),
      _storage.delete(key: kUserIdKey),
    ]);
  }
}
