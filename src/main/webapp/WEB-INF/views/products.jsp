<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>${empty category ? 'All Products' : category} - FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    body {
      background-image: url('${pageContext.request.contextPath}/static/img/cart-bg.jpg');
      background-size: cover;
      background-position: center;
      background-attachment: fixed;
      background-color: #0d3b1f;
    }
    body::before {
      content: '';
      position: fixed; inset: 0;
      background: rgba(0,0,0,0.55);
      z-index: 0; pointer-events: none;
    }
    body > * { position: relative; z-index: 1; }

    .breadcrumb a { color: #ffd54f; }
    .breadcrumb span { color: rgba(255,255,255,0.5); }
    .page-title { color: #ffffff; text-shadow: 0 2px 12px rgba(0,0,0,0.4); }
    .page-subtitle { color: rgba(255,255,255,0.72); }
    .product-card { background: rgba(255,255,255,0.97); }
    .alert-info { background: rgba(255,255,255,0.12); color: #fff; border-left-color: #ffd54f; }

    .cat-banner {
      text-align: center;
      padding: 2.5rem 1.5rem 1.5rem;
      color: white;
      animation: fadeInDown 0.6s ease;
    }
    .cat-banner-icon {
      font-size: 4.5rem;
      display: block;
      margin-bottom: 0.5rem;
      filter: drop-shadow(0 4px 16px rgba(0,0,0,0.5));
      animation: float 3s ease-in-out infinite;
    }
    .cat-banner h1 {
      font-family: 'Poppins', sans-serif;
      font-size: 2.4rem; font-weight: 800;
      text-shadow: 0 4px 20px rgba(0,0,0,0.5);
      margin-bottom: 0.3rem;
    }
    .cat-banner p { font-size: 0.95rem; opacity: 0.82; font-weight: 600; }
  </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="cat-banner">
  <span class="cat-banner-icon">
    <c:choose>
      <c:when test="${category == 'Fruits'}">&#127822;</c:when>
      <c:when test="${category == 'Vegetables'}">&#129382;</c:when>
      <c:when test="${category == 'Meat'}">&#129361;</c:when>
      <c:when test="${category == 'Dairy'}">&#127843;</c:when>
      <c:when test="${category == 'Bakery'}">&#127838;</c:when>
      <c:when test="${category == 'Staple Grocery'}">&#127806;</c:when>
      <c:when test="${category == 'Beverage'}">&#129347;</c:when>
      <c:when test="${category == 'Frozen'}">&#129398;</c:when>
      <c:otherwise>&#128722;</c:otherwise>
    </c:choose>
  </span>
  <h1>${empty category ? 'All Products' : category}</h1>
  <p>${products.size()} fresh items available</p>
</div>

<div class="container">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/shop/categories">Categories</a>
    <span>/</span>
    <span style="color:rgba(255,255,255,0.7);">${empty category ? 'All Products' : category}</span>
  </div>

  <div class="page-header" style="padding-top:0;">
    <div>
      <div class="page-subtitle" style="margin-top:0;">${products.size()} items available</div>
    </div>
    <a href="${pageContext.request.contextPath}/shop/cart" class="btn btn-primary">&#128722; View Cart</a>
  </div>

  <c:if test="${empty products}">
    <div class="alert alert-info">No products available in this category.</div>
  </c:if>

  <div class="product-grid">
    <c:forEach var="p" items="${products}">
      <div class="product-card anim-up">
        <div class="product-img">
          <span style="font-size:3.5rem;">
            <c:choose>
              <c:when test="${p.category == 'Fruits'}">&#127822;</c:when>
              <c:when test="${p.category == 'Vegetables'}">&#129382;</c:when>
              <c:when test="${p.category == 'Meat'}">&#129361;</c:when>
              <c:when test="${p.category == 'Dairy'}">&#127843;</c:when>
              <c:when test="${p.category == 'Bakery'}">&#127838;</c:when>
              <c:when test="${p.category == 'Staple Grocery'}">&#127806;</c:when>
              <c:when test="${p.category == 'Beverage'}">&#129347;</c:when>
              <c:when test="${p.category == 'Frozen'}">&#129398;</c:when>
              <c:otherwise>&#128722;</c:otherwise>
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
          <div class="product-stock ${p.stockQuantity < 10 ? 'low' : ''}">
            Stock: ${p.stockQuantity} units
          </div>
          <div class="product-footer">
            <c:choose>
              <c:when test="${p.stockQuantity > 0}">
                <form method="post" action="${pageContext.request.contextPath}/shop/add-to-cart"
                      style="display:flex; gap:0.5rem; align-items:center;">
                  <input type="hidden" name="productId"   value="${p.productId}">
                  <input type="hidden" name="productName" value="${p.name}">
                  <input type="hidden" name="price"       value="${p.price}">
                  <div style="display:flex; align-items:center; gap:0.25rem;">
                    <button type="button" class="btn btn-secondary btn-sm"
                            onclick="decrement('qty_${p.productId}')">&#8722;</button>
                    <input type="number" id="qty_${p.productId}" name="qty"
                           value="1" min="1" max="${p.stockQuantity}" class="qty-input">
                    <button type="button" class="btn btn-secondary btn-sm"
                            onclick="increment('qty_${p.productId}')">+</button>
                  </div>
                  <button type="submit" class="btn btn-primary btn-sm" style="flex:1;">
                    Add &#128722;
                  </button>
                </form>
              </c:when>
              <c:otherwise>
                <div class="status-badge status-cancelled"
                     style="width:100%; text-align:center; padding:0.4rem;">
                  Out of Stock
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>

  <div style="height:2rem;"></div>
</div>

<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
