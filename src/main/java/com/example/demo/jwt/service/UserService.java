package com.example.demo.jwt.service;

import com.example.demo.jwt.entity.User;

import java.util.Optional;

public interface UserService {

    // Tìm user theo username
    Optional<User> timTheoUsername(String username);

    // Kiểm tra password người dùng nhập có khớp hash trong DB không
    boolean kiemTraPassword(String rawPassword, String hashedPassword);
}
