package com.example.demo.baiB;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

// ConstraintValidator<Annotation, KiểuDữLiệuCầnValidate>
public class KhongChuaTuCamValidator implements ConstraintValidator<KhongChuaTuCam, String> {

    private static final String TU_CAM = "spam";

    // initialize() chạy 1 lần khi khởi tạo — dùng để đọc config từ annotation
    // Bài này đơn giản nên để trống
    @Override
    public void initialize(KhongChuaTuCam annotation) { }

    // isValid() là nơi chứa logic kiểm tra thực sự
    // Trả về true → hợp lệ | false → báo lỗi
    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        // Cho phép null (để @NotNull/NotBlank lo việc kiểm tra null riêng)
        if (value == null) return true;

        // Kiểm tra có chứa từ cấm không (không phân biệt hoa thường)
        return !value.toLowerCase().contains(TU_CAM);
    }
}
