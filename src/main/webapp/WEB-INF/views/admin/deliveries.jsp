<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Delivery Management – FreshCart Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="🚚 Delivery Management" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<div style="margin-bottom:1rem; font-size:0.9rem; color:var(--text-light);">${deliveries.size()} deliveries</div>

<div class="card" style="padding:0; overflow:hidden;">
  <table class="data-table">
    <thead>
      <tr>
        <th>Delivery ID</th><th>Order ID</th><th>Address</th>
        <th>Driver</th><th>Vehicle</th><th>Status</th><th>Date</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <c:if test="${empty deliveries}">
        <tr><td colspan="8" style="text-align:center; color:var(--text-light); padding:2rem;">No delivery records found.</td></tr>
      </c:if>
      <c:forEach var="d" items="${deliveries}">
        <tr>
          <td style="font-size:0.78rem; color:var(--text-light);">${d.deliveryId}</td>
          <td style="font-weight:700; font-size:0.82rem;">${d.orderId}</td>
          <td style="font-size:0.82rem; max-width:160px;">${d.deliveryAddress}</td>
          <td>
            <div style="font-weight:700; font-size:0.85rem;">${d.driverName}</div>
            <div style="font-size:0.75rem; color:var(--text-light);">${d.driverPhone}</div>
          </td>
          <td style="font-size:0.85rem;">${d.vehicleNumber}</td>
          <td>
            <c:choose>
              <c:when test="${d.status == 'ASSIGNED'}"><span class="status-badge status-assigned">Assigned</span></c:when>
              <c:when test="${d.status == 'OUT_FOR_DELIVERY'}"><span class="status-badge status-out">Out for Delivery</span></c:when>
              <c:when test="${d.status == 'DELIVERED'}"><span class="status-badge status-delivered">Delivered</span></c:when>
              <c:when test="${d.status == 'CANCELLED'}"><span class="status-badge status-cancelled">Cancelled</span></c:when>
              <c:otherwise><span class="status-badge status-pending">${d.status}</span></c:otherwise>
            </c:choose>
          </td>
          <td style="font-size:0.78rem; color:var(--text-light);">${d.assignedDate}</td>
          <td>
            <div style="display:flex; gap:0.35rem; flex-wrap:wrap;">
              <%-- Update Status --%>
              <form method="post" action="${pageContext.request.contextPath}/admin/update-delivery-status" style="display:flex; gap:0.3rem;">
                <input type="hidden" name="deliveryId" value="${d.deliveryId}">
                <select name="status" class="form-control" style="padding:0.2rem 0.4rem; font-size:0.78rem; height:28px; border-radius:4px;">
                  <option value="ASSIGNED">Assigned</option>
                  <option value="OUT_FOR_DELIVERY">Out for Delivery</option>
                  <option value="DELIVERED">Delivered</option>
                  <option value="CANCELLED">Cancelled</option>
                </select>
                <button class="btn btn-info btn-sm" style="height:28px; padding:0 0.5rem;">✔</button>
              </form>
              <%-- Cancel --%>
              <c:if test="${d.status != 'DELIVERED' && d.status != 'CANCELLED'}">
                <form method="post" action="${pageContext.request.contextPath}/admin/cancel-delivery" style="display:inline;"
                      onsubmit="return confirm('Cancel this delivery?')">
                  <input type="hidden" name="deliveryId" value="${d.deliveryId}">
                  <button class="btn btn-warning btn-sm">✕ Cancel</button>
                </form>
              </c:if>
              <%-- Delete --%>
              <form method="post" action="${pageContext.request.contextPath}/admin/delete-delivery" style="display:inline;"
                    onsubmit="return confirm('Delete delivery record?')">
                <input type="hidden" name="deliveryId" value="${d.deliveryId}">
                <button class="btn btn-danger btn-sm">🗑️</button>
              </form>
            </div>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<jsp:include page="sidebar-close.jsp"/>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
