package com.example.demo.baiB;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.*;

// Khai báo đây là một Constraint Annotation
@Constraint(validatedBy = KhongChuaTuCamValidator.class)
// Annotation này chỉ áp dụng cho field
@Target({ ElementType.FIELD })
// Annotation tồn tại lúc runtime để Spring đọc được
@Retention(RetentionPolicy.RUNTIME)
public @interface KhongChuaTuCam {

    // 3 thuộc tính BẮT BUỘC phải có với mọi custom constraint
    String message() default "Nội dung chứa từ bị cấm";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
