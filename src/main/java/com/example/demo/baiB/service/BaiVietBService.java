package com.example.demo.baiB.service;

import com.example.demo.baiB.dto.BaiVietBDTO;
import com.example.demo.baiB.entity.BaiVietB;

import java.util.List;

public interface BaiVietBService {
    List<BaiVietB> getAll();
    BaiVietB getById(Long id);
    BaiVietB create(BaiVietBDTO dto);
    BaiVietB update(Long id, BaiVietBDTO dto);
    void delete(Long id);
}
