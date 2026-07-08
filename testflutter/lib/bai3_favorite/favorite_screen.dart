import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorite_cubit.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Cung cấp FavoriteCubit cho toàn bộ màn hình
      create: (_) => FavoriteCubit(),
      child: const _FavoriteView(),
    );
  }
}

class _FavoriteView extends StatelessWidget {
  const _FavoriteView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 3 - Favorite Screen'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Nhấn nút để thêm/xóa yêu thích',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // ─── BlocListener ───────────────────────────────────────────
            // Lắng nghe sự thay đổi state để hiện SnackBar
            // Chỉ hiện khi state chuyển false → true
            BlocListener<FavoriteCubit, bool>(
              listenWhen: (previous, current) => previous == false && current == true,
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã thêm yêu thích ❤️'),
                    backgroundColor: Colors.pinkAccent,
                    duration: Duration(seconds: 2),
                  ),
                );
              },

              // ─── BlocBuilder ─────────────────────────────────────────
              // Rebuild UI mỗi khi state thay đổi để đổi icon
              child: BlocBuilder<FavoriteCubit, bool>(
                builder: (context, isFavorited) {
                  return Column(
                    children: [
                      // Icon trái tim: rỗng khi false, đầy khi true
                      Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.red : Colors.grey,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isFavorited ? 'Đã yêu thích' : 'Chưa yêu thích',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isFavorited ? Colors.red : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Nút toggle yêu thích
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<FavoriteCubit>().toggle();
                        },
                        icon: Icon(
                          isFavorited ? Icons.heart_broken : Icons.favorite,
                        ),
                        label: Text(
                          isFavorited ? 'Xóa yêu thích' : 'Thêm yêu thích',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isFavorited ? Colors.grey : Colors.pinkAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
