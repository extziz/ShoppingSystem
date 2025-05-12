<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Product Search Results</title>
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
                    <div class="card-header bg-success text-white">
                        <h2 class="mb-0">Search Results for "${searchTerm}"</h2>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty productStoresMap}">
                                <div class="alert alert-warning">No products found matching your search criteria.</div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${productStoresMap}" var="entry">
                                    <div class="card mb-4">
                                        <div class="card-header bg-light">
                                            <h3>${entry.key.name}</h3>
                                            <p class="mb-0">Price: <fmt:formatNumber value="${entry.key.price}" type="currency"/></p>
                                        </div>
                                        <div class="card-body">
                                            <h4>Available at:</h4>
                                            <c:choose>
                                                <c:when test="${empty entry.value}">
                                                    <p class="text-danger">This product is not available in any store.</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="table-responsive">
                                                        <table class="table table-striped table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>Store Name</th>
                                                                    <th>Location</th>
                                                                    <th>Contact</th>
                                                                    <th>Quantity Available</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${entry.value}" var="storeInfo">
                                                                    <tr>
                                                                        <td>${storeInfo.store.name}</td>
                                                                        <td>${storeInfo.store.location}</td>
                                                                        <td>
                                                                            <c:if test="${not empty storeInfo.store.contactNumber}">
                                                                                <div>Phone: ${storeInfo.store.contactNumber}</div>
                                                                            </c:if>
                                                                            <c:if test="${not empty storeInfo.store.email}">
                                                                                <div>Email: ${storeInfo.store.email}</div>
                                                                            </c:if>
                                                                        </td>
                                                                        <td>
                                                                            <span class="badge ${storeInfo.quantity > 0 ? 'bg-success' : 'bg-danger'}">
                                                                                ${storeInfo.quantity}
                                                                            </span>
                                                                        </td>
                                                                        <td>
                                                                            <c:if test="${storeInfo.quantity > 0}">
                                                                                <a href="${pageContext.request.contextPath}/products/buy?productId=${entry.key.id}&storeId=${storeInfo.store.id}" class="btn btn-sm btn-primary">Buy</a>
                                                                            </c:if>
                                                                            <c:if test="${storeInfo.quantity <= 0}">
                                                                                <button class="btn btn-sm btn-secondary" disabled>Out of Stock</button>
                                                                            </c:if>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>

                        <div class="d-grid gap-2 mt-3">
                            <a href="${pageContext.request.contextPath}/products/search" class="btn btn-primary">Search Again</a>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Back to Home</a>
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
