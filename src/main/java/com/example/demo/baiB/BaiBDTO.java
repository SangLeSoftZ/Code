package com.example.demo.baiB;

import jakarta.validation.constraints.NotBlank;

public class BaiBDTO {

    @NotBlank(message = "Tiêu đề không được để trống")
    @KhongChuaTuCam(message = "Tiêu đề chứa từ bị cấm")
    private String tieuDe;

    @KhongChuaTuCam(message = "Nội dung chứa từ bị cấm")
    private String noiDung;

    // Getters & Setters
    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
}
