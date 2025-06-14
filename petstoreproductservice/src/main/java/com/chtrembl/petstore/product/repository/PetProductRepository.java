package com.chtrembl.petstore.product.repository;

import com.chtrembl.petstore.product.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

@Repository
public interface PetProductRepository extends JpaRepository<Product,String> {
    List<Product> findProductsByStatusIsIn(Collection<Product.StatusEnum> status);
    Optional<Product> findProductByIdIs(Long id);
}
