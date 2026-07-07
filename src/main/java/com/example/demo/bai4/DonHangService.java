package com.example.demo.bai4;

import org.springframework.stereotype.Service;

// @Service đánh dấu class này là một Spring Bean
// Spring IoC Container sẽ tự động tạo và quản lý object này
@Service
public class DonHangService {

    // Phụ thuộc vào interface, KHÔNG phụ thuộc vào class cụ thể
    private final KhoService khoService;

    // Constructor Injection:
    // Spring thấy constructor này, tự động tìm Bean KhoService trong IoC Container
    // rồi truyền vào — lập trình viên không cần gọi "new" thủ công
    public DonHangService(KhoService khoService) {
        this.khoService = khoService;
    }

    public void datHang(String maSanPham) {
        if (khoService.kiemTraTonKho(maSanPham)) {
            System.out.println("  [DonHangService] Đặt hàng thành công: " + maSanPham);
        } else {
            System.out.println("  [DonHangService] Hết hàng: " + maSanPham);
        }
    }
}
