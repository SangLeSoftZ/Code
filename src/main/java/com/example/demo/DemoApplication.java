package com.example.demo;

import com.example.demo.bai1.NhanVienChinhThuc;
import com.example.demo.bai1.NhanVienThuViec;
import com.example.demo.bai4.DonHangService;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	// ApplicationRunner chạy ngay sau khi Spring IoC Container khởi động xong
	// Spring tự inject DonHangService vào đây — không cần "new" thủ công
	@Bean
	public ApplicationRunner runner(DonHangService donHangService) {
		return args -> {

			// ========== BÀI 1: OOP - Abstract Class ==========
			System.out.println("===== BÀI 1: NHÂN VIÊN =====");
			var nvChinhThuc = new NhanVienChinhThuc("Nguyễn Văn An", 10_000_000);
			var nvThuViec   = new NhanVienThuViec("Trần Thị Bình", 8_000_000);

			nvChinhThuc.inThongTin(); // 10tr + 2tr = 12,000,000
			nvThuViec.inThongTin();   // 8tr * 0.85 = 6,800,000

			// ========== BÀI 2: Collection - Loại trùng lặp ==========
			System.out.println("\n===== BÀI 2: TÊN KHÔNG TRÙNG =====");
			List<String> hoTen = List.of("An", "Binh", "An", "Chi", "Binh");
			Set<String> tenKhongTrung = new LinkedHashSet<>(hoTen);

			System.out.println("Danh sách gốc : " + hoTen);
			System.out.println("Không trùng lặp: " + tenKhongTrung);

			// ========== BÀI 3: Stream + Lambda ==========
			System.out.println("\n===== BÀI 3: TUỔI TRUNG BÌNH =====");
			List<Integer> tuoi = List.of(15, 22, 17, 30, 16, 45);

			double tuoiTrungBinh = tuoi.stream()
					.filter(t -> t >= 18)
					.mapToInt(Integer::intValue)
					.average()
					.orElse(0.0);

			System.out.println("Danh sách tuổi: " + tuoi);
			System.out.printf("Tuổi trung bình (>= 18): %.1f%n", tuoiTrungBinh);

			// ========== BÀI 4: IoC + Constructor Injection ==========
			System.out.println("\n===== BÀI 4: ĐẶT HÀNG (IoC) =====");

			// DonHangService đã được Spring inject sẵn vào tham số của runner()
			// Không cần "new" gì cả — Spring IoC Container lo hết
			donHangService.datHang("SP001");
		};
	}
}
