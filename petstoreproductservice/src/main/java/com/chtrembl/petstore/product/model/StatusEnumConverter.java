package com.chtrembl.petstore.product.model;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class StatusEnumConverter implements AttributeConverter<Product.StatusEnum, String> {

    @Override
    public String convertToDatabaseColumn(Product.StatusEnum statusEnum) {
        if (statusEnum == null) {
            return null;
        }
        return statusEnum.getValue();
    }

    @Override
    public Product.StatusEnum convertToEntityAttribute(String value) {
        if (value == null) {
            return null;
        }
        return Product.StatusEnum.fromValue(value);
    }
}