package com.example.demo.bai2;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class LocTenKhongTrung {

    public static void main(String[] args) {
        List<String> hoTen = List.of("An", "Binh", "An", "Chi", "Binh");

        // LinkedHashSet giữ nguyên thứ tự thêm vào, đồng thời loại trùng lặp
        Set<String> tenKhongTrung = new LinkedHashSet<>(hoTen);

        System.out.println("Danh sách gốc : " + hoTen);
        System.out.println("Không trùng lặp: " + tenKhongTrung);
    }
}
