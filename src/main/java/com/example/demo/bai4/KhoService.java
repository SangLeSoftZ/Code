package com.example.demo.bai4;

public interface KhoService {

    /**
     * Kiểm tra xem sản phẩm còn tồn kho không.
     *
     * @param maSanPham mã sản phẩm cần kiểm tra
     * @return true nếu còn hàng, false nếu hết hàng
     */
    boolean kiemTraTonKho(String maSanPham);
}
