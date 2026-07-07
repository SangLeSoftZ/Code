package com.example.demo.baiA;

import jakarta.validation.constraints.NotBlank;

public class BaiADTO {

    // @NotBlank: không cho phép null, rỗng "", hoặc chỉ toàn khoảng trắng "   "
    @NotBlank(message = "Tiêu đề không được để trống")
    private String tieuDe;

    private String noiDung;

    // Getters & Setters
    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
}
