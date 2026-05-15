<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Bill – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    @media print {
      .no-print { display: none !important; }
      body { background: white; }
      .bill-container { box-shadow: none; }
    }
  </style>
</head>
<body>
<div class="no-print">
  <jsp:include page="navbar.jsp"/>
</div>

<div class="container">
  <div id="billActions" class="no-print" style="display:flex; gap:1rem; padding:1rem 0;">
    <button onclick="downloadBill()" class="btn btn-primary">⬇️ Download Bill (PDF)</button>
    <button onclick="printBill()" class="btn btn-secondary">🖨️ Print</button>
  </div>

  <div class="bill-container">
    <div class="bill-header">
      <div style="font-size:2.5rem; margin-bottom:0.5rem;">🛒</div>
      <h2>FreshCart</h2>
      <p>Online Grocery Store</p>
      <p style="margin-top:0.5rem; font-size:0.85rem; opacity:0.7;">
        Order ID: ${order.orderId} &nbsp;|&nbsp; Date: ${order.orderDate}
      </p>
    </div>

    <div class="bill-body">
      <div style="display:flex; justify-content:space-between; margin-bottom:1rem; font-size:0.9rem;">
        <div>
          <div style="font-weight:700; color:var(--text-mid); font-size:0.78rem; margin-bottom:0.2rem;">BILLED TO</div>
          <div style="font-weight:800;">${sessionScope.loggedUser.username}</div>
          <div style="color:var(--text-mid);">${sessionScope.loggedUser.email}</div>
        </div>
        <div style="text-align:right;">
          <div style="font-weight:700; color:var(--text-mid); font-size:0.78rem; margin-bottom:0.2rem;">STATUS</div>
          <span class="status-badge status-pending">Pending Fulfillment</span>
        </div>
      </div>

      <table class="bill-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Item</th>
            <th style="text-align:center;">Qty</th>
            <th style="text-align:right;">Unit Price</th>
            <th style="text-align:right;">Discount</th>
            <th style="text-align:right;">Subtotal</th>
          </tr>
        </thead>
        <tbody>
          <c:set var="grandTotal" value="0"/>
          <c:set var="totalDiscount" value="0"/>
          <c:set var="counter" value="1"/>
          <c:forEach var="item" items="${orderItems}">
            <c:set var="discountAmt" value="${item.price * item.discountPercent / 100 * item.quantity}"/>
            <c:set var="subtotal"    value="${item.subtotal}"/>
            <c:set var="totalDiscount" value="${totalDiscount + discountAmt}"/>
            <tr>
              <td style="color:var(--text-light);">${counter}</td>
              <td>
                ${item.productName}
                <c:if test="${item.discountPercent > 0}">
                  <span style="font-size:0.75rem; color:var(--red); font-weight:700;"> ⚠️ Near-Expiry</span>
                </c:if>
              </td>
              <td style="text-align:center;">${item.quantity}</td>
              <td style="text-align:right;">LKR <fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
              <td style="text-align:right; color:var(--red);">
                <c:choose>
                  <c:when test="${item.discountPercent > 0}">
                    <fmt:formatNumber value="${item.discountPercent}" pattern="#,##0"/>%
                    (-LKR <fmt:formatNumber value="${discountAmt}" pattern="#,##0.00"/>)
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </td>
              <td style="text-align:right; font-weight:700;">LKR <fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></td>
            </tr>
            <c:set var="counter" value="${counter + 1}"/>
          </c:forEach>
        </tbody>
      </table>

      <div class="bill-total-section">
        <div class="bill-row">
          <span style="color:var(--text-mid);">Subtotal (before discounts)</span>
          <span>LKR <fmt:formatNumber value="${total + totalDiscount}" pattern="#,##0.00"/></span>
        </div>
        <c:if test="${totalDiscount > 0}">
          <div class="bill-row" style="color:var(--red);">
            <span>🏷️ Near-Expiry Discount</span>
            <span>-LKR <fmt:formatNumber value="${totalDiscount}" pattern="#,##0.00"/></span>
          </div>
        </c:if>
        <div class="bill-row" style="color:var(--text-mid);">
          <span>Delivery Fee</span>
          <span>To be determined</span>
        </div>
        <div style="border-top:2px solid var(--border); margin-top:0.5rem; padding-top:0.5rem;">
          <div class="bill-row total">
            <span>Net Total</span>
            <span>LKR <fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
          </div>
        </div>
      </div>

      <div style="margin-top:1.5rem; padding:1rem; background:var(--green-pale); border-radius:var(--radius-sm); font-size:0.85rem; text-align:center;">
        <strong>Thank you for shopping at FreshCart!</strong><br>
        <span style="color:var(--text-light);">Please select your fulfillment option below to complete your order.</span>
      </div>
    </div>
  </div>

  <%-- Fulfillment Selection --%>
  <div class="no-print" style="max-width:700px; margin:1.5rem auto;">
    <div class="card">
      <div style="font-size:1.1rem; font-weight:800; margin-bottom:1.25rem; text-align:center;">
        How would you like to receive your order?
      </div>
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">

        <%-- Pickup --%>
        <form method="post" action="${pageContext.request.contextPath}/shop/fulfillment">
          <input type="hidden" name="orderId" value="${order.orderId}">
          <input type="hidden" name="type" value="PICKUP">
          <button type="submit" class="btn btn-secondary btn-block" style="height:100px; flex-direction:column; font-size:1rem; border:2px solid var(--border);">
            <span style="font-size:2rem;">🏪</span>
            <span>Pickup at Store</span>
            <span style="font-size:0.75rem; color:var(--text-light);">Free – Ready in 2 hrs</span>
          </button>
        </form>

        <%-- Delivery --%>
        <button type="button" class="btn btn-primary btn-block" style="height:100px; flex-direction:column; font-size:1rem;"
                onclick="document.getElementById('deliveryForm').style.display='block'; this.style.display='none';">
          <span style="font-size:2rem;">🚚</span>
          <span>Home Delivery</span>
          <span style="font-size:0.75rem; opacity:0.85;">LKR 150 – 1-3 days</span>
        </button>
      </div>

      <%-- Delivery Form --%>
      <div id="deliveryForm" style="display:none; margin-top:1.5rem; border-top:2px solid var(--border); padding-top:1.5rem;">
        <div style="font-weight:800; font-size:1rem; margin-bottom:1rem;">🚚 Delivery Details</div>
        <form method="post" action="${pageContext.request.contextPath}/shop/fulfillment">
          <input type="hidden" name="orderId" value="${order.orderId}">
          <input type="hidden" name="type" value="DELIVERY">
          <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
            <div class="form-group" style="grid-column:1/-1;">
              <label class="form-label">Delivery Address</label>
              <input type="text" name="address" class="form-control" placeholder="No. 45, Temple Road, Nugegoda" required>
            </div>
            <div class="form-group">
              <label class="form-label">Postal Code</label>
              <input type="text" name="postalCode" class="form-control" placeholder="10250" required>
            </div>
            <div class="form-group">
              <label class="form-label">District</label>
              <select name="district" class="form-control" required>
                <option value="">Select District</option>
                <option>Colombo</option><option>Gampaha</option><option>Kalutara</option>
                <option>Kandy</option><option>Matale</option><option>Nuwara Eliya</option>
                <option>Galle</option><option>Matara</option><option>Hambantota</option>
                <option>Jaffna</option><option>Kilinochchi</option><option>Mannar</option>
                <option>Mullaitivu</option><option>Vavuniya</option><option>Puttalam</option>
                <option>Kurunegala</option><option>Anuradhapura</option><option>Polonnaruwa</option>
                <option>Badulla</option><option>Monaragala</option><option>Ratnapura</option>
                <option>Kegalle</option><option>Trincomalee</option><option>Batticaloa</option>
                <option>Ampara</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Province</label>
              <select name="province" class="form-control" required>
                <option value="">Select Province</option>
                <option>Western</option><option>Central</option><option>Southern</option>
                <option>Northern</option><option>Eastern</option><option>North Western</option>
                <option>North Central</option><option>Uva</option><option>Sabaragamuwa</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Mobile Number</label>
              <input type="tel" name="mobile" class="form-control" placeholder="07X XXXXXXX" required>
            </div>
          </div>
          <button type="submit" class="btn btn-primary btn-block btn-lg">Confirm Delivery Order →</button>
        </form>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
