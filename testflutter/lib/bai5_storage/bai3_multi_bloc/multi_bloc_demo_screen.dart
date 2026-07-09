// ════════════════════════════════════════════════════════════════
// FILE: bai3_multi_bloc/multi_bloc_demo_screen.dart
// LOẠI: STATE MANAGEMENT — MultiBlocProvider
//
// VẤN ĐỀ TRƯỚC (BlocProvider lồng nhau — BAD):
//   BlocProvider<CounterCubit>(
//     create: (_) => CounterCubit(),
//     child: BlocProvider<ThemeCubit>(
//       create: (_) => ThemeCubit(),
//       child: BlocProvider<FavoriteCubit>(
//         create: (_) => FavoriteCubit(),
//         child: MyScreen(),   ← 3 lớp lồng nhau, khó đọc
//       ),
//     ),
//   )
//
// GIẢI PHÁP (MultiBlocProvider — GOOD):
//   MultiBlocProvider(
//     providers: [...],   ← phẳng, dễ đọc, dễ thêm/bớt
//     child: MyScreen(),
//   )
//
// PHÂN BIỆT STATE MANAGEMENT vs LOCAL STORAGE:
//   State Mgmt → CounterCubit, ThemeCubit, FavoriteCubit
//               (giá trị mất khi tắt app)
//   Local Storage → SharedPreferences, Hive
//               (giá trị còn sau khi tắt app)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_cubit.dart';
import 'theme_cubit.dart';
import '../../bai3_favorite/favorite_cubit.dart';

// ── Entry point cho màn hình này — setup MultiBlocProvider ───────

class MultiBlocDemoScreen extends StatelessWidget {
  const MultiBlocDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ════════════════════════════════════════════════════════════
    // BÀI 3: MultiBlocProvider
    // Thay vì lồng BlocProvider, dùng danh sách providers phẳng.
    // ════════════════════════════════════════════════════════════
    return MultiBlocProvider(
      providers: [
        // [STATE MANAGEMENT] CounterCubit — đếm số, mất khi tắt app
        BlocProvider<CounterCubit>(create: (_) => CounterCubit()),
        // [STATE MANAGEMENT] ThemeCubit — dark/light mode, mất khi tắt
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        // [STATE MANAGEMENT] FavoriteCubit — list yêu thích trong RAM
        BlocProvider<FavoriteCubit>(create: (_) => FavoriteCubit()),
      ],
      child: const _MultiBlocBody(),
    );
  }
}

// ── Body: dùng cả 3 Cubit trong 1 widget tree phẳng ─────────────

class _MultiBlocBody extends StatelessWidget {
  const _MultiBlocBody();

  @override
  Widget build(BuildContext context) {
    // Đọc ThemeCubit để đổi màu nền
    final isDark = context.watch<ThemeCubit>().state;
    final count = context.watch<CounterCubit>().state;
    final favs = context.watch<FavoriteCubit>().state;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        title: const Text('MultiBlocProvider Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Nút đổi theme (ThemeCubit)
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Đổi theme (ThemeCubit)',
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Nhãn giải thích ─────────────────────────────────
            _InfoBox(
              title: 'STATE MANAGEMENT',
              subtitle: 'Dữ liệu trong RAM — mất khi tắt app',
              color: Colors.blue,
              icon: Icons.memory,
            ),
            const SizedBox(height: 16),

            // ── CounterCubit ─────────────────────────────────────
            _SectionCard(
              label: 'CounterCubit',
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => context.read<CounterCubit>().decrement(),
                    iconSize: 32,
                  ),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => context.read<CounterCubit>().increment(),
                    iconSize: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── ThemeCubit ───────────────────────────────────────
            _SectionCard(
              label: 'ThemeCubit',
              color: Colors.purple,
              child: ListTile(
                leading: Icon(
                  isDark ? Icons.nightlight_round : Icons.wb_sunny,
                  color: isDark ? Colors.yellow : Colors.orange,
                ),
                title: Text(
                  isDark ? 'Dark Mode đang bật' : 'Light Mode đang bật',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── FavoriteCubit ────────────────────────────────────
            _SectionCard(
              label: 'FavoriteCubit',
              color: Colors.red,
              child: ListTile(
                leading: Icon(
                  favs ? Icons.favorite : Icons.favorite_border,
                  color: favs ? Colors.red : Colors.grey,
                ),
                title: Text(
                  favs ? 'Đã thêm vào yêu thích' : 'Chưa yêu thích',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
                trailing: ElevatedButton(
                  onPressed: () => context.read<FavoriteCubit>().toggle(),
                  child: Text(favs ? 'Bỏ thích' : 'Thêm thích'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── So sánh Local Storage ────────────────────────────
            _InfoBox(
              title: 'LOCAL STORAGE',
              subtitle: 'Dữ liệu ghi xuống ổ đĩa — còn sau khi tắt app',
              color: Colors.green,
              icon: Icons.storage,
            ),
            const SizedBox(height: 8),
            Text(
              'SharedPreferences → lưu bool, int, String đơn giản\n'
              'Hive              → lưu danh sách object phức tạp\n\n'
              'Xem: bai1_onboarding/ và bai2_hive/',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────

class _InfoBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _InfoBox({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String label;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.label,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(9),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

