// ════════════════════════════════════════════════════════════════
// FILE: bai1_onboarding/app_startup.dart
// LOẠI: Logic khởi động — kiểm tra SharedPreferences
// STORAGE: SharedPreferences (đọc bool kOnboardingDone)
//
// LUỒNG:
//   Mở app lần đầu  → kOnboardingDone = null/false → OnboardingScreen
//   Mở lần tiếp     → kOnboardingDone = true        → HomeScreen
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  // null = chưa kiểm tra xong, true/false = đã có kết quả
  bool? _onboardingDone;

  @override
  void initState() {
    super.initState();
    _kiemTraOnboarding();
  }

  Future<void> _kiemTraOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    // Nếu key chưa tồn tại, trả về false (lần đầu cài app)
    final done = prefs.getBool(kOnboardingDone) ?? false;
    setState(() => _onboardingDone = done);
  }

  @override
  Widget build(BuildContext context) {
    // Đang đọc SharedPreferences → hiện splash đơn giản
    if (_onboardingDone == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Đã đọc xong → quyết định màn hình nào hiện
    return _onboardingDone! ? const HomeScreen() : const OnboardingScreen();
  }
}
