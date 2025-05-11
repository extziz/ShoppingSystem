package com.softserve.academy.repository;

import com.softserve.academy.model.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repository interface for Customer entity.
 * Provides CRUD operations and custom query methods for Customer.
 */
@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    
    /**
     * Find a customer by email.
     * 
     * @param email the email to search for
     * @return an Optional containing the customer if found, or empty if not found
     */
    Optional<Customer> findByEmail(String email);
    
    /**
     * Find a customer by phone number.
     * 
     * @param phoneNumber the phone number to search for
     * @return an Optional containing the customer if found, or empty if not found
     */
    Optional<Customer> findByPhoneNumber(String phoneNumber);
    
    /**
     * Check if a customer with the given email exists.
     * 
     * @param email the email to check
     * @return true if a customer with the email exists, false otherwise
     */
    boolean existsByEmail(String email);
}