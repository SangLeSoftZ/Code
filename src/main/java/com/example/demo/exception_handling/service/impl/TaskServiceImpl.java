package com.example.demo.exception_handling.service.impl;

import com.example.demo.exception_handling.dto.TaskDTO;
import com.example.demo.exception_handling.entity.Task;
import com.example.demo.exception_handling.exception.BusinessException;
import com.example.demo.exception_handling.exception.ResourceNotFoundException;
import com.example.demo.exception_handling.repository.TaskRepository;
import com.example.demo.exception_handling.service.TaskService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TaskServiceImpl implements TaskService {

    private final TaskRepository repository;

    public TaskServiceImpl(TaskRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<Task> getAll() {
        return repository.findAll();
    }

    // ===================== BÀI 4 =====================
    @Override
    public Task getById(Long id) {
        // Nếu không tìm thấy → ném ResourceNotFoundException
        // GlobalExceptionHandler sẽ bắt và trả HTTP 404 + ApiError
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Task", id));
    }

    // ===================== BÀI 5 =====================
    @Override
    public Task create(TaskDTO dto) {
        // Kiểm tra tiêu đề đã tồn tại chưa
        // existsByTieuDe() chỉ SELECT COUNT(*) → nhanh hơn findBy
        if (repository.existsByTieuDe(dto.getTieuDe())) {
            // Ném BusinessException → GlobalExceptionHandler bắt → HTTP 409
            throw new BusinessException(
                    "tieuDe",
                    dto.getTieuDe(),
                    "Task với tiêu đề '" + dto.getTieuDe() + "' đã tồn tại"
            );
        }

        Task task = new Task(dto.getTieuDe(), dto.getMoTa());

        // Nếu client truyền trangThai thì dùng, không thì mặc định "CHUA_LAM"
        if (dto.getTrangThai() != null && !dto.getTrangThai().isBlank()) {
            task.setTrangThai(dto.getTrangThai());
        }

        return repository.save(task);
    }

    @Override
    public Task update(Long id, TaskDTO dto) {
        Task task = getById(id); // ném 404 nếu không có

        // Nếu đổi tieuDe, kiểm tra trùng với task KHÁC (không phải chính nó)
        boolean tieuDeThayDoi = !task.getTieuDe().equals(dto.getTieuDe());
        if (tieuDeThayDoi && repository.existsByTieuDe(dto.getTieuDe())) {
            throw new BusinessException(
                    "tieuDe",
                    dto.getTieuDe(),
                    "Task với tiêu đề '" + dto.getTieuDe() + "' đã tồn tại"
            );
        }

        task.setTieuDe(dto.getTieuDe());
        task.setMoTa(dto.getMoTa());
        if (dto.getTrangThai() != null && !dto.getTrangThai().isBlank()) {
            task.setTrangThai(dto.getTrangThai());
        }

        return repository.save(task);
    }

    @Override
    public void delete(Long id) {
        getById(id); // ném 404 nếu không có
        repository.deleteById(id);
    }
}
