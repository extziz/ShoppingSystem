<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Search for Products</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/resources/css/custom.css?v=1.2" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h2 class="mb-0">Search for Products</h2>
                    </div>
                    <div class="card-body">
                        <c:if test="${notFound}">
                            <div class="alert alert-warning">No products found with that name. Please try again.</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/products/find" method="get" class="needs-validation" novalidate>
                            <div class="mb-3">
                                <label for="productName" class="form-label">Product Name:</label>
                                <input type="text" name="productName" id="productName" required class="form-control" 
                                       placeholder="Enter product name or part of name" />
                                <div class="form-text">Enter full or partial product name to search</div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success">Search Products</button>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Back to Home</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
