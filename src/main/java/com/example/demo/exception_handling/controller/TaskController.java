package com.example.demo.exception_handling.controller;

import com.example.demo.exception_handling.dto.TaskDTO;
import com.example.demo.exception_handling.entity.Task;
import com.example.demo.exception_handling.service.TaskService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    private final TaskService service;

    public TaskController(TaskService service) {
        this.service = service;
    }

    // GET /api/tasks
    @GetMapping
    public ResponseEntity<List<Task>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    // GET /api/tasks/{id}
    // Bài 4: nếu id không tồn tại → ResourceNotFoundException → 404 + ApiError
    @GetMapping("/{id}")
    public ResponseEntity<Task> getById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getById(id));
    }

    // POST /api/tasks
    // Bài 5: nếu tieuDe trùng → BusinessException → 409 + ApiError
    // @Valid: nếu @NotBlank/@Size fail → 400 + ApiError
    @PostMapping
    public ResponseEntity<Task> create(@Valid @RequestBody TaskDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(dto));
    }

    // PUT /api/tasks/{id}
    @PutMapping("/{id}")
    public ResponseEntity<Task> update(
            @PathVariable Long id,
            @Valid @RequestBody TaskDTO dto) {
        return ResponseEntity.ok(service.update(id, dto));
    }

    // DELETE /api/tasks/{id}
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
