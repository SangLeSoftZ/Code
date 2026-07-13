// ════════════════════════════════════════════════════════════════
// FILE: presentation/login_clean_screen.dart
// LOẠI: Presentation (UI) + LOCAL STORAGE (SecureStorage)
//
// BUG #1 FIX: Sau login thành công → lưu token vào SecureStorage
//   → Tắt app → mở lại → AuthStartup đọc token → vào thẳng ProfileScreen
//
// BUG #2 FIX: Hiển thị lỗi rõ ràng theo từng trường hợp:
//   - Mất mạng       → "Không kết nối được: ..."
//   - Sai password   → "Sai username hoặc mật khẩu"
//   - Tài khoản khoá → "Tài khoản đã bị khóa"
//   - Timeout        → "TimeoutException after ..."
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../injection_container.dart';
import '../domain/usecases/login_usecase.dart';
import '../data/datasources/auth_local_datasource.dart';
import 'profile_screen.dart';

class LoginCleanScreen extends StatefulWidget {
  const LoginCleanScreen({super.key});

  @override
  State<LoginCleanScreen> createState() => _LoginCleanScreenState();
}

class _LoginCleanScreenState extends State<LoginCleanScreen> {
  final _usernameCtrl = TextEditingController(text: 'admin');
  final _passCtrl = TextEditingController(text: '123456');
  final _authLocal = AuthLocalDataSource();

  String? _errorMessage;
  bool _isLoading = false;
  bool _obscurePass = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ── Đăng nhập — gọi API + lưu token ─────────────────────────
  Future<void> _dangNhap() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final loginUseCase = getIt<LoginUseCase>();
    final params = LoginParams(
      username: _usernameCtrl.text.trim(),
      password: _passCtrl.text,
    );

    final (user, failure) = await loginUseCase(params);

    if (!mounted) return;

    if (failure != null) {
      // ── BUG FIX: hiển thị lỗi rõ ràng theo loại failure ─────
      setState(() {
        _isLoading = false;
        _errorMessage = _mapFailureMessage(failure.message);
      });
      return;
    }

    // ── BUG FIX #1: Lưu token vào SecureStorage sau login ──────
    await _authLocal.saveAuthInfo(
      token: user!.token,
      username: user.username,
      role: user.role,
      userId: user.id,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Chuyển sang ProfileScreen, xóa stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
      (route) => false,
    );
  }

  // ── Chuyển message lỗi thành tiếng Việt dễ đọc ──────────────
  String _mapFailureMessage(String raw) {
    if (raw.contains('Sai username') || raw.contains('401')) {
      return '❌ Sai username hoặc mật khẩu';
    }
    if (raw.contains('bị khóa') || raw.contains('403')) {
      return '🔒 Tài khoản đã bị khóa. Liên hệ admin.';
    }
    if (raw.contains('TimeoutException') || raw.contains('timeout')) {
      return '⏱ Kết nối timeout — server phản hồi quá chậm';
    }
    if (raw.contains('SocketException') || raw.contains('Connection refused')) {
      return '📵 Không kết nối được server — kiểm tra WiFi hoặc Spring Boot';
    }
    if (raw.contains('trống') || raw.contains('ít nhất')) {
      return '⚠️ $raw';
    }
    return '❌ $raw';
  }

  // ── Test validation (không cần backend) ─────────────────────
  Future<void> _testValidation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final loginUseCase = getIt<LoginUseCase>();

    final (_, f1) = await loginUseCase(
      const LoginParams(username: '', password: '123456'),
    );
    final (_, f2) = await loginUseCase(
      const LoginParams(username: 'ab', password: '123456'),
    );
    final (_, f3) = await loginUseCase(
      const LoginParams(username: 'admin', password: ''),
    );
    final (_, f4) = await loginUseCase(
      const LoginParams(username: 'admin', password: '123'),
    );

    setState(() {
      _isLoading = false;
      _errorMessage =
          '── Kết quả Validation ──\n'
          '1. Username trống  : $f1\n'
          '2. Username < 3 ký : $f2\n'
          '3. Password trống  : $f3\n'
          '4. Password < 6 ký : $f4';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Logo ─────────────────────────────────────────
                const Icon(
                  Icons.lock_rounded,
                  size: 72,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Đăng nhập',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'User mẫu: admin | user1 | manager\nPassword: 123456',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 28),

                // ── Username ─────────────────────────────────────
                TextField(
                  controller: _usernameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'admin / user1 / manager',
                    prefixIcon: const Icon(Icons.person_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),

                // ── Password ─────────────────────────────────────
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed:
                          () => setState(() => _obscurePass = !_obscurePass),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _dangNhap(),
                ),

                const SizedBox(height: 8),

                // ── Thông báo lỗi ────────────────────────────────
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          _errorMessage!.startsWith('──')
                              ? Colors.blue.shade50
                              : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            _errorMessage!.startsWith('──')
                                ? Colors.blue.shade200
                                : Colors.red.shade200,
                      ),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily:
                            _errorMessage!.startsWith('──')
                                ? 'monospace'
                                : null,
                        color:
                            _errorMessage!.startsWith('──')
                                ? Colors.blue.shade800
                                : Colors.red.shade700,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // ── Nút đăng nhập ────────────────────────────────
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _dangNhap,
                  icon:
                      _isLoading
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.login),
                  label: Text(
                    _isLoading ? 'Đang đăng nhập...' : 'Đăng nhập',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Nút test validation ──────────────────────────
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _testValidation,
                  icon: const Icon(Icons.checklist),
                  label: const Text('Test Validation (không cần backend)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
