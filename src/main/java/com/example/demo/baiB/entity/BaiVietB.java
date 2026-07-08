package com.example.demo.baiB.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "bai_viet")
public class BaiVietB {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tieu_de", nullable = false)
    private String tieuDe;

    @Column(name = "noi_dung")
    private String noiDung;

    @Column(name = "loai")
    private String loai = "B";

    public BaiVietB() {}

    public BaiVietB(String tieuDe, String noiDung) {
        this.tieuDe  = tieuDe;
        this.noiDung = noiDung;
        this.loai    = "B";
    }

    public Long getId()       { return id; }
    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }
    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
    public String getLoai()   { return loai; }
}
