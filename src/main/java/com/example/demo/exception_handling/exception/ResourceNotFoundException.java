package com.example.demo.exception_handling.exception;

// Bài 4: Ném khi tìm không thấy resource trong DB → HTTP 404
// Extends RuntimeException: không cần khai báo throws ở mọi method
public class ResourceNotFoundException extends RuntimeException {

    private final String resourceName; // "Task", "User"...
    private final Long   resourceId;   // id không tìm thấy

    public ResourceNotFoundException(String resourceName, Long id) {
        // Message tự động: "Task không tìm thấy với ID: 99"
        super(resourceName + " không tìm thấy với ID: " + id);
        this.resourceName = resourceName;
        this.resourceId   = id;
    }

    public String getResourceName() { return resourceName; }
    public Long   getResourceId()   { return resourceId; }
}
