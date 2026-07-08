package com.example.demo.baiA.controller;

import com.example.demo.baiA.dto.BaiVietADTO;
import com.example.demo.baiA.entity.BaiVietA;
import com.example.demo.baiA.service.BaiVietAService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/baiA")
public class BaiAController {

    private final BaiVietAService service;

    public BaiAController(BaiVietAService service) {
        this.service = service;
    }

    // GET /baiA — lấy tất cả bài loại A từ DB
    @GetMapping
    public ResponseEntity<List<BaiVietA>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    // GET /baiA/{id}
    @GetMapping("/{id}")
    public ResponseEntity<BaiVietA> getById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getById(id));
    }

    // POST /baiA — CÓ @Valid → @NotBlank hoạt động
    @PostMapping
    public ResponseEntity<BaiVietA> create(@Valid @RequestBody BaiVietADTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(dto));
    }

    // POST /baiA/khong-valid — KHÔNG có @Valid → @NotBlank vô hiệu
    @PostMapping("/khong-valid")
    public ResponseEntity<BaiVietA> createKhongValid(@RequestBody BaiVietADTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(dto));
    }

    // PUT /baiA/{id}
    @PutMapping("/{id}")
    public ResponseEntity<BaiVietA> update(
            @PathVariable Long id,
            @Valid @RequestBody BaiVietADTO dto) {
        return ResponseEntity.ok(service.update(id, dto));
    }

    // DELETE /baiA/{id}
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build(); // HTTP 204
    }
}
