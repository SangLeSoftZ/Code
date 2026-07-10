package com.example.demo.exception_handling.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

// @RestControllerAdvice: lắng nghe exception từ TẤT CẢ controller
// Bắt exception → trả ApiError dạng JSON chuẩn
@RestControllerAdvice
public class GlobalExceptionHandler {

    // ===================== BÀI 4 =====================
    // Bắt ResourceNotFoundException → HTTP 404
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(
            ResourceNotFoundException ex,
            HttpServletRequest request) {

        ApiError error = new ApiError(
                404,
                "Not Found",
                ex.getMessage(),          // "Task không tìm thấy với ID: 99"
                request.getRequestURI()   // "/api/tasks/99"
        );

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    // ===================== BÀI 5 =====================
    // Bắt BusinessException → HTTP 409 Conflict
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiError> handleBusiness(
            BusinessException ex,
            HttpServletRequest request) {

        ApiError error = new ApiError(
                409,
                "Conflict",
                ex.getMessage(),         // "Task với tiêu đề '...' đã tồn tại"
                request.getRequestURI()  // "/api/tasks"
        );

        return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
    }

    // ===================== VALIDATION =====================
    // Bắt lỗi @Valid (@NotBlank, @Size...) → HTTP 400
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidation(
            MethodArgumentNotValidException ex,
            HttpServletRequest request) {

        // Gom tất cả field lỗi vào Map
        Map<String, String> fieldErrors = new HashMap<>();
        ex.getBindingResult()
          .getFieldErrors()
          .forEach(err -> fieldErrors.put(err.getField(), err.getDefaultMessage()));

        Map<String, Object> body = new HashMap<>();
        body.put("status",  400);
        body.put("error",   "Bad Request");
        body.put("message", "Dữ liệu không hợp lệ");
        body.put("path",    request.getRequestURI());
        body.put("fields",  fieldErrors); // chi tiết từng field lỗi

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    // ===================== FALLBACK =====================
    // Bắt tất cả exception không xử lý ở trên → HTTP 500
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleGeneral(
            Exception ex,
            HttpServletRequest request) {

        ApiError error = new ApiError(
                500,
                "Internal Server Error",
                "Đã xảy ra lỗi hệ thống",
                request.getRequestURI()
        );

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
