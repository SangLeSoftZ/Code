package com.example.demo.baiA;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/baiA")
public class BaiAController {

    // Giả lập database bằng Map trong memory
    private final Map<Long, BaiADTO> database = new HashMap<>();
    private Long idCounter = 1L;

    // ========== POST - Tạo mới ==========

    // CÓ @Valid → Spring kích hoạt validation, kiểm tra @NotBlank trước khi vào method
    @PostMapping("/co-valid")
    public ResponseEntity<Map<String, Object>> coValid(@Valid @RequestBody BaiADTO dto) {
        Long id = idCounter++;
        database.put(id, dto);
        
        Map<String, Object> response = new HashMap<>();
        response.put("id", id);
        response.put("message", "Tạo bài thành công");
        response.put("tieuDe", dto.getTieuDe());
        return ResponseEntity.ok(response);
    }

    // KHÔNG có @Valid → Spring bỏ qua hoàn toàn, @NotBlank trong DTO vô hiệu
    @PostMapping("/khong-valid")
    public ResponseEntity<String> khongValid(@RequestBody BaiADTO dto) {
        return ResponseEntity.ok("Tạo bài thành công (không validate): " + dto.getTieuDe());
    }

    // ========== GET - Lấy theo ID ==========

    @GetMapping("/{id}")
    public ResponseEntity<?> getById(@PathVariable Long id) {
        BaiADTO dto = database.get(id);
        if (dto == null) {
            return ResponseEntity.status(404).body("Không tìm thấy bài viết ID: " + id);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("id", id);
        response.put("tieuDe", dto.getTieuDe());
        response.put("noiDung", dto.getNoiDung());
        return ResponseEntity.ok(response);
    }

    // GET tất cả
    @GetMapping
    public ResponseEntity<Map<Long, BaiADTO>> getAll() {
        return ResponseEntity.ok(database);
    }

    // ========== PUT - Cập nhật ==========

    @PutMapping("/{id}")
    public ResponseEntity<?> update(
            @PathVariable Long id,
            @Valid @RequestBody BaiADTO dto) {
        
        if (!database.containsKey(id)) {
            return ResponseEntity.status(404).body("Không tìm thấy bài viết ID: " + id);
        }
        
        database.put(id, dto);
        
        Map<String, Object> response = new HashMap<>();
        response.put("id", id);
        response.put("message", "Cập nhật thành công");
        response.put("tieuDe", dto.getTieuDe());
        return ResponseEntity.ok(response);
    }
}
