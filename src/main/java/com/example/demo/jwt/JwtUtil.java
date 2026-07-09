package com.example.demo.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
public class JwtUtil {

    private static final String SECRET = "softz-secret-key-must-be-32chars!!";
    private static final long   EXPIRATION_MS = 1000 * 60 * 60; // 1 giờ

    private SecretKey getKey() {
        return Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));
    }

    // Tạo token với username và role
    public String taoToken(String username, String role) {
        return Jwts.builder()
                .subject(username)
                .claim("role", role)                            // thêm role vào payload
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + EXPIRATION_MS))
                .signWith(getKey())
                .compact();
    }

    // Kiểm tra token hợp lệ: chữ ký đúng + chưa hết hạn
    public boolean hopLe(String token) {
        try {
            Jwts.parser()
                .verifyWith(getKey())
                .build()
                .parseSignedClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    // Đọc username từ token
    public String layUsername(String token) {
        return getClaims(token).getSubject();
    }

    // Đọc role từ token
    public String layRole(String token) {
        return getClaims(token).get("role", String.class);
    }

    // Helper: parse và trả Claims
    private Claims getClaims(String token) {
        return Jwts.parser()
                .verifyWith(getKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}
