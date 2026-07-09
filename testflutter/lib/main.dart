// ════════════════════════════════════════════════════════════════
// main.dart — Điểm khởi động toàn app
//
// PHÂN BIỆT CÁC KHÁI NIỆM TRONG FILE NÀY:
//
// ┌─────────────────────────────────────────────────────────────┐
// │  STATE MANAGEMENT (flutter_bloc / get_it)                   │
// │  → Quản lý trạng thái UI trong RAM (mất khi tắt app)        │
// │  → File: *_cubit.dart, *_bloc.dart, injection_container.dart│
// ├─────────────────────────────────────────────────────────────┤
// │  LOCAL STORAGE (Hive / SharedPreferences)                   │
// │  → Lưu dữ liệu xuống ổ đĩa (còn lại sau khi tắt app)       │
// │  → File: task_hive_model.dart, SharedPreferences key        │
// └─────────────────────────────────────────────────────────────┘
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testflutter/bai5_storage/bai3_multi_bloc/multi_bloc_demo_screen.dart';

// ── State Management ─────────────────────────────────────────────
import 'login/injection_container.dart'; // get_it setup
import 'bai3_favorite/favorite_cubit.dart'; // Cubit (State Mgmt)

// ── Screens ──────────────────────────────────────────────────────
import 'bai3_favorite/favorite_screen.dart';
import 'bai4_api/task_screen.dart';
import 'login/presentation/login_clean_screen.dart';
import 'login_page.dart';

// ── Bài 1: SharedPreferences Onboarding ─────────────────────────
import 'bai5_storage/bai1_onboarding/app_startup.dart';

// ── Bài 2: Hive Local Storage ────────────────────────────────────
import 'bai5_storage/bai2_hive/task_hive_model.dart';
import 'bai5_storage/bai2_hive/hive_task_screen.dart';

void main() async {
  // Bắt buộc khi có async trong main trước runApp
  WidgetsFlutterBinding.ensureInitialized();

  // ── LOCAL STORAGE: Khởi tạo Hive ────────────────────────────────
  // initFlutter() tìm đường dẫn lưu file phù hợp với từng platform
  await Hive.initFlutter();

  // Đăng ký TypeAdapter — Hive cần biết cách đọc/ghi TaskHiveModel
  Hive.registerAdapter(TaskHiveModelAdapter());

  // Mở Box trước khi app chạy — giống "mở kết nối DB"
  await Hive.openBox<TaskHiveModel>(kTaskBox);

  // ── STATE MANAGEMENT: Setup get_it ──────────────────────────────
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
      // ── Bài 1: Onboarding — AppStartup kiểm tra SharedPreferences
      //home: const AppStartup(),
      //home: const MultiBlocDemoScreen(),
      //home: const HiveTaskScreen(),
      home: const AppStartup(),
      // ── Đổi home để chạy bài khác ────────────────────────────────
      // home: const HiveTaskScreen(),    // Bài 2 — Hive local storage
      // home: const LoginCleanScreen(),  // Clean Architecture + get_it
      // home: const TaskScreen(),        // Bài 4 — API call
      // home: const FavoriteScreen(),    // Bài 3 — Bloc/Cubit
      // home: const LoginPage(),         // Bài cũ
    );
  }
}
