<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>My Orders – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
  <div class="page-header">
    <div class="page-title">📦 My Orders</div>
    <a href="${pageContext.request.contextPath}/shop/categories" class="btn btn-primary">🛒 Shop More</a>
  </div>

  <c:if test="${empty orders}">
    <div class="card" style="text-align:center; padding:3rem;">
      <div style="font-size:4rem; margin-bottom:1rem;">📦</div>
      <div style="font-size:1.2rem; font-weight:700; color:var(--text-mid);">No orders yet</div>
      <div style="color:var(--text-light); margin:0.5rem 0 1.5rem;">Start shopping to see your orders here.</div>
      <a href="${pageContext.request.contextPath}/shop/categories" class="btn btn-primary">Start Shopping</a>
    </div>
  </c:if>

  <c:forEach var="order" items="${orders}">
    <div class="card" style="margin-bottom:1rem;">
      <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:0.75rem;">
        <div>
          <div style="font-weight:800; font-size:1rem;">${order.orderId}</div>
          <div style="font-size:0.85rem; color:var(--text-light); margin-top:0.2rem;">${order.orderDate}</div>
        </div>
        <div style="text-align:right;">
          <c:choose>
            <c:when test="${order.status == 'PENDING' || order.status == 'PENDING_FULFILLMENT'}">
              <span class="status-badge status-pending">${order.status}</span>
            </c:when>
            <c:when test="${order.status == 'PROCESSING'}">
              <span class="status-badge status-processing">${order.status}</span>
            </c:when>
            <c:when test="${order.status == 'READY_FOR_PICKUP'}">
              <span class="status-badge status-ready">Ready for Pickup</span>
            </c:when>
            <c:when test="${order.status == 'DELIVERED'}">
              <span class="status-badge status-delivered">${order.status}</span>
            </c:when>
            <c:when test="${order.status == 'CANCELLED'}">
              <span class="status-badge status-cancelled">${order.status}</span>
            </c:when>
            <c:otherwise>
              <span class="status-badge status-pending">${order.status}</span>
            </c:otherwise>
          </c:choose>
          <div style="font-weight:900; color:var(--green-dark); font-size:1.1rem; margin-top:0.4rem;">
            LKR <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
          </div>
        </div>
      </div>

      <div style="margin-top:0.75rem; font-size:0.85rem; color:var(--text-mid);">
        <strong>Items:</strong>
        <c:forEach var="item" items="${order.items}" varStatus="loop">
          ${item.productName} ×${item.quantity}<c:if test="${!loop.last}">, </c:if>
        </c:forEach>
      </div>

      <div style="margin-top:0.75rem; display:flex; gap:0.75rem; flex-wrap:wrap;">
        <c:if test="${order.fulfillmentType == 'DELIVERY' && order.status != 'CANCELLED'}">
          <a href="${pageContext.request.contextPath}/shop/delivery-status?orderId=${order.orderId}"
             class="btn btn-info btn-sm">🚚 Track Delivery</a>
        </c:if>
        <c:if test="${order.fulfillmentType == 'PICKUP'}">
          <span class="btn btn-secondary btn-sm" style="cursor:default;">🏪 Pickup</span>
        </c:if>
        <c:if test="${order.status == 'PENDING' || order.status == 'PROCESSING'}">
          <form method="post" action="${pageContext.request.contextPath}/shop/cancel-order" style="display:inline;">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <button type="submit" class="btn btn-danger btn-sm"
                    onclick="return confirm('Cancel this order?')">✕ Cancel</button>
          </form>
        </c:if>
      </div>
    </div>
  </c:forEach>
</div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
