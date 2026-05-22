<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Near-Expiry Deals – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/shop/categories">Categories</a>
    <span>/</span>
    <span>🏷️ Near-Expiry Deals</span>
  </div>

  <div class="page-header">
    <div>
      <div class="page-title">🏷️ Near-Expiry Deals</div>
      <div class="page-subtitle">Fresh items at amazing discounts – grab them before they're gone!</div>
    </div>
  </div>

  <div class="alert alert-warning">
    ⚠️ These items are near their expiry date. Discounts applied automatically at checkout.
  </div>

  <c:if test="${empty clearanceItems}">
    <div class="alert alert-info">No clearance items available at the moment.</div>
  </c:if>

  <div class="product-grid">
    <c:forEach var="sc" items="${clearanceItems}">
      <div class="clearance-card">
        <div class="clearance-header">
          <div>
            <div style="font-weight:800; font-size:1rem;">${sc.productName}</div>
            <div class="expiry-label">Expires: ${sc.expiryDate}</div>
          </div>
          <div class="discount-badge">-<fmt:formatNumber value="${sc.discountPercentage}" pattern="#,##0"/>% OFF</div>
        </div>
        <div class="product-body" style="padding:1rem;">
          <table style="width:100%; font-size:0.85rem; border-collapse:collapse;">
            <tr>
              <td style="color:var(--text-light); padding:0.3rem 0;">Manufacture Date</td>
              <td style="font-weight:700; text-align:right;">${sc.manufactureDate}</td>
            </tr>
            <tr>
              <td style="color:var(--text-light); padding:0.3rem 0;">Expiry Date</td>
              <td style="font-weight:700; text-align:right; color:var(--red);">${sc.expiryDate}</td>
            </tr>
            <tr>
              <td style="color:var(--text-light); padding:0.3rem 0;">Stock Level</td>
              <td style="font-weight:700; text-align:right;">${sc.stockCondition} (${sc.stockQuantity} units)</td>
            </tr>
            <tr>
              <td style="color:var(--text-light); padding:0.3rem 0;">Original Price</td>
              <td style="text-decoration:line-through; text-align:right; color:var(--text-light);">
                LKR <fmt:formatNumber value="${sc.originalPrice}" pattern="#,##0.00"/>
              </td>
            </tr>
            <tr>
              <td style="color:var(--green-dark); font-weight:700; padding:0.3rem 0;">Clearance Price</td>
              <td style="font-weight:900; text-align:right; color:var(--green-dark); font-size:1.1rem;">
                LKR <fmt:formatNumber value="${sc.clearancePrice}" pattern="#,##0.00"/>
              </td>
            </tr>
          </table>

          <div style="margin-top:0.75rem;">
            <form method="post" action="${pageContext.request.contextPath}/shop/add-to-cart" style="display:flex; gap:0.5rem; align-items:center;">
              <input type="hidden" name="productId"   value="${sc.productId}">
              <input type="hidden" name="productName" value="${sc.productName} ⚠️(Near Expiry)">
              <input type="hidden" name="price"       value="${sc.originalPrice}">
              <input type="hidden" name="discount"    value="${sc.discountPercentage}">
              <div style="display:flex; align-items:center; gap:0.25rem;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="decrement('clrqty_${sc.clearanceId}')">−</button>
                <input type="number" id="clrqty_${sc.clearanceId}" name="qty" value="1" min="1" max="${sc.stockQuantity}" class="qty-input">
                <button type="button" class="btn btn-secondary btn-sm" onclick="increment('clrqty_${sc.clearanceId}')">+</button>
              </div>
              <button type="submit" class="btn btn-danger btn-sm" style="flex:1;">Add 🛒</button>
            </form>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
