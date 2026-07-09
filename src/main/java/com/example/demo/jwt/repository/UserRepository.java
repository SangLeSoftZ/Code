package com.example.demo.jwt.repository;

import com.example.demo.jwt.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Spring Data JPA tự sinh:
    // SELECT * FROM users WHERE username = ? LIMIT 1
    Optional<User> findByUsername(String username);
}
