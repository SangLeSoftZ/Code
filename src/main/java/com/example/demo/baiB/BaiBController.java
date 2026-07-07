package com.example.demo.baiB;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/baiB")
public class BaiBController {

    // Giả lập database bằng Map trong memory
    private final Map<Long, BaiBDTO> database = new HashMap<>();
    private Long idCounter = 1L;

    // ========== POST - Đăng bài ==========

    @PostMapping("/dang-bai")
    public ResponseEntity<?> dangBai(@Valid @RequestBody BaiBDTO dto) {
        Long id = idCounter++;
        database.put(id, dto);

        Map<String, Object> response = new HashMap<>();
        response.put("id", id);
        response.put("message", "Đăng bài thành công");
        response.put("tieuDe", dto.getTieuDe());
        return ResponseEntity.ok(response);
    }

    // ========== GET - Lấy theo ID ==========

    @GetMapping("/{id}")
    public ResponseEntity<?> getById(@PathVariable Long id) {
        BaiBDTO dto = database.get(id);
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
    public ResponseEntity<Map<Long, BaiBDTO>> getAll() {
        return ResponseEntity.ok(database);
    }

    // ========== PUT - Cập nhật ==========
    // @Valid vẫn kích hoạt @KhongChuaTuCam khi update

    @PutMapping("/{id}")
    public ResponseEntity<?> update(
            @PathVariable Long id,
            @Valid @RequestBody BaiBDTO dto) {

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
