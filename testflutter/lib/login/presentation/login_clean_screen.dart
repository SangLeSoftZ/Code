import 'package:flutter/material.dart';

import '../injection_container.dart';
import '../domain/usecases/login_usecase.dart';

/// Màn hình demo Clean Architecture — login với bảng users trong shop_db.
/// User mẫu: admin / 123456 | user1 / 123456 | manager / 123456
class LoginCleanScreen extends StatefulWidget {
  const LoginCleanScreen({super.key});

  @override
  State<LoginCleanScreen> createState() => _LoginCleanScreenState();
}

class _LoginCleanScreenState extends State<LoginCleanScreen> {
  // Điền sẵn user mẫu từ DB cho tiện test
  final _usernameCtrl = TextEditingController(text: 'admin');
  final _passCtrl = TextEditingController(text: '123456');

  String _result = 'Chưa gọi UseCase';
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ── Gọi UseCase thật (cần Spring Boot đang chạy) ────────────────────

  Future<void> _callUseCase() async {
    setState(() {
      _isLoading = true;
      _result = 'Đang gọi API...';
    });

    final loginUseCase = getIt<LoginUseCase>();
    debugPrint('[DI] LoginUseCase instance: $loginUseCase');

    final params = LoginParams(
      username: _usernameCtrl.text.trim(),
      password: _passCtrl.text,
    );

    final (user, failure) = await loginUseCase(params);

    setState(() {
      _isLoading = false;
      if (failure != null) {
        _result = '❌ Lỗi: $failure';
      } else {
        _result =
            '✅ Đăng nhập thành công!\n\n'
            'id       : ${user!.id}\n'
            'username : ${user.username}\n'
            'email    : ${user.email}\n'
            'role     : ${user.role}\n'
            'active   : ${user.active}\n'
            'token    : ${user.token.isEmpty ? "(server chưa trả token)" : user.token}';
      }
    });
  }

  // ── Test validation (không cần backend) ─────────────────────────────

  Future<void> _testValidation() async {
    setState(() {
      _isLoading = true;
      _result = 'Đang kiểm tra validation...';
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
      _result =
          '── Kết quả Validation ──\n\n'
          '1. Username trống  : $f1\n'
          '2. Username < 3 ký : $f2\n'
          '3. Password trống  : $f3\n'
          '4. Password < 6 ký : $f4\n\n'
          '✅ getIt<LoginUseCase>() hoạt động bình thường!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture — Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Thông tin luồng DI ─────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                'Luồng DI:\n'
                'getIt<LoginUseCase>()\n'
                '  → LoginUseCase(AuthRepository)\n'
                '  → AuthRepositoryImpl(AuthRemoteDataSource)\n'
                '  → AuthRemoteDataSourceImpl(http.Client)\n\n'
                'User mẫu: admin | user1 | manager\n'
                'Password: 123456',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),

            const SizedBox(height: 16),

            // ── Input: Username ────────────────────────────────────
            TextField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'admin / user1 / manager',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outlined),
              ),
            ),
            const SizedBox(height: 8),

            // ── Input: Password ────────────────────────────────────
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: '123456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outlined),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 12),

            // ── Buttons ────────────────────────────────────────────
            FilledButton.icon(
              onPressed: _isLoading ? null : _callUseCase,
              icon: const Icon(Icons.login),
              label: const Text('Đăng nhập (gọi API Spring Boot)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _testValidation,
              icon: const Icon(Icons.checklist),
              label: const Text('Test Validation (không cần backend)'),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // ── Kết quả ────────────────────────────────────────────
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _result,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
