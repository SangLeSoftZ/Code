package com.example.demo.baiA.service;

import com.example.demo.baiA.dto.BaiVietADTO;
import com.example.demo.baiA.entity.BaiVietA;

import java.util.List;

public interface BaiVietAService {
    List<BaiVietA> getAll();
    BaiVietA getById(Long id);
    BaiVietA create(BaiVietADTO dto);
    BaiVietA update(Long id, BaiVietADTO dto);
    void delete(Long id);
}
