package com.softserve.academy.repository;


import com.softserve.academy.model.ProductStore;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductStoreRepository extends JpaRepository<ProductStore, Long> {
    ProductStore save(ProductStore productStore);
}
