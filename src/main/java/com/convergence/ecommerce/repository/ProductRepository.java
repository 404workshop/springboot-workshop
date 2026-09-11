package com.convergence.ecommerce.repository;

import com.convergence.ecommerce.model.ProductEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<ProductEntity, Long> {
}
