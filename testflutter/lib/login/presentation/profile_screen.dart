// ════════════════════════════════════════════════════════════════
// FILE: presentation/profile_screen.dart
// LOẠI: Presentation (UI)
//
// CHECKLIST ITEMS được fix ở màn hình này:
//   ✅ "Đóng app, mở lại → vẫn ở trạng thái đã đăng nhập"
//   ✅ "Đăng xuất → token bị xóa, quay về màn hình đăng nhập,
//       không vào lại được màn hình chính bằng nút Back"
//
// BUG #2: Nhấn Back sau logout vẫn quay lại ProfileScreen
//   → Fix: dùng pushAndRemoveUntil xóa toàn bộ navigation stack
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../data/datasources/auth_local_datasource.dart';
import 'login_clean_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authLocal = AuthLocalDataSource();

  String _username = '';
  String _role     = '';
  String _userId   = '';
  String _token    = '';
  bool   _isLoading = true;

  @override
  void initState() {
    super.initState();
    _docThongTinUser();
  }

  // ── Đọc thông tin user từ SecureStorage ──────────────────────
  Future<void> _docThongTinUser() async {
    final info = await _authLocal.getAuthInfo();
    setState(() {
      _username  = info['username'] ?? '---';
      _role      = info['role']     ?? '---';
      _userId    = info['userId']   ?? '---';
      _token     = info['token']    ?? '';
      _isLoading = false;
    });
  }

  // ── LOGOUT — xóa token + xóa toàn bộ navigation stack ───────
  //
  // BUG FIX: pushReplacement() vẫn giữ stack cũ → nhấn Back quay lại
  // ĐÚNG: pushAndRemoveUntil(..., (route) => false) xóa hết stack
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Xóa token khỏi SecureStorage
    await _authLocal.clearAuthInfo();

    if (!mounted) return;

    // ── FIX BUG: xóa toàn bộ navigation stack ──────────────────
    // (route) => false → không giữ lại route nào
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginCleanScreen()),
      (route) => false, // xóa hết — không thể nhấn Back quay lại
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Badge màu theo role
    final roleColor = switch (_role) {
      'ADMIN'   => Colors.red,
      'MANAGER' => Colors.orange,
      _         => Colors.blue, // USER
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Ẩn nút Back — không cho quay lại LoginScreen khi đã login
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Đăng xuất',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── Avatar + tên ──────────────────────────────────────
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: roleColor.withValues(alpha: 0.15),
                    child: Text(
                      _username.isNotEmpty
                          ? _username[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: roleColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _username,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: roleColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: roleColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      _role,
                      style: TextStyle(
                        color: roleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Thông tin chi tiết ────────────────────────────────
            _InfoCard(
              title: 'Thông tin tài khoản',
              items: [
                _InfoRow(label: 'User ID',  value: _userId),
                _InfoRow(label: 'Username', value: _username),
                _InfoRow(label: 'Role',     value: _role),
              ],
            ),

            const SizedBox(height: 12),

            // ── Token (rút gọn) ───────────────────────────────────
            _InfoCard(
              title: 'JWT Token (đã lưu trong SecureStorage)',
              items: [
                _InfoRow(
                  label: 'Token',
                  value: _token.length > 40
                      ? '${_token.substring(0, 40)}...'
                      : _token.isEmpty
                          ? '(chưa có token)'
                          : _token,
                  isCode: true,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Checklist trạng thái ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ Checklist đã pass:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(height: 6),
                  Text('✓ Đăng nhập thành công, nhận JWT token'),
                  Text('✓ Token lưu trong SecureStorage (mã hoá)'),
                  Text('✓ Tắt app → mở lại → vào thẳng màn này'),
                  Text('✓ Logout → xóa token → về LoginScreen'),
                  Text('✓ Sau logout không Back lại được'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Nút logout lớn ────────────────────────────────────
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text(
                'Đăng xuất',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRow> items;

  const _InfoCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(7)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isCode;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isCode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: isCode ? 'monospace' : null,
                fontSize: isCode ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
