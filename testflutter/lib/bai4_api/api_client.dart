import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task_model.dart';

/// ApiClient gọi Task API Spring Boot.
/// Khi chạy trên Android Emulator, dùng 10.0.2.2 thay vì localhost
/// vì localhost trỏ vào emulator, còn 10.0.2.2 mới trỏ vào máy host.
class ApiClient {
  // Đổi port nếu Spring Boot của bạn chạy port khác
  static const String _baseUrl = 'http://10.0.2.2:9090/api';

  final http.Client _client;

  /// Cho phép inject http.Client tuỳ chỉnh (tiện cho việc test)
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  // ─── GET /tasks ────────────────────────────────────────────────────────────

  /// Lấy danh sách tất cả tác vụ từ server.
  /// Trả về [List<Task>] khi thành công, ném [Exception] khi lỗi.
  Future<List<Task>> layDanhSachTask() async {
    final uri = Uri.parse('$_baseUrl/baiA');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'layDanhSachTask thất bại — HTTP ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      // Bắt lỗi mạng (SocketException, TimeoutException, v.v.)
      throw Exception('layDanhSachTask lỗi kết nối: $e');
    }
  }

  // ─── POST /tasks ───────────────────────────────────────────────────────────

  /// Tạo tác vụ mới với [tieuDe] cho trước.
  /// Trả về [Task] vừa tạo (kèm id từ server) khi thành công.
  Future<Task> taoTask(String tieuDe, {String moTa = '', String trangThai = 'CHUA_XONG'}) async {
    final uri = Uri.parse('$_baseUrl/baiA');

    final body = jsonEncode({
      'tieuDe': tieuDe,
      'moTa': moTa,
      'trangThai': trangThai,
    });

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Task.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          'taoTask thất bại — HTTP ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('taoTask lỗi kết nối: $e');
    }
  }
}
