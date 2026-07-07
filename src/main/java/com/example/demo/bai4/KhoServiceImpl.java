package com.example.demo.bai4;

import org.springframework.stereotype.Service;

// @Service đánh dấu class này là một Spring Bean
// Spring IoC Container sẽ tự động tạo và quản lý object này
@Service
public class KhoServiceImpl implements KhoService {

    @Override
    public boolean kiemTraTonKho(String maSanPham) {
        // Giả lập: thực tế sẽ truy vấn database
        System.out.println("  [KhoService] Kiểm tra tồn kho cho sản phẩm: " + maSanPham);
        return true;
    }
}
