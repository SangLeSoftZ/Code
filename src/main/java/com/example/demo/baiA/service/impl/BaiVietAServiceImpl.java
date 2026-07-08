package com.example.demo.baiA.service.impl;

import com.example.demo.baiA.dto.BaiVietADTO;
import com.example.demo.baiA.entity.BaiVietA;
import com.example.demo.baiA.repository.BaiVietARepository;
import com.example.demo.baiA.service.BaiVietAService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class BaiVietAServiceImpl implements BaiVietAService {

    private final BaiVietARepository repository;

    public BaiVietAServiceImpl(BaiVietARepository repository) {
        this.repository = repository;
    }

    @Override
    public List<BaiVietA> getAll() {
        // Chỉ lấy bài viết loại A từ DB
        return repository.findByLoai("A");
    }

    @Override
    public BaiVietA getById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Không tìm thấy bài viết ID: " + id));
    }

    @Override
    public BaiVietA create(BaiVietADTO dto) {
        // Map DTO → Entity rồi INSERT vào DB
        BaiVietA entity = new BaiVietA(dto.getTieuDe(), dto.getNoiDung());
        return repository.save(entity);
    }

    @Override
    public BaiVietA update(Long id, BaiVietADTO dto) {
        BaiVietA entity = getById(id);
        entity.setTieuDe(dto.getTieuDe());
        entity.setNoiDung(dto.getNoiDung());
        return repository.save(entity); // UPDATE trong DB
    }

    @Override
    public void delete(Long id) {
        getById(id); // ném 404 nếu không tồn tại
        repository.deleteById(id);
    }
}
