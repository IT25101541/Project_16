<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>${category} – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/shop/categories">Categories</a>
    <span>/</span>
    <span>${empty category ? 'All Products' : category}</span>
  </div>

  <div class="page-header">
    <div>
      <div class="page-title">${empty category ? 'All Products' : category}</div>
      <div class="page-subtitle">${products.size()} items available</div>
    </div>
    <a href="${pageContext.request.contextPath}/shop/cart" class="btn btn-primary">🛒 View Cart</a>
  </div>

  <c:if test="${empty products}">
    <div class="alert alert-info">No products available in this category.</div>
  </c:if>

  <div class="product-grid">
    <c:forEach var="p" items="${products}">
      <div class="product-card">
        <div class="product-img">
          <span style="font-size:3.5rem;">
            <c:choose>
              <c:when test="${p.category == 'Fruits'}">🍎</c:when>
              <c:when test="${p.category == 'Vegetables'}">🥦</c:when>
              <c:when test="${p.category == 'Meat'}">🥩</c:when>
              <c:when test="${p.category == 'Dairy'}">🥛</c:when>
              <c:when test="${p.category == 'Bakery'}">🍞</c:when>
              <c:when test="${p.category == 'Staple Grocery'}">🌾</c:when>
              <c:when test="${p.category == 'Beverage'}">🧃</c:when>
              <c:when test="${p.category == 'Frozen'}">🧊</c:when>
              <c:otherwise>🛒</c:otherwise>
            </c:choose>
          </span>
          <c:if test="${p.stockQuantity < 10}">
            <div class="product-badge">Low Stock</div>
          </c:if>
        </div>
        <div class="product-body">
          <div class="product-name">${p.name}</div>
          <div class="product-category">${p.category}</div>
          <div class="product-price">LKR <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></div>
          <div class="product-stock <c:if test='${p.stockQuantity < 10}'>low</c:if>">
            Stock: ${p.stockQuantity} units
          </div>
          <div class="product-footer">
            <c:if test="${p.stockQuantity > 0}">
              <form method="post" action="${pageContext.request.contextPath}/shop/add-to-cart" style="display:flex; gap:0.5rem; align-items:center;">
                <input type="hidden" name="productId"   value="${p.productId}">
                <input type="hidden" name="productName" value="${p.name}">
                <input type="hidden" name="price"       value="${p.price}">
                <div style="display:flex; align-items:center; gap:0.25rem;">
                  <button type="button" class="btn btn-secondary btn-sm" onclick="decrement('qty_${p.productId}')">−</button>
                  <input type="number" id="qty_${p.productId}" name="qty" value="1" min="1" max="${p.stockQuantity}" class="qty-input">
                  <button type="button" class="btn btn-secondary btn-sm" onclick="increment('qty_${p.productId}')">+</button>
                </div>
                <button type="submit" class="btn btn-primary btn-sm" style="flex:1;">Add 🛒</button>
              </form>
            </c:if>
            <c:if test="${p.stockQuantity == 0}">
              <div class="status-badge status-cancelled" style="width:100%; text-align:center; padding:0.4rem;">Out of Stock</div>
            </c:if>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
