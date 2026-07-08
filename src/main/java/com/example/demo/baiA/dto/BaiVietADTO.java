package com.example.demo.baiA.dto;

import jakarta.validation.constraints.NotBlank;

public class BaiVietADTO {

    @NotBlank(message = "Tiêu đề không được để trống")
    private String tieuDe;

    private String noiDung;

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
}
