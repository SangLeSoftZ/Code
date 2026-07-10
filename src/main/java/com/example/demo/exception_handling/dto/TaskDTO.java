package com.example.demo.exception_handling.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class TaskDTO {

    @NotBlank(message = "Tiêu đề không được để trống")
    @Size(min = 3, max = 255, message = "Tiêu đề phải từ 3 đến 255 ký tự")
    private String tieuDe;

    private String moTa;

    private String trangThai;

    public String getTieuDe()           { return tieuDe; }
    public void setTieuDe(String t)     { this.tieuDe = t; }
    public String getMoTa()             { return moTa; }
    public void setMoTa(String m)       { this.moTa = m; }
    public String getTrangThai()        { return trangThai; }
    public void setTrangThai(String tt) { this.trangThai = tt; }
}
