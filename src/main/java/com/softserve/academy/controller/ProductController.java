package com.softserve.academy.controller;

import com.softserve.academy.dto.ProductDTO;
import com.softserve.academy.model.Category;
import com.softserve.academy.model.Product;
import com.softserve.academy.model.ProductStore;
import com.softserve.academy.model.Store;
import com.softserve.academy.service.ProductService;
import com.softserve.academy.service.ProductStoreService;
import com.softserve.academy.service.StoreService;
import org.hibernate.PropertyValueException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;
    private final StoreService storeService;
    private final ProductStoreService productStoreService;

    @Autowired
    public ProductController(ProductService productService, StoreService storeService, ProductStoreService productStoreService) {
        this.productService = productService;
        this.storeService = storeService;
        this.productStoreService = productStoreService;
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("product", new Product());

        // Add all categories to the model for the dropdown
        List<Category> categories = productService.getAllCategories();
        model.addAttribute("categories", categories);

        return "product/create";
    }

    @PostMapping("/create")
    public String createProduct(@ModelAttribute Product product, RedirectAttributes redirectAttributes) {
        try {
            productService.saveProduct(product);
            redirectAttributes.addFlashAttribute("successMessage", "Product created successfully!");
        } catch (PropertyValueException pve) {
            String property = pve.getPropertyName();
            String errorMessage = switch (property) {
                case "price" -> "Please provide a valid price for the product.";
                case "name" -> "Please provide a name for the product.";
                default -> "Please provide a value for " + property + ".";
            };
            redirectAttributes.addFlashAttribute("errorMessage", errorMessage);
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error creating product: " + e.getMessage());
        }
        return "redirect:/products/create";
    }
    @GetMapping("/add")
    public String showAddProductToStoreForm(Model model) {
        ProductStore productStore = new ProductStore();
        productStore.setProduct(new Product());
        productStore.setStore(new Store());
        model.addAttribute("productStore", productStore);

        List<Category> categories = productService.getAllCategories();
        model.addAttribute("categories", categories);
        List<Store> stores = storeService.getAllStores();
        model.addAttribute("stores", stores);
        return "product/addProductToStore";
    }
    @GetMapping("/by-category/{id}")
    @ResponseBody
    public List<ProductDTO> getProductByCategory(@PathVariable("id") String categoryId) {
        return productService.getProductsByCategory(Long.parseLong(categoryId))
                .stream()
                .map(ProductDTO::new)
                .collect(Collectors.toList());
    }
    @PostMapping("/add")
    public String addProductToStore(@ModelAttribute ProductStore productStore, RedirectAttributes redirectAttributes) {
        try {
            productStoreService.saveProductToStore(productStore);
            redirectAttributes.addFlashAttribute("successMessage", "Product added to Store successfully!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error adding product to Store: " + e.getMessage());
        }
        return "redirect:/products/add";
    }
}
