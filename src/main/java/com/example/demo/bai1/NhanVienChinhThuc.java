package com.example.demo.bai1;

// Nhân viên chính thức: lương = lương cơ bản + 2 triệu thưởng
public class NhanVienChinhThuc extends NhanVien {

    private static final double THUONG = 2_000_000;

    public NhanVienChinhThuc(String ten, double luongCoBan) {
        super(ten, luongCoBan);
    }

    @Override
    public double tinhLuong() {
        return luongCoBan + THUONG;
    }
}
