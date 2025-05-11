package com.softserve.academy.service;


import com.softserve.academy.model.Product;
import com.softserve.academy.model.ProductStore;
import com.softserve.academy.model.Store;

import com.softserve.academy.repository.ProductRepository;
import com.softserve.academy.repository.ProductStoreRepository;
import com.softserve.academy.repository.StoreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProductStoreService {
    private final ProductStoreRepository productStoreRepository;
    private final ProductRepository productRepository;
    private final StoreRepository storeRepository;

    @Autowired
    public ProductStoreService(ProductStoreRepository productStoreRepository,
                               ProductRepository productRepository, StoreRepository storeRepository) {
        this.productStoreRepository = productStoreRepository;
        this.productRepository = productRepository;
        this.storeRepository = storeRepository;
    }

    public ProductStore saveProductToStore(ProductStore productStore) {
        setProductIfExists(productStore);
        setStoreIfExists(productStore);
        return productStoreRepository.save(productStore);
    }

    private void setProductIfExists(ProductStore productStore) {
        if (productStore.getProduct() != null && productStore.getProduct().getId() != null) {
            Product product = productRepository.findById(productStore.getProduct().getId())
                .orElseThrow(() -> new RuntimeException("Product not found"));
            productStore.setProduct(product);
        }
    }

    private void setStoreIfExists(ProductStore productStore) {
        if (productStore.getStore() != null && productStore.getStore().getId() != null) {
            Store store = storeRepository.findById(productStore.getStore().getId())
                .orElseThrow(() -> new RuntimeException("Store not found"));
            productStore.setStore(store);
        }
    }
}