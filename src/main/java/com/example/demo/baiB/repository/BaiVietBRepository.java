package com.example.demo.baiB.repository;

import com.example.demo.baiB.entity.BaiVietB;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BaiVietBRepository extends JpaRepository<BaiVietB, Long> {

    List<BaiVietB> findByLoai(String loai);
}
