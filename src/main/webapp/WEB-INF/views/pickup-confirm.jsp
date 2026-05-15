<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Pickup Confirmed – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
  <div style="max-width:600px; margin:3rem auto; text-align:center;">
    <div style="font-size:5rem; margin-bottom:1rem;">🏪</div>
    <h1 style="font-size:2rem; font-weight:900; color:var(--green-dark); margin-bottom:0.5rem;">
      Thank You, ${sessionScope.loggedUser.username}!
    </h1>
    <p style="color:var(--text-mid); font-size:1.05rem; margin-bottom:2rem;">
      Your order has been confirmed for <strong>in-store pickup</strong>.
    </p>

    <div class="card" style="text-align:left; margin-bottom:1.5rem;">
      <div style="font-weight:800; font-size:1rem; margin-bottom:1rem; color:var(--green-dark);">📦 Order Details</div>
      <table style="width:100%; font-size:0.9rem; border-collapse:collapse;">
        <tr>
          <td style="color:var(--text-light); padding:0.4rem 0;">Order ID</td>
          <td style="font-weight:700; text-align:right;">${order.orderId}</td>
        </tr>
        <tr>
          <td style="color:var(--text-light); padding:0.4rem 0;">Order Date</td>
          <td style="font-weight:700; text-align:right;">${order.orderDate}</td>
        </tr>
        <tr>
          <td style="color:var(--text-light); padding:0.4rem 0;">Total Amount</td>
          <td style="font-weight:800; text-align:right; color:var(--green-dark);">
            LKR <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
          </td>
        </tr>
        <tr>
          <td style="color:var(--text-light); padding:0.4rem 0;">Status</td>
          <td style="text-align:right;"><span class="status-badge status-ready">Ready for Pickup</span></td>
        </tr>
      </table>
    </div>

    <div class="alert alert-success" style="font-size:1rem; text-align:left;">
      ✅ Your items are ready to pick up at the store!<br>
      <strong>Store Address:</strong> No. 12, Fresh Mart Road, Colombo 03<br>
      <strong>Open Hours:</strong> Mon–Sun, 6:00 AM – 10:00 PM<br>
      <strong>Contact:</strong> 011 234 5678
    </div>

    <div style="display:flex; gap:1rem; justify-content:center; flex-wrap:wrap;">
      <a href="${pageContext.request.contextPath}/shop/order-history" class="btn btn-primary">View My Orders</a>
      <a href="${pageContext.request.contextPath}/shop/categories" class="btn btn-secondary">Continue Shopping</a>
    </div>
  </div>
</div>
</body>
</html>
