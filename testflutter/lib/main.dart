import 'package:flutter/material.dart';
import 'login_page.dart'; // Bài 7
import 'bai3_favorite/favorite_screen.dart'; // Bài 3
import 'bai4_api/task_screen.dart'; // Bài 4
import 'login/injection_container.dart'; // Bài Clean Architecture
import 'login/presentation/login_clean_screen.dart'; // Bài Clean Architecture

void main() {
  // Khởi tạo tất cả dependency trước khi chạy app
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bai Tap Bloc/Cubit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Bài Clean Architecture + get_it
      home: const LoginCleanScreen(),
      // home: const TaskScreen(),    // Bài 4 - bỏ comment để quay lại
      // home: const FavoriteScreen(), // Bài 3 - bỏ comment để quay lại
      // home: const LoginPage(),      // Bài 7 - bỏ comment để quay lại
    );
  }
}
