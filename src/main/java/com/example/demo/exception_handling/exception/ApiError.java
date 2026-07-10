package com.example.demo.exception_handling.exception;

import java.time.LocalDateTime;

// Cấu trúc response lỗi chuẩn — trả về cho client khi có exception
// Mọi lỗi đều có cùng format này → client dễ xử lý
public class ApiError {

    private int status;           // HTTP status code: 404, 400, 500...
    private String error;         // tên lỗi: "Not Found", "Bad Request"...
    private String message;       // mô tả lỗi chi tiết
    private String path;          // URL bị lỗi: "/api/tasks/99"
    private LocalDateTime timestamp; // thời điểm xảy ra lỗi

    public ApiError(int status, String error, String message, String path) {
        this.status    = status;
        this.error     = error;
        this.message   = message;
        this.path      = path;
        this.timestamp = LocalDateTime.now();
    }

    // Getters
    public int getStatus()             { return status; }
    public String getError()           { return error; }
    public String getMessage()         { return message; }
    public String getPath()            { return path; }
    public LocalDateTime getTimestamp(){ return timestamp; }
}
