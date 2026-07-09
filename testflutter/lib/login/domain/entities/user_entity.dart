/// Entity thuần túy — chỉ chứa dữ liệu nghiệp vụ.
/// KHÔNG phụ thuộc vào bất kỳ framework, package hay lớp data nào.
///
/// Map theo bảng [users] trong shop_db:
///   id, username, email, role, active
class UserEntity {
  final String id;
  final String username;
  final String email;
  final String role; // 'ADMIN' | 'USER' | 'MANAGER'
  final bool active;
  final String token; // JWT token trả về sau khi login thành công

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.active,
    required this.token,
  });

  @override
  String toString() =>
      'UserEntity(id: $id, username: $username, role: $role, active: $active)';
}
