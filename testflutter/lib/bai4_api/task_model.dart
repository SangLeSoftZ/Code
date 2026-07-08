// Model đại diện cho một tác vụ trả về từ API
class Task {
  final int id;
  final String tieuDe;
  final String moTa;
  final String trangThai;

  const Task({
    required this.id,
    required this.tieuDe,
    required this.moTa,
    required this.trangThai,
  });

  /// Chuyển từ JSON (response của API) sang object Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      tieuDe: json['tieuDe'] as String? ?? '',
      moTa: json['moTa'] as String? ?? '',
      trangThai: json['trangThai'] as String? ?? '',
    );
  }

  /// Chuyển object Task sang JSON (để gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      'tieuDe': tieuDe,
      'moTa': moTa,
      'trangThai': trangThai,
    };
  }

  @override
  String toString() => 'Task(id: $id, tieuDe: $tieuDe, trangThai: $trangThai)';
}
