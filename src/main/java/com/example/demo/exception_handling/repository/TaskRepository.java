package com.example.demo.exception_handling.repository;

import com.example.demo.exception_handling.entity.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {

    // Dùng để kiểm tra trùng tiêu đề (Bài 5)
    // SELECT * FROM tasks WHERE tieu_de = ? LIMIT 1
    Optional<Task> findByTieuDe(String tieuDe);

    // Kiểm tra tồn tại nhanh hơn findBy (không load toàn bộ entity)
    boolean existsByTieuDe(String tieuDe);
}
