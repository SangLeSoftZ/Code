// ════════════════════════════════════════════════════════════════
// FILE: test/bai6_task_cubit_test.dart
// LOẠI: Unit Test — dùng bloc_test + mocktail
//
// PHÂN BIỆT 3 KHÁI NIỆM TRONG FILE NÀY:
//
// ┌─────────────────────────────────────┬──────────────────────────────────┐
// │  Unit Test                          │  bloc_test                       │
// │  • Test 1 đơn vị code độc lập       │  • Package chuyên test Cubit/Bloc │
// │  • Không cần emulator/device        │  • Cung cấp blocTest() helper     │
// │  • Chạy nhanh (< 1 giây/test)       │  • Tự check thứ tự emit states   │
// │  • flutter test                     │  • expect: [Loading, Loaded]      │
// └─────────────────────────────────────┴──────────────────────────────────┘
//
// mocktail:
//   • Tạo Mock object giả lập TaskRepository
//   • Không cần code gen (khác mockito)
//   • when(() => mock.method()).thenReturn(value)
//   • verify(() => mock.method()).called(1)
// ════════════════════════════════════════════════════════════════

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testflutter/bai4_api/task_model.dart';
import 'package:testflutter/bai6_test/task_cubit/task_cubit.dart';
import 'package:testflutter/bai6_test/task_cubit/task_repository.dart';
import 'package:testflutter/bai6_test/task_cubit/task_state.dart';

// ── Bước 1: Tạo MockTaskRepository ──────────────────────────────────────────
// mocktail: chỉ cần extends Mock + implements interface
// KHÔNG cần @GenerateMocks hay chạy build_runner như mockito
class MockTaskRepository extends Mock implements TaskRepository {}

// ── Dữ liệu mẫu dùng chung trong các test ───────────────────────────────────
final tTaskList = [
  Task(id: 1, tieuDe: 'Học Flutter', moTa: '', trangThai: 'CHUA_XONG'),
  Task(id: 2, tieuDe: 'Học Bloc',    moTa: '', trangThai: 'DANG_LIEM'),
];

void main() {
  // ── Khai báo mock ở ngoài để dùng chung mọi test ────────────────────────
  late MockTaskRepository mockRepository;

  // setUp() chạy TRƯỚC mỗi test — đảm bảo mỗi test có mock sạch
  setUp(() {
    mockRepository = MockTaskRepository();
  });

  // tearDown() chạy SAU mỗi test — dọn dẹp
  // (optional với mocktail nhưng là best practice)
  tearDown(() {
    reset(mockRepository);
  });

  // ════════════════════════════════════════════════════════════════
  // BÀI 6 — Test 2 trường hợp: thành công và lỗi
  // ════════════════════════════════════════════════════════════════
  group('TaskCubit — layDanhSach()', () {

    // ── Test 1: State ban đầu ──────────────────────────────────────
    test('state ban đầu phải là TaskInitial', () {
      // arrange + act: tạo Cubit với mock
      final cubit = TaskCubit(mockRepository);

      // assert
      expect(cubit.state, isA<TaskInitial>());

      cubit.close();
    });

    // ── Test 2: THÀNH CÔNG → [TaskLoading, TaskLoaded] ────────────
    // blocTest là helper của bloc_test package:
    //   build   → tạo Cubit cần test
    //   setUp   → stub mock trả về gì
    //   act     → gọi hàm cần test
    //   expect  → kiểm tra thứ tự states được emit
    blocTest<TaskCubit, TaskState>(
      // Tên test — đọc như câu văn: "khi gọi layDanhSach thành công..."
      'khi layDanhSachTask() thành công → emit [TaskLoading, TaskLoaded]',

      build: () {
        // STUB: khi mock.layDanhSachTask() được gọi → trả về tTaskList
        when(() => mockRepository.layDanhSachTask())
            .thenAnswer((_) async => tTaskList);
        return TaskCubit(mockRepository);
      },

      act: (cubit) => cubit.layDanhSach(), // ← gọi hàm cần test

      // Kiểm tra ĐÚNG THỨ TỰ các state được emit
      expect: () => [
        isA<TaskLoading>(),         // state 1: đang tải
        isA<TaskLoaded>(),          // state 2: tải xong
      ],

      // Kiểm tra thêm: TaskLoaded phải chứa đúng dữ liệu
      verify: (cubit) {
        final state = cubit.state as TaskLoaded;
        expect(state.tasks.length, equals(2));
        expect(state.tasks.first.tieuDe, equals('Học Flutter'));
      },
    );

    // ── Test 3: LỖI → [TaskLoading, TaskError] ────────────────────
    blocTest<TaskCubit, TaskState>(
      'khi layDanhSachTask() ném Exception → emit [TaskLoading, TaskError]',

      build: () {
        // STUB: mock ném Exception thay vì trả dữ liệu
        when(() => mockRepository.layDanhSachTask())
            .thenThrow(Exception('Lỗi kết nối server'));
        return TaskCubit(mockRepository);
      },

      act: (cubit) => cubit.layDanhSach(),

      expect: () => [
        isA<TaskLoading>(),  // state 1: đang tải
        isA<TaskError>(),    // state 2: lỗi
      ],

      // Kiểm tra message lỗi có chứa đúng nội dung
      verify: (cubit) {
        final state = cubit.state as TaskError;
        expect(state.message, contains('Lỗi kết nối server'));
      },
    );

    // ── Test 4: Danh sách rỗng ─────────────────────────────────────
    blocTest<TaskCubit, TaskState>(
      'khi server trả về danh sách rỗng → emit [TaskLoading, TaskLoaded([])]',

      build: () {
        when(() => mockRepository.layDanhSachTask())
            .thenAnswer((_) async => []); // trả về list rỗng
        return TaskCubit(mockRepository);
      },

      act: (cubit) => cubit.layDanhSach(),

      expect: () => [
        isA<TaskLoading>(),
        isA<TaskLoaded>(),
      ],

      verify: (cubit) {
        final state = cubit.state as TaskLoaded;
        expect(state.tasks, isEmpty); // danh sách phải rỗng
      },
    );
  });

  // ════════════════════════════════════════════════════════════════
  // Test taoTask() — đủ bộ để hiểu cách test method có tham số
  // ════════════════════════════════════════════════════════════════
  group('TaskCubit — taoTask()', () {

    blocTest<TaskCubit, TaskState>(
      'khi taoTask() thành công → emit [TaskLoading, TaskLoaded]',

      build: () {
        final newTask = Task(
          id: 3,
          tieuDe: 'Task mới',
          moTa: '',
          trangThai: 'CHUA_XONG',
        );
        // Stub cả taoTask và layDanhSachTask (vì taoTask gọi cả 2)
        when(() => mockRepository.taoTask(any()))
            .thenAnswer((_) async => newTask);
        when(() => mockRepository.layDanhSachTask())
            .thenAnswer((_) async => [...tTaskList, newTask]);
        return TaskCubit(mockRepository);
      },

      act: (cubit) => cubit.taoTask('Task mới'),

      expect: () => [
        isA<TaskLoading>(),
        isA<TaskLoaded>(),
      ],

      verify: (cubit) {
        final state = cubit.state as TaskLoaded;
        expect(state.tasks.length, equals(3)); // 2 cũ + 1 mới
      },
    );
  });
}
