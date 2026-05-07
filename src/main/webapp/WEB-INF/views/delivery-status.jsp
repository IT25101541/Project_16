<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Delivery Status – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
  <div class="page-header">
    <div class="page-title">🚚 Order Tracking</div>
    <a href="${pageContext.request.contextPath}/shop/order-history" class="btn btn-secondary">← My Orders</a>
  </div>

  <div style="max-width:750px; margin:0 auto;">

    <%-- Order confirmed banner --%>
    <div class="alert alert-success" style="font-size:1rem;">
      ✅ <strong>Order Confirmed!</strong> Your order <strong>${order.orderId}</strong> has been placed successfully.
    </div>

    <%-- Delivery Tracker --%>
    <div class="card" style="margin-bottom:1.5rem;">
      <div style="font-weight:800; font-size:1rem; margin-bottom:1.5rem;">📍 Delivery Status</div>

      <div class="delivery-tracker">
        <div class="tracker-step ${delivery.status == 'ASSIGNED' || delivery.status == 'OUT_FOR_DELIVERY' || delivery.status == 'DELIVERED' ? 'done' : 'active'}">
          <div class="tracker-dot">✅</div>
          <div class="tracker-label">Order Confirmed</div>
        </div>
        <div class="tracker-step ${delivery.status == 'OUT_FOR_DELIVERY' || delivery.status == 'DELIVERED' ? 'done' : delivery.status == 'ASSIGNED' ? 'active' : ''}">
          <div class="tracker-dot">📦</div>
          <div class="tracker-label">Ready to Pickup</div>
        </div>
        <div class="tracker-step ${delivery.status == 'DELIVERED' ? 'done' : delivery.status == 'OUT_FOR_DELIVERY' ? 'active' : ''}">
          <div class="tracker-dot">🚚</div>
          <div class="tracker-label">Out for Delivery</div>
        </div>
        <div class="tracker-step ${delivery.status == 'DELIVERED' ? 'done' : ''}">
          <div class="tracker-dot">🏠</div>
          <div class="tracker-label">Delivered</div>
        </div>
      </div>

      <div style="text-align:center; margin-top:1rem;">
        <c:choose>
          <c:when test="${delivery.status == 'ASSIGNED'}">
            <span class="status-badge status-assigned" style="font-size:0.9rem; padding:0.4rem 1rem;">📦 Your order is being prepared</span>
          </c:when>
          <c:when test="${delivery.status == 'OUT_FOR_DELIVERY'}">
            <span class="status-badge status-out" style="font-size:0.9rem; padding:0.4rem 1rem;">🚚 On the way to you!</span>
          </c:when>
          <c:when test="${delivery.status == 'DELIVERED'}">
            <span class="status-badge status-delivered" style="font-size:0.9rem; padding:0.4rem 1rem;">✅ Delivered successfully</span>
          </c:when>
          <c:otherwise>
            <span class="status-badge status-pending" style="font-size:0.9rem; padding:0.4rem 1rem;">⏳ ${delivery.status}</span>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <%-- Driver Info --%>
    <c:if test="${not empty delivery}">
      <div class="card" style="margin-bottom:1.5rem;">
        <div style="font-weight:800; font-size:1rem; margin-bottom:1rem;">🏍️ Your Delivery Agent</div>
        <div class="driver-card">
          <div class="driver-avatar">👤</div>
          <div class="driver-info">
            <h4>${delivery.driverName}</h4>
            <p>📞 ${delivery.driverPhone}</p>
            <p>🚗 Vehicle: <strong>${delivery.vehicleNumber}</strong></p>
          </div>
        </div>

        <%-- GPS Map --%>
        <div style="margin-top:1rem;">
          <div style="font-weight:700; font-size:0.88rem; color:var(--text-mid); margin-bottom:0.5rem;">📍 Live Location</div>
          <div id="deliveryMap" class="map-placeholder">
            <span>🗺️</span>
            <p>Driver GPS: ${delivery.gpsLocation}</p>
            <p style="font-size:0.75rem; opacity:0.7;">Live tracking (Colombo area)</p>
          </div>
        </div>

        <div style="margin-top:1rem; display:grid; grid-template-columns:1fr 1fr; gap:0.75rem; font-size:0.88rem;">
          <div style="padding:0.75rem; background:var(--green-pale); border-radius:8px;">
            <div style="color:var(--text-light); margin-bottom:0.2rem;">Delivery Address</div>
            <div style="font-weight:700;">${delivery.deliveryAddress}</div>
          </div>
          <div style="padding:0.75rem; background:var(--green-pale); border-radius:8px;">
            <div style="color:var(--text-light); margin-bottom:0.2rem;">Assigned Date</div>
            <div style="font-weight:700;">${delivery.assignedDate}</div>
          </div>
        </div>
      </div>
    </c:if>

    <%-- Order Summary --%>
    <div class="card">
      <div style="font-weight:800; font-size:1rem; margin-bottom:1rem;">📋 Order Summary</div>
      <table style="width:100%; font-size:0.88rem; border-collapse:collapse;">
        <tr>
          <td style="color:var(--text-light); padding:0.4rem 0;">Order ID</td>
          <td style="font-weight:700; text-align:right;">${order.orderId}</td>
        </tr>
        <tr>
          <td style="color:var(--text-light); padding:0.4rem 0;">Order Date</td>
          <td style="font-weight:700; text-align:right;">${order.orderDate}</td>
        </tr>
        <tr>
          <td style="color:var(--text-light); padding:0.4rem 0;">Customer</td>
          <td style="font-weight:700; text-align:right;">${order.username}</td>
        </tr>
        <tr>
          <td style="color:var(--text-light); padding:0.4rem 0;">Total Amount</td>
          <td style="font-weight:900; text-align:right; color:var(--green-dark); font-size:1rem;">
            LKR <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
          </td>
        </tr>
      </table>
    </div>

    <div style="display:flex; gap:1rem; justify-content:center; margin-top:1.5rem; flex-wrap:wrap;">
      <a href="${pageContext.request.contextPath}/shop/order-history" class="btn btn-primary">View All Orders</a>
      <a href="${pageContext.request.contextPath}/shop/categories" class="btn btn-secondary">Continue Shopping</a>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
<script>
  const gps = "${delivery.gpsLocation}";
  if (gps) {
    const parts = gps.split(",");
    if (parts.length === 2) initDeliveryMap(parts[0].trim(), parts[1].trim());
  }
</script>
</body>
</html>
