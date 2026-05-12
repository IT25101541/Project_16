<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Cart – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
  <div class="page-header">
    <div class="page-title">🛒 Your Cart</div>
    <a href="${pageContext.request.contextPath}/shop/categories" class="btn btn-secondary">← Continue Shopping</a>
  </div>

  <c:choose>
    <c:when test="${empty cart.items}">
      <div class="card" style="text-align:center; padding:3rem;">
        <div style="font-size:4rem; margin-bottom:1rem;">🛒</div>
        <div style="font-size:1.2rem; font-weight:700; color:var(--text-mid);">Your cart is empty</div>
        <div style="color:var(--text-light); margin:0.5rem 0 1.5rem;">Add some fresh groceries to get started!</div>
        <a href="${pageContext.request.contextPath}/shop/categories" class="btn btn-primary">Start Shopping</a>
      </div>
    </c:when>
    <c:otherwise>
      <div style="display:grid; grid-template-columns:1fr 320px; gap:1.5rem; align-items:start;">
        <%-- Cart Items --%>
        <div class="card" style="padding:0; overflow:hidden;">
          <table class="cart-table">
            <thead>
              <tr>
                <th>Product</th>
                <th>Unit Price</th>
                <th>Qty</th>
                <th>Discount</th>
                <th>Subtotal</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="item" items="${cart.items}">
                <tr>
                  <td>
                    <div style="font-weight:700;">${item.productName}</div>
                    <c:if test="${item.discountPercent > 0}">
                      <div style="font-size:0.75rem; color:var(--red); font-weight:700;">⚠️ Near-Expiry Item</div>
                    </c:if>
                  </td>
                  <td>LKR <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                  <td>
                    <form method="post" action="${pageContext.request.contextPath}/shop/update-cart" style="display:inline;">
                      <input type="hidden" name="productId" value="${item.productId}">
                      <input type="number" name="qty" value="${item.quantity}" min="1" max="99"
                             class="qty-input qty-update" onchange="this.form.submit()">
                    </form>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${item.discountPercent > 0}">
                        <span style="color:var(--red); font-weight:700;"><fmt:formatNumber value="${item.discountPercent}" pattern="#,##0"/>%</span>
                      </c:when>
                      <c:otherwise>—</c:otherwise>
                    </c:choose>
                  </td>
                  <td style="font-weight:700; color:var(--green-dark);">
                    LKR <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                  </td>
                  <td>
                    <form method="post" action="${pageContext.request.contextPath}/shop/remove-from-cart">
                      <input type="hidden" name="productId" value="${item.productId}">
                      <button type="submit" class="btn btn-danger btn-sm">✕</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <%-- Order Summary --%>
        <div class="card">
          <div style="font-size:1.1rem; font-weight:800; margin-bottom:1.25rem; color:var(--text-dark);">Order Summary</div>

          <c:forEach var="item" items="${cart.items}">
            <div style="display:flex; justify-content:space-between; font-size:0.85rem; padding:0.3rem 0; border-bottom:1px solid var(--border);">
              <span style="color:var(--text-mid);">${item.productName} × ${item.quantity}</span>
              <span style="font-weight:600;">LKR <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span>
            </div>
          </c:forEach>

          <div style="margin-top:1rem; padding-top:0.5rem; border-top:2px solid var(--border);">
            <div style="display:flex; justify-content:space-between; font-size:1.2rem; font-weight:900; color:var(--green-dark);">
              <span>Total</span>
              <span>LKR <fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
            </div>
          </div>

          <div style="margin-top:1.25rem; display:flex; flex-direction:column; gap:0.5rem;">
            <form method="post" action="${pageContext.request.contextPath}/shop/place-order">
              <button type="submit" class="btn btn-primary btn-block btn-lg">Proceed to Checkout →</button>
            </form>
            <a href="${pageContext.request.contextPath}/shop/categories" class="btn btn-secondary btn-block">Continue Shopping</a>
          </div>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
