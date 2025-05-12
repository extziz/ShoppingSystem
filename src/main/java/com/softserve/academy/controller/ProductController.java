package com.softserve.academy.controller;

import com.softserve.academy.dto.ProductDTO;
import com.softserve.academy.model.*;
import com.softserve.academy.repository.CustomerRepository;
import com.softserve.academy.repository.PurchaseRepository;
import com.softserve.academy.service.ProductService;
import com.softserve.academy.service.ProductStoreService;
import com.softserve.academy.service.StoreService;
import org.hibernate.PropertyValueException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;
    private final StoreService storeService;
    private final ProductStoreService productStoreService;
    private final CustomerRepository customerRepository;
    private final PurchaseRepository purchaseRepository;

    @Autowired
    public ProductController(ProductService productService, 
                            StoreService storeService, 
                            ProductStoreService productStoreService,
                            CustomerRepository customerRepository,
                            PurchaseRepository purchaseRepository) {
        this.productService = productService;
        this.storeService = storeService;
        this.productStoreService = productStoreService;
        this.customerRepository = customerRepository;
        this.purchaseRepository = purchaseRepository;
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
            // Check if price is greater than 0
            if (product.getPrice() != null && product.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
                redirectAttributes.addFlashAttribute("errorMessage", "Product price must be greater than 0.");
                return "redirect:/products/create";
            }

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

    @GetMapping("/search")
    public String showSearchForm() {
        return "product/search";
    }

    @GetMapping("/find")
    public String findProduct(@RequestParam("productName") String productName, Model model) {
        List<Product> products = productService.findProductsByName(productName);

        if (products.isEmpty()) {
            model.addAttribute("notFound", true);
            return "product/search";
        }

        Map<Product, List<Map<String, Object>>> productStoresMap = new HashMap<>();

        for (Product product : products) {
            List<ProductStore> productStores = productStoreService.findStoresByProductId(product.getId());
            List<Map<String, Object>> storeInfoList = new ArrayList<>();

            for (ProductStore ps : productStores) {
                Map<String, Object> storeInfo = new HashMap<>();
                storeInfo.put("store", ps.getStore());
                storeInfo.put("quantity", ps.getProductQuantity());
                storeInfoList.add(storeInfo);
            }

            productStoresMap.put(product, storeInfoList);
        }

        model.addAttribute("productStoresMap", productStoresMap);
        model.addAttribute("searchTerm", productName);

        return "product/searchResults";
    }

    @GetMapping("/buy")
    public String showPurchaseForm(@RequestParam("productId") Long productId, 
                                  @RequestParam("storeId") Long storeId, 
                                  Model model) {
        // Get the product
        Product product = productService.getProductById(productId);
        if (product == null) {
            return "redirect:/products/search";
        }

        // Get the store
        Store store = storeService.getStoreById(storeId);
        if (store == null) {
            return "redirect:/products/search";
        }

        // Get the product-store relationship
        ProductStore productStore = productStoreService.findByProductAndStore(productId, storeId);
        if (productStore == null || productStore.getProductQuantity() <= 0) {
            return "redirect:/products/search";
        }

        model.addAttribute("product", product);
        model.addAttribute("store", store);
        model.addAttribute("productStore", productStore);
        model.addAttribute("searchTerm", ""); // This will be used for the back button

        return "product/purchase";
    }

    @PostMapping("/purchase")
    public String processPurchase(@RequestParam("productId") Long productId,
                                 @RequestParam("storeId") Long storeId,
                                 @RequestParam("productStoreId") Long productStoreId,
                                 @RequestParam("name") String name,
                                 @RequestParam("email") String email,
                                 @RequestParam("phoneNumber") String phoneNumber,
                                 @RequestParam("quantity") int quantity,
                                 RedirectAttributes redirectAttributes) {
        try {
            // Get the product
            Product product = productService.getProductById(productId);
            if (product == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Product not found");
                return "redirect:/products/search";
            }

            // Get the store
            Store store = storeService.getStoreById(storeId);
            if (store == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Store not found");
                return "redirect:/products/search";
            }

            // Get the product-store relationship
            ProductStore productStore = productStoreService.findByProductAndStore(productId, storeId);
            if (productStore == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Product not available in this store");
                return "redirect:/products/search";
            }

            // Check if quantity is valid
            if (quantity <= 0 || quantity > productStore.getProductQuantity()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid quantity");
                return "redirect:/products/buy?productId=" + productId + "&storeId=" + storeId;
            }

            // Find or create customer
            Customer customer;
            Optional<Customer> existingCustomer = customerRepository.findByEmail(email);

            if (existingCustomer.isPresent()) {
                customer = existingCustomer.get();
            } else {
                customer = Customer.builder()
                    .name(name)
                    .email(email)
                    .phoneNumber(phoneNumber)
                    .build();
                customerRepository.save(customer);
            }

            // Calculate total price
            BigDecimal totalPrice = product.getPrice().multiply(BigDecimal.valueOf(quantity));

            // Create purchase
            Purchase purchase = Purchase.builder()
                .customer(customer)
                .product(product)
                .quantity(quantity)
                .totalPrice(totalPrice)
                .purchaseDate(LocalDateTime.now())
                .build();

            purchaseRepository.save(purchase);

            // Update product quantity in store
            productStore.setProductQuantity(productStore.getProductQuantity() - quantity);
            productStoreService.updateProductQuantity(productStore);

            redirectAttributes.addFlashAttribute("successMessage", 
                "Purchase successful! You bought " + quantity + " " + product.getName() + " for " + totalPrice);

            return "redirect:/products/search";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error processing purchase: " + e.getMessage());
            return "redirect:/products/buy?productId=" + productId + "&storeId=" + storeId;
        }
    }
}
