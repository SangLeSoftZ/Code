package com.example.demo.bai3;

import java.util.List;

public class TinhTuoiTrungBinh {

    public static void main(String[] args) {
        List<Integer> tuoi = List.of(15, 22, 17, 30, 16, 45);

        // Lọc từ 18 tuổi trở lên, rồi tính trung bình
        double tuoiTrungBinh = tuoi.stream()
                .filter(t -> t >= 18)           // Chỉ lấy tuổi >= 18
                .mapToInt(Integer::intValue)    // Chuyển sang IntStream
                .average()                       // Tính trung bình
                .orElse(0.0);                   // Nếu không có ai, trả về 0

        System.out.println("Danh sách tuổi: " + tuoi);
        System.out.printf("Tuổi trung bình (>= 18): %.1f%n", tuoiTrungBinh);
    }
}
