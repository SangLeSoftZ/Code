import 'package:flutter/material.dart';
import 'login_page.dart'; // Bài 7
import 'bai3_favorite/favorite_screen.dart'; // Bài 3
import 'bai4_api/task_screen.dart'; // Bài 4

void main() {
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
      // Bài 4 - Gọi Task API
      home: const TaskScreen(),
      // home: const FavoriteScreen(), // Bài 3 - bỏ comment để quay lại
      // home: const LoginPage(),      // Bài 7 - bỏ comment để quay lại
    );
  }
}
