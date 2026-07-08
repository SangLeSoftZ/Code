package com.example.demo.baiB.validator;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.*;

@Constraint(validatedBy = KhongChuaTuCamValidator.class)
@Target({ ElementType.FIELD })
@Retention(RetentionPolicy.RUNTIME)
public @interface KhongChuaTuCam {
    String message() default "Nội dung chứa từ bị cấm";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
