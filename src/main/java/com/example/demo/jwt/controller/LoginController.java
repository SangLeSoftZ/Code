package com.example.demo.jwt.controller;

import com.example.demo.jwt.JwtUtil;
import com.example.demo.jwt.dto.LoginRequest;
import com.example.demo.jwt.dto.LoginResponse;
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

    /**
     * POST /api/auth/login
     *
     * Request body:  { "username": "admin", "password": "123456" }
     *
     * Response 200:  { "id": 1, "username": "admin", "email": "admin@softz.com",
     *                  "role": "ADMIN", "active": true, "token": "eyJ..." }
     * Response 401:  { "error": "Sai username hoặc password" }
     * Response 403:  { "error": "Tài khoản đã bị khóa" }
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {

        System.out.println("=== LOGIN DEBUG ===");
        System.out.println("Username: [" + request.getUsername() + "]");
        System.out.println("Password: [" + request.getPassword() + "]");

        // Bước 1: Tìm user theo username
        Optional<User> userOpt = userService.timTheoUsername(request.getUsername());
        System.out.println("Tìm thấy user: " + userOpt.isPresent());

        if (userOpt.isEmpty()) {
            return ResponseEntity.status(401)
                    .body(Map.of("error", "Sai username hoặc password"));
        }

        User user = userOpt.get();

        // Bước 2: Kiểm tra active
        if (!user.getActive()) {
            return ResponseEntity.status(403)
                    .body(Map.of("error", "Tài khoản đã bị khóa"));
        }

        // Bước 3: Kiểm tra password BCrypt
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

        // Bước 4: Tạo JWT và trả LoginResponse đầy đủ cho Flutter
        String token = jwtUtil.taoToken(user.getUsername(), user.getRole());

        LoginResponse response = new LoginResponse(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getRole(),
                user.getActive(),
                token
        );

        return ResponseEntity.ok(response);
    }
}
