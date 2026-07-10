// ════════════════════════════════════════════════════════════════
// FILE: test/bai7_verify_test.dart
// LOẠI: Unit Test nâng cao — verify() tham số với mocktail
//
// PHÂN BIỆT verify() vs expect() trong test:
//
// ┌──────────────────────────────┬─────────────────────────────────────┐
// │  expect()                    │  verify()                           │
// │  Kiểm tra KẾT QUẢ (output)  │  Kiểm tra HÀNH VI (behavior)        │
// │  "state phải là TaskLoaded"  │  "hàm này phải được gọi đúng 1 lần" │
// │  "list phải có 2 phần tử"    │  "tham số phải là 'admin', '123'"   │
// └──────────────────────────────┴─────────────────────────────────────┘
//
// Dùng verify() khi muốn đảm bảo:
//   1. Hàm được gọi đúng số lần (không bị gọi thừa)
//   2. Tham số truyền vào đúng giá trị (không bị truyền sai)
//   3. Hàm không được gọi (verifyNever)
// ════════════════════════════════════════════════════════════════

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testflutter/bai4_api/task_model.dart';
import 'package:testflutter/bai6_test/task_cubit/task_cubit.dart';
import 'package:testflutter/bai6_test/task_cubit/task_repository.dart';
import 'package:testflutter/bai6_test/task_cubit/task_state.dart';
import 'package:testflutter/login/domain/entities/user_entity.dart';
import 'package:testflutter/login/domain/repositories/auth_repository.dart';
import 'package:testflutter/login/core/errors/failures.dart';
import 'package:testflutter/login/domain/usecases/login_usecase.dart';

// ── Mock classes ─────────────────────────────────────────────────────────────

class MockTaskRepository extends Mock implements TaskRepository {}

// Mock AuthRepository để demo verify() với tham số String
class MockAuthRepository extends Mock implements AuthRepository {}

// ── Dữ liệu mẫu ─────────────────────────────────────────────────────────────

final tTaskList = [
  Task(id: 1, tieuDe: 'Học Flutter', moTa: '', trangThai: 'CHUA_XONG'),
];

final tUser = UserEntity(
  id: '1',
  username: 'admin',
  email: 'admin@softz.com',
  role: 'ADMIN',
  active: true,
  token: 'jwt_token_abc123',
);

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockAuthRepo = MockAuthRepository();
  });

  tearDown(() {
    reset(mockTaskRepo);
    reset(mockAuthRepo);
  });

  // ════════════════════════════════════════════════════════════════
  // BÀI 7 — verify() kiểm tra tham số truyền vào mock
  // ════════════════════════════════════════════════════════════════

  group('BÀI 7 — verify() kiểm tra hành vi mock', () {

    // ── Test 1: verify() cơ bản — hàm được gọi đúng 1 lần ──────────
    blocTest<TaskCubit, TaskState>(
      'verify: layDanhSachTask() được gọi đúng 1 lần khi layDanhSach()',

      build: () {
        when(() => mockTaskRepo.layDanhSachTask())
            .thenAnswer((_) async => tTaskList);
        return TaskCubit(mockTaskRepo);
      },

      act: (cubit) => cubit.layDanhSach(),

      expect: () => [isA<TaskLoading>(), isA<TaskLoaded>()],

      verify: (_) {
        // ── VERIFY: kiểm tra hàm được gọi đúng 1 lần ────────────────
        // Nếu gọi 0 lần hoặc > 1 lần → test FAIL
        verify(() => mockTaskRepo.layDanhSachTask()).called(1);
      },
    );

    // ── Test 2: verify() tham số String — taoTask với đúng tiêu đề ──
    blocTest<TaskCubit, TaskState>(
      'verify: taoTask() được gọi với đúng tham số "Học Flutter"',

      build: () {
        final newTask = Task(
          id: 99,
          tieuDe: 'Học Flutter',
          moTa: '',
          trangThai: 'CHUA_XONG',
        );
        // Chỉ stub cho đúng tham số 'Học Flutter'
        when(() => mockTaskRepo.taoTask('Học Flutter'))
            .thenAnswer((_) async => newTask);
        when(() => mockTaskRepo.layDanhSachTask())
            .thenAnswer((_) async => [newTask]);
        return TaskCubit(mockTaskRepo);
      },

      act: (cubit) => cubit.taoTask('Học Flutter'), // ← truyền đúng tham số

      expect: () => [isA<TaskLoading>(), isA<TaskLoaded>()],

      verify: (_) {
        // ── VERIFY tham số ────────────────────────────────────────────
        // Xác nhận mock được gọi với đúng string 'Học Flutter'
        // Nếu Cubit gọi taoTask('sai tham số') → test FAIL
        verify(() => mockTaskRepo.taoTask('Học Flutter')).called(1);

        // Sau taoTask, layDanhSachTask cũng phải được gọi 1 lần
        verify(() => mockTaskRepo.layDanhSachTask()).called(1);
      },
    );

    // ── Test 3: verifyNever() — hàm KHÔNG được gọi ──────────────────
    blocTest<TaskCubit, TaskState>(
      'verifyNever: taoTask() KHÔNG được gọi khi chỉ layDanhSach()',

      build: () {
        when(() => mockTaskRepo.layDanhSachTask())
            .thenAnswer((_) async => tTaskList);
        return TaskCubit(mockTaskRepo);
      },

      act: (cubit) => cubit.layDanhSach(), // chỉ gọi layDanhSach, không taoTask

      expect: () => [isA<TaskLoading>(), isA<TaskLoaded>()],

      verify: (_) {
        // taoTask() không được gọi khi chỉ layDanhSach()
        verifyNever(() => mockTaskRepo.taoTask(any()));
      },
    );

    // ── Test 4: verify() với AuthRepository — demo giống đề bài ─────
    // Đây là test mô phỏng: verify(() => mockRepo.dangNhap('admin','123'))
    test(
      'verify: AuthRepository.login() được gọi đúng với username="admin", password="123456"',
      () async {
        // arrange: stub mock trả về user thành công
        when(
          () => mockAuthRepo.login(
            username: 'admin',
            password: '123456',
          ),
        ).thenAnswer((_) async => (tUser, null));

        // act: gọi UseCase (sẽ gọi repository bên trong)
        final useCase = LoginUseCase(mockAuthRepo);
        await useCase(
          const LoginParams(username: 'admin', password: '123456'),
        );

        // ── VERIFY: kiểm tra đúng tham số + đúng số lần gọi ──────────
        //
        // Câu hỏi verify kiểm tra:
        //   1. login() được gọi đúng 1 lần (không bị gọi thừa)
        //   2. username phải là 'admin' (không phải giá trị khác)
        //   3. password phải là '123456' (không phải giá trị khác)
        //
        // Nếu UseCase gọi login(username: 'ADMIN', password: '123456')
        // → test FAIL vì username khác ('ADMIN' ≠ 'admin')
        verify(
          () => mockAuthRepo.login(
            username: 'admin',   // ← kiểm tra đúng giá trị này
            password: '123456',  // ← kiểm tra đúng giá trị này
          ),
        ).called(1); // ← kiểm tra gọi đúng 1 lần
      },
    );

    // ── Test 5: verify() phát hiện gọi SAI tham số ───────────────────
    test(
      'verify: confirm rằng login() với tham số SAI sẽ không được verify',
      () async {
        // arrange
        when(
          () => mockAuthRepo.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => (tUser, null));

        // act: gọi với username = 'user1'
        final useCase = LoginUseCase(mockAuthRepo);
        await useCase(
          const LoginParams(username: 'user1', password: '123456'),
        );

        // verify: confirm gọi với 'user1' chứ không phải 'admin'
        verify(
          () => mockAuthRepo.login(
            username: 'user1',  // ← đúng với những gì vừa gọi
            password: '123456',
          ),
        ).called(1);

        // verify: 'admin' KHÔNG được gọi trong test này
        verifyNever(
          () => mockAuthRepo.login(
            username: 'admin',
            password: any(named: 'password'),
          ),
        );
      },
    );

    // ── Test 6: verify() kiểm tra gọi nhiều lần ─────────────────────
    blocTest<TaskCubit, TaskState>(
      'verify: gọi layDanhSach() 2 lần → layDanhSachTask() được gọi 2 lần',

      build: () {
        when(() => mockTaskRepo.layDanhSachTask())
            .thenAnswer((_) async => tTaskList);
        return TaskCubit(mockTaskRepo);
      },

      // act: gọi 2 lần
      act: (cubit) async {
        await cubit.layDanhSach();
        await cubit.layDanhSach();
      },

      // expect: 2 cặp Loading/Loaded
      expect: () => [
        isA<TaskLoading>(),
        isA<TaskLoaded>(),
        isA<TaskLoading>(),
        isA<TaskLoaded>(),
      ],

      verify: (_) {
        // Gọi 2 lần act → repository phải được gọi đúng 2 lần
        verify(() => mockTaskRepo.layDanhSachTask()).called(2);
      },
    );
  });
}
