import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider tạo và cung cấp LoginCubit cho toàn bộ cây widget bên trong
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: 'Tài khoản',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // BlocConsumer = BlocBuilder + BlocListener gộp lại
            // - listener: xử lý side-effect (snackbar, navigation)
            // - builder: rebuild UI theo state
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đăng nhập thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.loi),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                // Khi đang loading → hiển thị vòng xoay
                if (state is LoginLoading) {
                  return const CircularProgressIndicator();
                }

                // Các state khác → hiển thị nút đăng nhập
                return ElevatedButton(
                  onPressed: () {
                    // Lấy LoginCubit và gọi hàm dangNhap
                    context.read<LoginCubit>().dangNhap(
                          _userController.text.trim(),
                          _passController.text.trim(),
                        );
                  },
                  child: const Text('Đăng nhập'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
