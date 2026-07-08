package com.example.demo.baiB.dto;

import com.example.demo.baiB.validator.KhongChuaTuCam;
import jakarta.validation.constraints.NotBlank;

public class BaiVietBDTO {

    @NotBlank(message = "Tiêu đề không được để trống")
    @KhongChuaTuCam(message = "Tiêu đề chứa từ bị cấm")
    private String tieuDe;

    @KhongChuaTuCam(message = "Nội dung chứa từ bị cấm")
    private String noiDung;

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
}
