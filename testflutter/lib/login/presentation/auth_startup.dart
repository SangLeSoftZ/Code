// ════════════════════════════════════════════════════════════════
// FILE: presentation/auth_startup.dart
// LOẠI: Logic khởi động — kiểm tra token trong SecureStorage
//
// CHECKLIST ITEM: "Đóng app, mở lại → vẫn ở trạng thái đã đăng nhập"
//
// LUỒNG:
//   Mở app → đọc SecureStorage
//   ├─ Có token → ProfileScreen (bỏ qua LoginScreen)
//   └─ Không token → LoginCleanScreen
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../data/datasources/auth_local_datasource.dart';
import 'login_clean_screen.dart';
import 'profile_screen.dart';

class AuthStartup extends StatefulWidget {
  const AuthStartup({super.key});

  @override
  State<AuthStartup> createState() => _AuthStartupState();
}

class _AuthStartupState extends State<AuthStartup> {
  final _authLocal = AuthLocalDataSource();
  bool? _isLoggedIn; // null = đang kiểm tra

  @override
  void initState() {
    super.initState();
    _kiemTraToken();
  }

  Future<void> _kiemTraToken() async {
    final loggedIn = await _authLocal.isLoggedIn();
    setState(() => _isLoggedIn = loggedIn);
  }

  @override
  Widget build(BuildContext context) {
    // Đang đọc SecureStorage
    if (_isLoggedIn == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Có token → vào thẳng ProfileScreen
    if (_isLoggedIn!) {
      return const ProfileScreen();
    }

    // Không có token → vào LoginScreen
    return const LoginCleanScreen();
  }
}
