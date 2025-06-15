package com.chtrembl.petstore.pet.repository;

import com.chtrembl.petstore.pet.model.Pet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

@Repository
public interface PetRepository extends JpaRepository<Pet,String> {
    List<Pet> findPetsByStatusIsIn(Collection<Pet.StatusEnum> status);
    Optional<Pet> findPetByIdIs(Long id);
}
