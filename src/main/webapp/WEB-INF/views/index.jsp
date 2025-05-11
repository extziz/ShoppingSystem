<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Shopping System</title>
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
                        <h1 class="mb-0">Shopping System</h1>
                    </div>
                    <div class="card-body">
                        <p class="lead">Welcome to the Shopping System. Please select an option below:</p>
                        <div class="d-grid gap-2">

                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/products/create" class="btn btn-primary btn-lg">
                                <i class="bi bi-plus-circle"></i> Create New Product
                            </a>
                            <!-- Add more menu options here as needed -->
                        </div>
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/products/add" class="btn btn-primary btn-lg">
                                <i class="bi bi-plus-circle"></i> Add Product to Store
                            </a>
                            <!-- Add more menu options here as needed -->
                        </div>
                        </div>
                    </div>
                </div>

                <!-- Optional: Add a footer card with additional information -->
                <div class="card mt-3">
                    <div class="card-body text-center text-muted">
                        <small>Shopping System &copy; 2025</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</body>
</html>
