package com.example.demo.bai1;

// Nhân viên thử việc: lương = lương cơ bản * 85%
public class NhanVienThuViec extends NhanVien {

    public NhanVienThuViec(String ten, double luongCoBan) {
        super(ten, luongCoBan);
    }

    @Override
    public double tinhLuong() {
        return luongCoBan * 0.85;
    }
}
