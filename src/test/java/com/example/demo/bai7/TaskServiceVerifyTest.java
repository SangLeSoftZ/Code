package com.example.demo.bai7;

import com.example.demo.exception_handling.dto.TaskDTO;
import com.example.demo.exception_handling.entity.Task;
import com.example.demo.exception_handling.repository.TaskRepository;
import com.example.demo.exception_handling.service.impl.TaskServiceImpl;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

// Bài 7: Tập trung vào verify() — xác nhận mock được gọi đúng cách
// verify() trả lời: method này gọi không? gọi mấy lần? tham số đúng không?
@ExtendWith(MockitoExtension.class)
@DisplayName("Bài 7 — Verify tham số và số lần gọi mock")
class TaskServiceVerifyTest {

    @Mock
    private TaskRepository taskRepository;

    @InjectMocks
    private TaskServiceImpl taskService;

    // ================================================================
    // TEST 1: verify existsByTieuDe gọi đúng 1 lần với đúng tham số
    // ================================================================
    @Test
    @DisplayName("create() → verify existsByTieuDe('Task ABC') gọi đúng 1 lần")
    void create_VerifyExistsByTieuDeGoiDung1Lan() {
        TaskDTO dto = new TaskDTO();
        dto.setTieuDe("Task ABC");
        dto.setMoTa("Mô tả");

        when(taskRepository.existsByTieuDe("Task ABC")).thenReturn(false);
        when(taskRepository.save(any(Task.class))).thenReturn(new Task("Task ABC", "Mô tả"));

        // ACT
        taskService.create(dto);

        // VERIFY: existsByTieuDe gọi đúng 1 lần với đúng tham số "Task ABC"
        // Nếu gọi với tham số khác hoặc gọi 2 lần → test FAIL
        verify(taskRepository, times(1)).existsByTieuDe("Task ABC");
        verify(taskRepository, times(1)).save(any(Task.class));
        verify(taskRepository, never()).findById(anyLong());
    }

    // ================================================================
    // TEST 2: verify findById gọi đúng 1 lần với đúng id
    // ================================================================
    @Test
    @DisplayName("getById(5) → verify findById(5L) gọi đúng 1 lần")
    void getById_VerifyFindByIdGoiDung1Lan() {
        when(taskRepository.findById(5L)).thenReturn(Optional.of(new Task("Task 5", "Mô tả")));

        taskService.getById(5L);

        // Nếu gọi findById(4L) hoặc findById(6L) → test FAIL
        verify(taskRepository, times(1)).findById(5L);
        verify(taskRepository, never()).save(any(Task.class));
        verify(taskRepository, never()).existsByTieuDe(anyString());
    }

    // ================================================================
    // TEST 3: verify delete() gọi đúng thứ tự: findById trước, deleteById sau
    // ================================================================
    @Test
    @DisplayName("delete(3) → verify thứ tự: findById trước rồi mới deleteById")
    void delete_VerifyThuTuGoiDung() {
        when(taskRepository.findById(3L)).thenReturn(Optional.of(new Task("Task 3", "...")));

        taskService.delete(3L);

        // InOrder: đảm bảo findById gọi TRƯỚC deleteById
        var inOrder = inOrder(taskRepository);
        inOrder.verify(taskRepository).findById(3L);
        inOrder.verify(taskRepository).deleteById(3L);

        verify(taskRepository, times(1)).findById(3L);
        verify(taskRepository, times(1)).deleteById(3L);
    }

    // ================================================================
    // TEST 4: tieuDe trùng → verify save() KHÔNG được gọi
    // ================================================================
    @Test
    @DisplayName("create() tiêu đề trùng → verify save() không bao giờ được gọi")
    void create_TieuDeTrung_VerifySaveKhongDuocGoi() {
        TaskDTO dto = new TaskDTO();
        dto.setTieuDe("Tiêu đề trùng");

        when(taskRepository.existsByTieuDe("Tiêu đề trùng")).thenReturn(true);

        assertThatThrownBy(() -> taskService.create(dto))
                .isInstanceOf(RuntimeException.class);

        verify(taskRepository, times(1)).existsByTieuDe("Tiêu đề trùng");
        // save() không được gọi → không có data nào insert nhầm vào DB
        verify(taskRepository, never()).save(any(Task.class));
    }

    // ================================================================
    // TEST 5: verifyNoMoreInteractions — không có gọi thừa
    // ================================================================
    @Test
    @DisplayName("getById() → verify không có interaction nào thừa")
    void getById_VerifyKhongCoInteractionThua() {
        when(taskRepository.findById(1L)).thenReturn(Optional.of(new Task("Task 1", "Mô tả")));

        taskService.getById(1L);

        verify(taskRepository).findById(1L);
        // Đảm bảo KHÔNG có method nào khác của taskRepository bị gọi thêm
        verifyNoMoreInteractions(taskRepository);
    }
}
