package com.example.demo.baiB.service.impl;

import com.example.demo.baiB.dto.BaiVietBDTO;
import com.example.demo.baiB.entity.BaiVietB;
import com.example.demo.baiB.repository.BaiVietBRepository;
import com.example.demo.baiB.service.BaiVietBService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class BaiVietBServiceImpl implements BaiVietBService {

    private final BaiVietBRepository repository;

    public BaiVietBServiceImpl(BaiVietBRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<BaiVietB> getAll() {
        return repository.findByLoai("B");
    }

    @Override
    public BaiVietB getById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Không tìm thấy bài viết ID: " + id));
    }

    @Override
    public BaiVietB create(BaiVietBDTO dto) {
        BaiVietB entity = new BaiVietB(dto.getTieuDe(), dto.getNoiDung());
        return repository.save(entity);
    }

    @Override
    public BaiVietB update(Long id, BaiVietBDTO dto) {
        BaiVietB entity = getById(id);
        entity.setTieuDe(dto.getTieuDe());
        entity.setNoiDung(dto.getNoiDung());
        return repository.save(entity);
    }

    @Override
    public void delete(Long id) {
        getById(id);
        repository.deleteById(id);
    }
}
