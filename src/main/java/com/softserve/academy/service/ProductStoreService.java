package com.softserve.academy.service;


import com.softserve.academy.model.Product;
import com.softserve.academy.model.ProductStore;
import com.softserve.academy.model.Store;

import java.util.List;

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

        // Check if this product already exists in this store
        if (productStore.getProduct() != null && productStore.getProduct().getId() != null &&
            productStore.getStore() != null && productStore.getStore().getId() != null) {

            ProductStore existingProductStore = productStoreRepository.findByProductIdAndStoreId(
                productStore.getProduct().getId(), 
                productStore.getStore().getId()
            );

            // If product already exists in store, update quantity instead of creating new record
            if (existingProductStore != null) {
                int newQuantity = existingProductStore.getProductQuantity() + productStore.getProductQuantity();
                existingProductStore.setProductQuantity(newQuantity);
                return productStoreRepository.save(existingProductStore);
            }
        }

        // If product doesn't exist in store, create new record
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

    public List<ProductStore> findStoresByProductId(Long productId) {
        return productStoreRepository.findByProductId(productId);
    }

    public ProductStore findByProductAndStore(Long productId, Long storeId) {
        return productStoreRepository.findByProductIdAndStoreId(productId, storeId);
    }

    /**
     * Updates the quantity of a product in a store.
     * This method is used when processing purchases to directly set the new quantity.
     * 
     * @param productStore The product store with updated quantity
     * @return The updated product store
     */
    public ProductStore updateProductQuantity(ProductStore productStore) {
        setProductIfExists(productStore);
        setStoreIfExists(productStore);

        // Validate that the product store exists
        if (productStore.getId() == null) {
            throw new RuntimeException("Cannot update quantity for non-existent product store");
        }

        // Save the updated product store with the new quantity
        return productStoreRepository.save(productStore);
    }
}
