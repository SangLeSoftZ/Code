package com.example.demo.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

// @RestControllerAdvice: bắt exception từ tất cả Controller, trả về JSON
@RestControllerAdvice
public class GlobalExceptionHandler {

    // Bắt lỗi khi @Valid thất bại → MethodArgumentNotValidException
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationError(
            MethodArgumentNotValidException ex) {

        Map<String, String> errors = new HashMap<>();

        // Duyệt qua từng field bị lỗi, lấy tên field và message
        ex.getBindingResult()
          .getFieldErrors()
          .forEach(err -> errors.put(err.getField(), err.getDefaultMessage()));

        // Trả về HTTP 400 kèm danh sách lỗi dạng JSON
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errors);
    }
}
