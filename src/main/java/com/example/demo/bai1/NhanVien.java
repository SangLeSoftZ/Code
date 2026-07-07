package com.example.demo.bai1;

// Abstract class đại diện cho nhân viên
public abstract class NhanVien {

    protected String ten;
    protected double luongCoBan;

    public NhanVien(String ten, double luongCoBan) {
        this.ten = ten;
        this.luongCoBan = luongCoBan;
    }

    // Abstract method - mỗi loại nhân viên tự tính lương theo cách riêng
    public abstract double tinhLuong();

    public void inThongTin() {
        System.out.printf("%-20s | Lương: %,.0f VNĐ%n", ten, tinhLuong());
    }
}
