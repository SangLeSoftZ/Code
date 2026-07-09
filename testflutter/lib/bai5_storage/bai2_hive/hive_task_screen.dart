// ════════════════════════════════════════════════════════════════
// FILE: bai2_hive/hive_task_screen.dart
// LOẠI: Presentation (UI) + LOCAL STORAGE (Hive)
// PHÂN BIỆT với bai4_api/task_screen.dart:
//   task_screen.dart    → gọi API Spring Boot qua HTTP (online)
//   hive_task_screen.dart → lưu/đọc offline trong Hive Box (local)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_hive_model.dart';

// Tên Box — giống tên "bảng" trong SQL
const String kTaskBox = 'task_box';

class HiveTaskScreen extends StatefulWidget {
  const HiveTaskScreen({super.key});

  @override
  State<HiveTaskScreen> createState() => _HiveTaskScreenState();
}

class _HiveTaskScreenState extends State<HiveTaskScreen> {
  // Lấy Box đã mở sẵn trong main.dart
  late final Box<TaskHiveModel> _box;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _box = Hive.box<TaskHiveModel>(kTaskBox);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── THÊM task vào Hive Box ──────────────────────────────────────
  Future<void> _themTask() async {
    final tieuDe = _controller.text.trim();
    if (tieuDe.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tiêu đề không được để trống!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Hive tự gán key (index) — giống auto_increment
    await _box.add(TaskHiveModel(tieuDe: tieuDe));
    _controller.clear();
  }

  // ── XÓA task theo vị trí (index) ───────────────────────────────
  Future<void> _xoaTask(int index) async {
    await _box.deleteAt(index);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa task'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // ── ĐỔI trạng thái task ────────────────────────────────────────
  Future<void> _doiTrangThai(int index) async {
    final task = _box.getAt(index)!;
    final states = ['CHUA_XONG', 'DANG_LAM', 'HOAN_THANH'];
    final nextIndex = (states.indexOf(task.trangThai) + 1) % states.length;
    task.trangThai = states[nextIndex];
    await task.save(); // HiveObject.save() → tự cập nhật vào Box
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive — Task Local'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // ── Nhãn phân biệt loại storage ─────────────────────────
          Container(
            width: double.infinity,
            color: Colors.green.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: const Text(
              '📦 LOCAL STORAGE (Hive) — lưu offline, không cần internet',
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),

          // ── Ô nhập tiêu đề ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tiêu đề task...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _themTask(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _themTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── DANH SÁCH — ValueListenableBuilder tự rebuild khi Box thay đổi ──
          // Đây là điểm mạnh của Hive: không cần setState thủ công
          Expanded(
            child: ValueListenableBuilder<Box<TaskHiveModel>>(
              valueListenable: _box.listenable(),
              builder: (context, box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Chưa có task nào.\nNhập và nhấn Thêm!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // ĐỌC toàn bộ danh sách từ Box
                final tasks = box.values.toList();

                return ListView.builder(
                  itemCount: tasks.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _TaskHiveCard(
                      task: task,
                      onDelete: () => _xoaTask(index),
                      onToggle: () => _doiTrangThai(index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget card cho 1 task ─────────────────────────────────────────────────

class _TaskHiveCard extends StatelessWidget {
  final TaskHiveModel task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _TaskHiveCard({
    required this.task,
    required this.onDelete,
    required this.onToggle,
  });

  Color get _color {
    switch (task.trangThai) {
      case 'HOAN_THANH':
        return Colors.green;
      case 'DANG_LAM':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String get _label {
    switch (task.trangThai) {
      case 'HOAN_THANH':
        return '✅ Hoàn thành';
      case 'DANG_LAM':
        return '🔄 Đang làm';
      default:
        return '⏳ Chưa xong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _color.withValues(alpha: 0.15),
          child: Icon(Icons.task_alt, color: _color, size: 20),
        ),
        title: Text(
          task.tieuDe,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration:
                task.trangThai == 'HOAN_THANH'
                    ? TextDecoration.lineThrough
                    : null,
          ),
        ),
        subtitle: Text(
          '$_label  •  ${_formatDate(task.taoLuc)}',
          style: const TextStyle(fontSize: 12),
        ),
        // Nhấn vào card để đổi trạng thái
        onTap: onToggle,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          tooltip: 'Xóa task',
          onPressed: onDelete,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
}
