<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Create New Product</title>
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
                        <h2 class="mb-0">Create New Product</h2>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success">${successMessage}</div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger">${errorMessage}</div>
                        </c:if>

                        <form:form action="${pageContext.request.contextPath}/products/create" method="post" modelAttribute="product" class="needs-validation" novalidate="true">
                            <div class="mb-3">
                                <label for="name" class="form-label">Product Name:</label>
                                <form:input path="name" id="name" required="true" class="form-control" />
                            </div>

                            <div class="mb-3">
                                <label for="price" class="form-label">Price:</label>
                                <form:input path="price" id="price" type="number" step="0.01" required="true" class="form-control" />
                            </div>

                            <div class="mb-3">
                                <label for="category" class="form-label">Category:</label>
                                <form:select path="category.id" id="category" required="true" class="form-select">
                                    <form:option value="" label="-- Select Category --" />
                                    <c:forEach items="${categories}" var="category">
                                        <form:option value="${category.id}" label="${category.name}" />
                                    </c:forEach>
                                </form:select>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Create Product</button>
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
</body>
</html>
