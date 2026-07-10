package com.example.demo.bai6;

import com.example.demo.exception_handling.dto.TaskDTO;
import com.example.demo.exception_handling.entity.Task;
import com.example.demo.exception_handling.exception.BusinessException;
import com.example.demo.exception_handling.exception.ResourceNotFoundException;
import com.example.demo.exception_handling.repository.TaskRepository;
import com.example.demo.exception_handling.service.impl.TaskServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

// @ExtendWith: kích hoạt Mockito trong JUnit 5 — không cần Spring context
// → test chạy nhanh, không cần DB thật
@ExtendWith(MockitoExtension.class)
@DisplayName("Bài 6 — TaskService Unit Test")
class TaskServiceTest {

    // @Mock: tạo object giả của TaskRepository
    // Không kết nối DB — ta tự điều khiển nó trả về gì
    @Mock
    private TaskRepository taskRepository;

    // @InjectMocks: tạo TaskServiceImpl và inject @Mock vào
    @InjectMocks
    private TaskServiceImpl taskService;

    private Task task1;
    private Task task2;

    // @BeforeEach: chạy trước MỖI test — setup data dùng chung
    @BeforeEach
    void setUp() {
        task1 = new Task("Học Spring Boot", "Học JPA, REST API");
        task2 = new Task("Làm bài tập JWT", "Viết login, profile");
    }

    // ================================================================
    // TEST 1: getAll() thành công → trả danh sách
    // ================================================================
    @Test
    @DisplayName("getAll() → trả danh sách tasks từ repository")
    void getAll_TraVeDanhSach_ThanhCong() {
        // ARRANGE: giả lập repository trả về list 2 task
        when(taskRepository.findAll()).thenReturn(List.of(task1, task2));

        // ACT
        List<Task> result = taskService.getAll();

        // ASSERT
        assertThat(result).isNotNull();
        assertThat(result).hasSize(2);
        assertThat(result.get(0).getTieuDe()).isEqualTo("Học Spring Boot");
        assertThat(result.get(1).getTieuDe()).isEqualTo("Làm bài tập JWT");
        verify(taskRepository, times(1)).findAll();
    }

    // ================================================================
    // TEST 2: getAll() → repository rỗng → trả list rỗng
    // ================================================================
    @Test
    @DisplayName("getAll() → repository rỗng → trả list rỗng, không ném lỗi")
    void getAll_RepositoryRong_TraListRong() {
        when(taskRepository.findAll()).thenReturn(List.of());

        List<Task> result = taskService.getAll();

        assertThat(result).isNotNull();
        assertThat(result).isEmpty();
    }

    // ================================================================
    // TEST 3: getById() tìm thấy → trả task
    // ================================================================
    @Test
    @DisplayName("getById(1) → tìm thấy → trả task đúng")
    void getById_TimThay_TraTask() {
        when(taskRepository.findById(1L)).thenReturn(Optional.of(task1));

        Task result = taskService.getById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getTieuDe()).isEqualTo("Học Spring Boot");
    }

    // ================================================================
    // TEST 4: getById() KHÔNG tìm thấy → ném ResourceNotFoundException
    // BÀI 4: đây là test chính
    // ================================================================
    @Test
    @DisplayName("getById(999) → không tìm thấy → ném ResourceNotFoundException")
    void getById_KhongTimThay_NemResourceNotFoundException() {
        // ARRANGE: Optional rỗng = không tìm thấy
        when(taskRepository.findById(999L)).thenReturn(Optional.empty());

        // ASSERT + ACT: kiểm tra exception được ném
        assertThatThrownBy(() -> taskService.getById(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Task")
                .hasMessageContaining("999");

        verify(taskRepository, times(1)).findById(999L);
    }

    // ================================================================
    // TEST 5: create() tieuDe mới → tạo thành công
    // ================================================================
    @Test
    @DisplayName("create() → tiêu đề mới → lưu và trả task")
    void create_TieuDeMoi_TaoThanhCong() {
        TaskDTO dto = new TaskDTO();
        dto.setTieuDe("Task mới");
        dto.setMoTa("Mô tả mới");

        when(taskRepository.existsByTieuDe("Task mới")).thenReturn(false);
        when(taskRepository.save(any(Task.class))).thenReturn(new Task("Task mới", "Mô tả mới"));

        Task result = taskService.create(dto);

        assertThat(result).isNotNull();
        assertThat(result.getTieuDe()).isEqualTo("Task mới");
        verify(taskRepository, times(1)).existsByTieuDe("Task mới");
        verify(taskRepository, times(1)).save(any(Task.class));
    }

    // ================================================================
    // TEST 6: create() tieuDe trùng → ném BusinessException
    // BÀI 5: đây là test chính
    // ================================================================
    @Test
    @DisplayName("create() → tiêu đề trùng → ném BusinessException")
    void create_TieuDeTrung_NemBusinessException() {
        TaskDTO dto = new TaskDTO();
        dto.setTieuDe("Học Spring Boot");

        when(taskRepository.existsByTieuDe("Học Spring Boot")).thenReturn(true);

        assertThatThrownBy(() -> taskService.create(dto))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Học Spring Boot")
                .hasMessageContaining("đã tồn tại");

        // save() KHÔNG được gọi khi bị trùng
        verify(taskRepository, never()).save(any(Task.class));
    }
}
