package com.example.demo.jwt.service.impl;

import com.example.demo.jwt.entity.User;
import com.example.demo.jwt.repository.UserRepository;
import com.example.demo.jwt.service.UserService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    // BCryptPasswordEncoder: dùng để hash và kiểm tra password
    // Không inject làm Bean vì không có Spring Security full
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public Optional<User> timTheoUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public boolean kiemTraPassword(String rawPassword, String hashedPassword) {
        // trim() để loại bỏ ký tự \n hoặc khoảng trắng thừa
        return passwordEncoder.matches(rawPassword.trim(), hashedPassword.trim());
    }
}
