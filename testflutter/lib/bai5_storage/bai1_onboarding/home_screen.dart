// ════════════════════════════════════════════════════════════════
// FILE: bai1_onboarding/home_screen.dart
// LOẠI: Presentation (UI) — màn hình chính sau onboarding
// STORAGE: SharedPreferences — đọc để hiển thị thông tin
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ── Reset onboarding để test lại luồng ─────────────────────────
  Future<void> _resetOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingDone, false); // đặt lại false

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã reset! Đóng và mở lại app để thấy Onboarding.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Màn hình Chính'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Onboarding để test lại',
            onPressed: () => _resetOnboarding(context),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_rounded, size: 80, color: Colors.deepPurple),
            SizedBox(height: 16),
            Text(
              'Bạn đã qua Onboarding rồi!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Lần sau mở app sẽ vào thẳng đây.\n'
              'Nhấn 🔄 ở góc trên phải để reset và test lại.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
