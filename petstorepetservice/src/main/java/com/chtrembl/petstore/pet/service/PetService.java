package com.chtrembl.petstore.pet.service;

import com.chtrembl.petstore.pet.model.Pet;
import com.chtrembl.petstore.pet.repository.PetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class PetService {

    private final PetRepository petRepository;

    public List<Pet> findPetsByStatus(List<String> status) {
        log.info("Finding pets with status: {}", status);

        return petRepository.findPetsByStatusIsIn(
                status.stream()
                        .map(Pet.StatusEnum::valueOf)
                        .collect(Collectors.toList())
        );
    }

    public Optional<Pet> findPetById(Long petId) {
        log.info("Finding pet with id: {}", petId);

        return petRepository.findPetByIdIs(petId);
    }

    public List<Pet> getAllPets() {
        log.info("Getting all pets");
        return petRepository.findAll();
    }

    public Long getPetCount() {
        return petRepository.count();
    }
}