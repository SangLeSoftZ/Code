package com.example.demo.exception_handling.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "tasks")
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tieu_de", nullable = false, unique = true)
    private String tieuDe;

    @Column(name = "mo_ta")
    private String moTa;

    @Column(name = "trang_thai", nullable = false)
    private String trangThai = "CHUA_LAM";

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    public Task() {}

    public Task(String tieuDe, String moTa) {
        this.tieuDe   = tieuDe;
        this.moTa     = moTa;
        this.trangThai = "CHUA_LAM";
        this.createdAt = LocalDateTime.now();
    }

    // Getters & Setters
    public Long getId()             { return id; }
    public String getTieuDe()       { return tieuDe; }
    public void setTieuDe(String t) { this.tieuDe = t; }
    public String getMoTa()         { return moTa; }
    public void setMoTa(String m)   { this.moTa = m; }
    public String getTrangThai()        { return trangThai; }
    public void setTrangThai(String tt) { this.trangThai = tt; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
