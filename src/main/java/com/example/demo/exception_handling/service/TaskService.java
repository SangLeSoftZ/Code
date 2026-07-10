package com.example.demo.exception_handling.service;

import com.example.demo.exception_handling.dto.TaskDTO;
import com.example.demo.exception_handling.entity.Task;

import java.util.List;

public interface TaskService {
    List<Task> getAll();
    Task getById(Long id);       // Bài 4: ném ResourceNotFoundException nếu không có
    Task create(TaskDTO dto);    // Bài 5: ném BusinessException nếu trùng tieuDe
    Task update(Long id, TaskDTO dto);
    void delete(Long id);
}
