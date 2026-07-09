// ════════════════════════════════════════════════════════════════
// FILE: bai1_onboarding/onboarding_screen.dart
// LOẠI: Presentation (UI) — KHÔNG phải State Management
// STORAGE: SharedPreferences (local storage — lưu bool đơn giản)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

// Tên key lưu trong SharedPreferences — đặt const tránh typo
const String kOnboardingDone = 'onboarding_done';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // ── Đánh dấu đã xem onboarding rồi chuyển sang HomeScreen ──────
  Future<void> _hoanThanhOnboarding(BuildContext context) async {
    // SharedPreferences: lưu vào bộ nhớ cục bộ của thiết bị
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingDone, true); // lưu true

    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.waving_hand, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Chào mừng!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Đây là màn hình Onboarding.\n'
                'Bạn chỉ thấy màn hình này một lần duy nhất.\n'
                'Lần sau mở app sẽ vào thẳng màn hình chính.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 48),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _hoanThanhOnboarding(context),
                child: const Text(
                  'Bắt đầu ngay!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
