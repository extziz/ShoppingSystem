<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Purchase Product</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/resources/css/custom.css?v=1.3" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-10 offset-md-1">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h2 class="mb-0">Purchase Product</h2>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h4>Product Details</h4>
                                    </div>
                                    <div class="card-body">
                                        <h5>${product.name}</h5>
                                        <p>Price: <fmt:formatNumber value="${product.price}" type="currency"/></p>
                                        <p>Store: ${store.name}</p>
                                        <p>Location: ${store.location}</p>
                                        <p>Available Quantity: <span class="badge ${productStore.productQuantity > 0 ? 'bg-success' : 'bg-danger'}">${productStore.productQuantity}</span></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h4>Customer Registration</h4>
                                    </div>
                                    <div class="card-body">
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger">${errorMessage}</div>
                                        </c:if>
                                        <c:if test="${not empty successMessage}">
                                            <div class="alert alert-success">${successMessage}</div>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/products/purchase" method="post">
                                            <input type="hidden" name="productId" value="${product.id}">
                                            <input type="hidden" name="storeId" value="${store.id}">
                                            <input type="hidden" name="productStoreId" value="${productStore.id}">

                                            <div class="mb-3">
                                                <label for="name" class="form-label">Name</label>
                                                <input type="text" class="form-control" id="name" name="name" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="email" class="form-label">Email</label>
                                                <input type="email" class="form-control" id="email" name="email" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="phoneNumber" class="form-label">Phone Number</label>
                                                <input type="text" class="form-control" id="phoneNumber" name="phoneNumber">
                                            </div>
                                            <div class="mb-3">
                                                <label for="quantity" class="form-label">Quantity</label>
                                                <input type="number" class="form-control" id="quantity" name="quantity" min="1" max="${productStore.productQuantity}" required>
                                            </div>
                                            <div class="d-grid gap-2">
                                                <button type="submit" class="btn btn-success">Checkout</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/products/search" class="btn btn-secondary">Back to Search</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
