package com.example.demo.exception_handling.controller;

import com.example.demo.exception_handling.dto.TaskDTO;
import com.example.demo.exception_handling.entity.Task;
import com.example.demo.exception_handling.service.TaskService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Task API", description = "CRUD cho Task — demo Exception Handling & Validation")
@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    private final TaskService service;

    public TaskController(TaskService service) {
        this.service = service;
    }

    @Operation(summary = "Lấy tất cả tasks")
    @ApiResponse(responseCode = "200", description = "Thành công")
    @GetMapping
    public ResponseEntity<List<Task>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    @Operation(summary = "Lấy task theo ID",
               description = "Ném ResourceNotFoundException → 404 nếu không tìm thấy")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Tìm thấy task"),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy",
                     content = @Content(schema = @Schema(implementation = Object.class)))
    })
    @GetMapping("/{id}")
    public ResponseEntity<Task> getById(
            @Parameter(description = "ID của task", example = "1")
            @PathVariable Long id) {
        return ResponseEntity.ok(service.getById(id));
    }

    @Operation(summary = "Tạo task mới",
               description = "409 nếu tiêu đề trùng, 400 nếu @Valid fail")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Tạo thành công"),
        @ApiResponse(responseCode = "400", description = "Dữ liệu không hợp lệ"),
        @ApiResponse(responseCode = "409", description = "Tiêu đề đã tồn tại")
    })
    @PostMapping
    public ResponseEntity<Task> create(@Valid @RequestBody TaskDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(dto));
    }

    @Operation(summary = "Cập nhật task")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Cập nhật thành công"),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy task"),
        @ApiResponse(responseCode = "409", description = "Tiêu đề mới bị trùng")
    })
    @PutMapping("/{id}")
    public ResponseEntity<Task> update(
            @Parameter(description = "ID của task", example = "1")
            @PathVariable Long id,
            @Valid @RequestBody TaskDTO dto) {
        return ResponseEntity.ok(service.update(id, dto));
    }

    @Operation(summary = "Xóa task")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Xóa thành công"),
        @ApiResponse(responseCode = "404", description = "Không tìm thấy task")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @Parameter(description = "ID của task", example = "1")
            @PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
