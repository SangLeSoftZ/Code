package com.example.demo.jwt.controller;

import com.example.demo.jwt.JwtUtil;
import com.example.demo.jwt.entity.User;
import com.example.demo.jwt.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@Tag(name = "Auth API", description = "Đăng nhập và xem thông tin profile")
@RestController
@RequestMapping("/api")
public class ProfileController {

    private final JwtUtil jwtUtil;
    private final UserService userService;

    public ProfileController(JwtUtil jwtUtil, UserService userService) {
        this.jwtUtil = jwtUtil;
        this.userService = userService;
    }

    // GET /api/profile — chỉ trả data nếu có token hợp lệ
    @Operation(summary = "Lấy thông tin profile",
               description = "Cần Bearer token trong header Authorization",
               security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/profile")
    public ResponseEntity<?> getProfile(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {

        // Bước 1: Kiểm tra header
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(401)
                    .body(Map.of("error", "Thiếu token. Vui lòng đăng nhập"));
        }

        // Bước 2: Tách token
        String token = authHeader.substring(7);

        // Bước 3: Kiểm tra token hợp lệ
        if (!jwtUtil.hopLe(token)) {
            return ResponseEntity.status(401)
                    .body(Map.of("error", "Token không hợp lệ hoặc đã hết hạn"));
        }

        // Bước 4: Lấy username từ token → tìm user trong DB
        String username = jwtUtil.layUsername(token);
        Optional<User> userOpt = userService.timTheoUsername(username);

        if (userOpt.isEmpty()) {
            return ResponseEntity.status(404)
                    .body(Map.of("error", "Không tìm thấy user"));
        }

        User user = userOpt.get();

        // Bước 5: Trả thông tin thực từ DB
        return ResponseEntity.ok(Map.of(
                "id",       user.getId(),
                "username", user.getUsername(),
                "email",    user.getEmail() != null ? user.getEmail() : "",
                "role",     user.getRole(),
                "active",   user.getActive()
        ));
    }
}
