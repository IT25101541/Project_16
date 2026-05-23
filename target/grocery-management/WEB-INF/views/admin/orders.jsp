<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Order Management – FreshCart Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="📦 Order Management" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<div style="margin-bottom:1rem; font-size:0.9rem; color:var(--text-light);">${orders.size()} total orders</div>

<div class="card" style="padding:0; overflow:hidden;">
  <table class="data-table">
    <thead>
      <tr>
        <th>Order ID</th><th>Customer</th><th>Amount</th><th>Fulfillment</th>
        <th>Status</th><th>Date</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <c:if test="${empty orders}">
        <tr><td colspan="7" style="text-align:center; color:var(--text-light); padding:2rem;">No orders found.</td></tr>
      </c:if>
      <c:forEach var="order" items="${orders}">
        <tr>
          <td style="font-size:0.78rem; font-weight:700;">${order.orderId}</td>
          <td>${order.username}</td>
          <td style="font-weight:700; color:var(--green-dark);">LKR <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
          <td>
            <c:choose>
              <c:when test="${order.fulfillmentType == 'DELIVERY'}"><span class="status-badge status-processing">🚚 Delivery</span></c:when>
              <c:when test="${order.fulfillmentType == 'PICKUP'}"><span class="status-badge status-active">🏪 Pickup</span></c:when>
              <c:otherwise><span class="status-badge status-pending">${order.fulfillmentType}</span></c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
              <c:when test="${order.status == 'PENDING' || order.status == 'PENDING_FULFILLMENT'}"><span class="status-badge status-pending">${order.status}</span></c:when>
              <c:when test="${order.status == 'PROCESSING'}"><span class="status-badge status-processing">${order.status}</span></c:when>
              <c:when test="${order.status == 'READY_FOR_PICKUP'}"><span class="status-badge status-ready">Ready</span></c:when>
              <c:when test="${order.status == 'DELIVERED'}"><span class="status-badge status-delivered">${order.status}</span></c:when>
              <c:when test="${order.status == 'CANCELLED'}"><span class="status-badge status-cancelled">${order.status}</span></c:when>
              <c:otherwise><span class="status-badge status-pending">${order.status}</span></c:otherwise>
            </c:choose>
          </td>
          <td style="font-size:0.82rem; color:var(--text-light);">${order.orderDate}</td>
          <td>
            <div style="display:flex; gap:0.35rem; flex-wrap:wrap;">
              <%-- Update Status --%>
              <form method="post" action="${pageContext.request.contextPath}/admin/update-order-status" style="display:flex; gap:0.3rem;">
                <input type="hidden" name="orderId" value="${order.orderId}">
                <select name="status" class="form-control" style="padding:0.2rem 0.4rem; font-size:0.78rem; height:28px; border-radius:4px;">
                  <option value="PENDING">Pending</option>
                  <option value="PROCESSING">Processing</option>
                  <option value="READY_FOR_PICKUP">Ready</option>
                  <option value="OUT_FOR_DELIVERY">Out for Delivery</option>
                  <option value="DELIVERED">Delivered</option>
                  <option value="CANCELLED">Cancelled</option>
                </select>
                <button class="btn btn-info btn-sm" style="height:28px; padding:0 0.5rem;">✔</button>
              </form>
              <%-- Delete --%>
              <form method="post" action="${pageContext.request.contextPath}/admin/delete-order" style="display:inline;"
                    onsubmit="return confirm('Delete order ${order.orderId}?')">
                <input type="hidden" name="orderId" value="${order.orderId}">
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
