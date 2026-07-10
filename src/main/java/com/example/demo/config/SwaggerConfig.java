package com.example.demo.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import org.springframework.context.annotation.Configuration;

// Khai báo Swagger dùng Bearer JWT để xác thực
@Configuration
@OpenAPIDefinition(
    info = @Info(
        title = "SoftZ Demo API",
        version = "1.0",
        description = "API cho bài học Spring Boot — JWT, Exception Handling, Validation"
    )
)
@SecurityScheme(
    name = "bearerAuth",               // tên scheme — dùng trong @SecurityRequirement
    type = SecuritySchemeType.HTTP,
    scheme = "bearer",                 // kiểu: bearer token
    bearerFormat = "JWT"               // format: JWT
)
public class SwaggerConfig {
    // Không cần viết thêm gì — annotation lo hết
}
