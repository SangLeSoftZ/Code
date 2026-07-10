package com.example.demo.exception_handling.exception;

// Bài 5: Ném khi vi phạm logic nghiệp vụ → HTTP 409 Conflict
// Ví dụ: tạo Task có tiêu đề trùng với task đã tồn tại
public class BusinessException extends RuntimeException {

    private final String field;   // field bị vi phạm: "tieuDe"
    private final Object value;   // giá trị bị trùng: "Học Spring Boot"

    public BusinessException(String field, Object value, String message) {
        super(message);
        this.field = field;
        this.value = value;
    }

    public String getField() { return field; }
    public Object getValue() { return value; }
}
