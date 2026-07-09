package com.example.demo.jwt.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

// Controller tạm — CHỈ DÙNG KHI SETUP DATA
@RestController
@RequestMapping("/api/auth")
public class HashController {

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    // POST /api/auth/hash
    // Body: { "password": "123456" }
    // Dùng POST thay GET để tránh ký tự \n bị thêm vào URL path
    @PostMapping("/hash")
    public ResponseEntity<?> generateHash(@RequestBody Map<String, String> body) {
        String password = body.get("password");

        if (password == null || password.isBlank()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Thiếu trường 'password' trong body"));
        }

        // In ra console để kiểm tra password nhận được
        System.out.println("=== HASH DEBUG ===");
        System.out.println("Password nhận được: [" + password + "]");
        System.out.println("Độ dài: " + password.length());
        System.out.println("==================");

        String hash = encoder.encode(password);

        return ResponseEntity.ok(Map.of(
                "password",     password,
                "passwordLen",  password.length(),  // phải là 6
                "hash",         hash,
                "hashLen",      hash.length(),       // phải là 60
                "note",         "Copy 'hash' vào cột password khi INSERT vào DB"
        ));
    }
}
