package com.example.demo.baiB.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class KhongChuaTuCamValidator implements ConstraintValidator<KhongChuaTuCam, String> {

    private static final String TU_CAM = "spam";

    @Override
    public void initialize(KhongChuaTuCam annotation) {}

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if (value == null) return true;
        return !value.toLowerCase().contains(TU_CAM);
    }
}
