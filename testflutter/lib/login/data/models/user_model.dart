import '../../domain/entities/user_entity.dart';

/// Model ở Data layer — biết cách chuyển đổi JSON ↔ Object.
/// Extends [UserEntity] để có thể dùng ngay như entity ở Domain layer.
///
/// JSON Spring Boot trả về sau login:
/// {
///   "id": 1,
///   "username": "admin",
///   "email": "admin@softz.com",
///   "role": "ADMIN",
///   "active": true,
///   "token": "eyJhbGci..."
/// }
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.role,
    required super.active,
    required super.token,
  });

  /// Chuyển JSON từ API response thành [UserModel].
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'USER',
      active: json['active'] as bool? ?? true,
      token: json['token'] as String? ?? '',
    );
  }

  /// Chuyển [UserModel] thành JSON (dùng khi lưu cache local).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'active': active,
      'token': token,
    };
  }

  /// Chuyển từ [UserEntity] sang [UserModel].
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      role: entity.role,
      active: entity.active,
      token: entity.token,
    );
  }
}
