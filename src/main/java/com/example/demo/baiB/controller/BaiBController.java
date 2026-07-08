package com.example.demo.baiB.controller;

import com.example.demo.baiB.dto.BaiVietBDTO;
import com.example.demo.baiB.entity.BaiVietB;
import com.example.demo.baiB.service.BaiVietBService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/baiB")
public class BaiBController {

    private final BaiVietBService service;

    public BaiBController(BaiVietBService service) {
        this.service = service;
    }

    // GET /baiB
    @GetMapping
    public ResponseEntity<List<BaiVietB>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    // GET /baiB/{id}
    @GetMapping("/{id}")
    public ResponseEntity<BaiVietB> getById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getById(id));
    }

    // POST /baiB — @Valid kích hoạt cả @NotBlank lẫn @KhongChuaTuCam
    @PostMapping
    public ResponseEntity<BaiVietB> create(@Valid @RequestBody BaiVietBDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(dto));
    }

    // PUT /baiB/{id}
    @PutMapping("/{id}")
    public ResponseEntity<BaiVietB> update(
            @PathVariable Long id,
            @Valid @RequestBody BaiVietBDTO dto) {
        return ResponseEntity.ok(service.update(id, dto));
    }

    // DELETE /baiB/{id}
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
