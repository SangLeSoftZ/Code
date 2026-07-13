// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ── State Management ─────────────────────────────────────────────
import 'login/injection_container.dart';

// ── Bài 2: Hive ──────────────────────────────────────────────────
import 'bai5_storage/bai2_hive/task_hive_model.dart';
import 'bai5_storage/bai2_hive/hive_task_screen.dart';

// ── Bài 1: Onboarding ────────────────────────────────────────────
import 'bai5_storage/bai1_onboarding/app_startup.dart';

// ── Bài 3: MultiBlocProvider ─────────────────────────────────────
import 'bai5_storage/bai3_multi_bloc/multi_bloc_demo_screen.dart';

// ── Bài 3 cũ: FavoriteScreen ─────────────────────────────────────
import 'bai3_favorite/favorite_screen.dart';

// ── Bài 4: Task API ───────────────────────────────────────────────
import 'bai4_api/task_screen.dart';

// ── Login cũ ─────────────────────────────────────────────────────
import 'login_page.dart';

// ── Bài 4+5: Auth flow hoàn chỉnh (AuthStartup + Profile) ────────
import 'login/presentation/auth_startup.dart';
import 'login/presentation/login_clean_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskHiveModelAdapter());
  await Hive.openBox<TaskHiveModel>(kTaskBox);

  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bai Tap Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // ══════════════════════════════════════════════════════════
      // ĐỔI DÒNG home: bên dưới để chạy từng bài
      // Chỉ bỏ comment 1 dòng, các dòng còn lại giữ nguyên
      // ══════════════════════════════════════════════════════════

      // ── Bài 4+5: Auth flow hoàn chỉnh (đang bật) ─────────────
      home: const AuthStartup(),

      // ── Bài 5 storage: Onboarding SharedPreferences ───────────
      // home: const AppStartup(),

      // ── Bài 5 storage: Hive Task CRUD ─────────────────────────
      // home: const HiveTaskScreen(),

      // ── Bài 5 storage: MultiBlocProvider demo ─────────────────
      // home: const MultiBlocDemoScreen(),

      // ── Bài 4: Task API (gọi Spring Boot) ─────────────────────
      // home: const TaskScreen(),

      // ── Bài 3: FavoriteScreen (Bloc/Cubit) ────────────────────
      // home: const FavoriteScreen(),

      // ── Clean Architecture + get_it (không có token flow) ─────
      // home: const LoginCleanScreen(),

      // ── Login cũ (bài đầu) ────────────────────────────────────
      // home: const LoginPage(),
    );
  }
}
