package com.example.demo.baiA.repository;

import com.example.demo.baiA.entity.BaiVietA;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BaiVietARepository extends JpaRepository<BaiVietA, Long> {

    // Spring Data JPA tự sinh SQL: SELECT * FROM bai_viet WHERE loai = ?
    List<BaiVietA> findByLoai(String loai);
}
