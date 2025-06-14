package com.chtrembl.petstore.product.service;

import com.chtrembl.petstore.product.model.Product;
import com.chtrembl.petstore.product.repository.PetProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class ProductService {

    private final PetProductRepository petProductRepository;

    public List<Product> findProductsByStatus(List<String> status) {
        log.info("Finding products with status: {}", status);

        return petProductRepository
                .findProductsByStatusIsIn(
                        status.stream()
                                .map(Product.StatusEnum::valueOf)
                                .collect(Collectors.toList())
                );
    }

    public Optional<Product> findProductById(Long productId) {
        log.info("Finding product with id: {}", productId);

        return petProductRepository.findProductByIdIs(productId);
    }

    public List<Product> getAllProducts() {
        log.info("Getting all products");
        return petProductRepository.findAll();
    }

    public Long getProductCount() {
        return petProductRepository.count();
    }
}