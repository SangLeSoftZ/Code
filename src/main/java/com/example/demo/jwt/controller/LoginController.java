package com.example.demo.jwt.controller;

import com.example.demo.jwt.JwtUtil;
import com.example.demo.jwt.dto.LoginRequest;
import com.example.demo.jwt.entity.User;
import com.example.demo.jwt.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class LoginController {

    private final JwtUtil jwtUtil;
    private final UserService userService;

    public LoginController(JwtUtil jwtUtil, UserService userService) {
        this.jwtUtil = jwtUtil;
        this.userService = userService;
    }

    // POST /api/auth/login → tìm user trong DB, kiểm tra BCrypt, trả token
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {

        // DEBUG: in ra console để kiểm tra
        System.out.println("=== LOGIN DEBUG ===");
        System.out.println("Username nhận được: [" + request.getUsername() + "]");
        System.out.println("Password nhận được: [" + request.getPassword() + "]");

        // Bước 1: Tìm user theo username trong DB
        Optional<User> userOpt = userService.timTheoUsername(request.getUsername());

        System.out.println("Tìm thấy user: " + userOpt.isPresent());

        if (userOpt.isEmpty()) {
            return ResponseEntity.status(401)
                    .body(Map.of("error", "Sai username hoặc password"));
        }

        User user = userOpt.get();
        System.out.println("Hash trong DB: [" + user.getPassword() + "]");

        // Bước 2: Kiểm tra user có đang active không
        if (!user.getActive()) {
            return ResponseEntity.status(403)
                    .body(Map.of("error", "Tài khoản đã bị khóa"));
        }

        // Bước 3: So sánh password
        boolean matKhauDung = userService.kiemTraPassword(
                request.getPassword(),
                user.getPassword()
        );

        System.out.println("Mật khẩu đúng: " + matKhauDung);
        System.out.println("===================");

        if (!matKhauDung) {
            return ResponseEntity.status(401)
                    .body(Map.of("error", "Sai username hoặc password"));
        }

        // Bước 4: Đúng hết → tạo JWT token
        String token = jwtUtil.taoToken(user.getUsername(), user.getRole());

        return ResponseEntity.ok(Map.of(
                "token",    token,
                "type",     "Bearer",
                "username", user.getUsername(),
                "role",     user.getRole()
        ));
    }
}
