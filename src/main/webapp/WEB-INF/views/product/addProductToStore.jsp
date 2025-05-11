<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Product to Store</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/resources/css/custom.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h2 class="mb-0">Add Product to Store</h2>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success">${successMessage}</div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger">${errorMessage}</div>
                        </c:if>

                        <form:form action="${pageContext.request.contextPath}/products/add" method="post" modelAttribute="productStore" class="needs-validation">
                            <div class="mb-3">
                                <label for="category" class="form-label">Product Category:</label>
                                <select id="category" class="form-select" required>
                                    <option value="">-- Select Category --</option>
                                    <c:forEach items="${categories}" var="category">
                                        <option value="${category.id}">${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="product.id" class="form-label">Product:</label>
                                <form:select path="product.id" id="product" class="form-select" required="required">
                                    <form:option value="">-- Select Product --</form:option>
                                </form:select>
                            </div>

                            <div class="mb-3">
                                <label for="productQuantity" class="form-label">Product Quantity:</label>
                                <form:input path="productQuantity" id="productQuantity" type="number" min="0" required="required" class="form-control" />
                            </div>

                            <div class="mb-3">
                                <label for="store.id" class="form-label">Store:</label>
                                <form:select path="store.id" id="store" class="form-select" required="required">
                                    <form:option value="">-- Select Store --</form:option>
                                    <c:forEach items="${stores}" var="store">
                                        <form:option value="${store.id}">${store.name} - ${store.location}</form:option>
                                    </c:forEach>
                                </form:select>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Add to Store</button>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Back to Home</a>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JavaScript for dynamic product filtering based on category -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const categorySelect = document.getElementById('category');
            const productSelect = document.getElementById('product');

            categorySelect.addEventListener('change', function() {
                const selectedCategoryId = this.value;

                // Clear current options
                while (productSelect.options.length > 1) {
                    productSelect.remove(1);
                }

                if (selectedCategoryId) {
                    // Filter products by selected category
                    fetch('${pageContext.request.contextPath}/products/by-category/' + selectedCategoryId)
                        .then(response => response.json())
                        .then(products => {
                            products.forEach(product => {
                                const option = document.createElement('option');
                                option.value = product.id;
                                option.textContent = product.name + ' - $' + product.price;
                                productSelect.appendChild(option);
                            });
                        })
                        .catch(error => console.error('Error loading products:', error));
                }
            });
        });
    </script>
</body>
</html>
