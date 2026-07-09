package com.example.demo.jwt.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password;  // BCrypt hash — không bao giờ lưu plain text

    @Column
    private String email;

    @Column(nullable = false)
    private String role;      // "ADMIN", "USER", "MANAGER"

    @Column(nullable = false)
    private Boolean active = true;

    // Constructors
    public User() {}

    // Getters & Setters
    public Long getId()           { return id; }

    public String getUsername()   { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword()   { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail()      { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole()       { return role; }
    public void setRole(String role) { this.role = role; }

    public Boolean getActive()    { return active; }
    public void setActive(Boolean active) { this.active = active; }
}
