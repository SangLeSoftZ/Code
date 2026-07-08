package com.example.demo.baiA.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "bai_viet")
public class BaiVietA {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tieu_de", nullable = false)
    private String tieuDe;

    @Column(name = "noi_dung")
    private String noiDung;

    @Column(name = "loai")
    private String loai = "A";

    public BaiVietA() {}

    public BaiVietA(String tieuDe, String noiDung) {
        this.tieuDe  = tieuDe;
        this.noiDung = noiDung;
        this.loai    = "A";
    }

    public Long getId()       { return id; }
    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }
    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
    public String getLoai()   { return loai; }
}
