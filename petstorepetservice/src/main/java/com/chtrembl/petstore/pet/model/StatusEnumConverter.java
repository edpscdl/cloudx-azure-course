package com.chtrembl.petstore.pet.model;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class StatusEnumConverter implements AttributeConverter<Pet.StatusEnum, String> {

    @Override
    public String convertToDatabaseColumn(Pet.StatusEnum statusEnum) {
        if (statusEnum == null) {
            return null;
        }
        return statusEnum.getValue();
    }

    @Override
    public Pet.StatusEnum convertToEntityAttribute(String value) {
        if (value == null) {
            return null;
        }
        return Pet.StatusEnum.fromValue(value);
    }
}