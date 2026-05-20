<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Stock Clearance – FreshCart Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="🏷️ Stock Clearance & Expiry Management" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem; flex-wrap:wrap; gap:0.75rem;">
  <div style="font-size:0.9rem; color:var(--text-light);">${clearanceItems.size()} clearance records</div>
  <a href="${pageContext.request.contextPath}/admin/clearance-add" class="btn btn-primary">+ Add Clearance Record</a>
</div>

<div class="card" style="padding:0; overflow:hidden;">
  <table class="data-table">
    <thead>
      <tr>
        <th>ID</th><th>Product</th><th>Mfg Date</th><th>Expiry Date</th>
        <th>Original</th><th>Discount</th><th>Clearance Price</th>
        <th>Stock</th><th>Condition</th><th>Active</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <c:if test="${empty clearanceItems}">
        <tr><td colspan="11" style="text-align:center; color:var(--text-light); padding:2rem;">No clearance records.</td></tr>
      </c:if>
      <c:forEach var="sc" items="${clearanceItems}">
        <tr>
          <td style="font-size:0.75rem; color:var(--text-light);">${sc.clearanceId}</td>
          <td style="font-weight:700;">${sc.productName}</td>
          <td style="font-size:0.82rem;">${sc.manufactureDate}</td>
          <td style="font-size:0.82rem; color:var(--red); font-weight:700;">${sc.expiryDate}</td>
          <td>LKR <fmt:formatNumber value="${sc.originalPrice}" pattern="#,##0.00"/></td>
          <td style="color:var(--red); font-weight:700;">
            <fmt:formatNumber value="${sc.discountPercentage}" pattern="#,##0"/>%
          </td>
          <td style="color:var(--green-dark); font-weight:800;">
            LKR <fmt:formatNumber value="${sc.clearancePrice}" pattern="#,##0.00"/>
          </td>
          <td>${sc.stockQuantity}</td>
          <td>
            <span class="status-badge ${sc.stockCondition == 'LOW' ? 'status-cancelled' : sc.stockCondition == 'MEDIUM' ? 'status-pending' : 'status-active'}">
              ${sc.stockCondition}
            </span>
          </td>
          <td>
            <c:choose>
              <c:when test="${sc.discountApplied}"><span class="status-badge status-active">YES</span></c:when>
              <c:otherwise><span class="status-badge status-cancelled">NO</span></c:otherwise>
            </c:choose>
          </td>
          <td>
            <div style="display:flex; gap:0.35rem; flex-wrap:wrap;">
              <%-- Update Discount --%>
              <form method="post" action="${pageContext.request.contextPath}/admin/save-clearance" style="display:flex; gap:0.3rem;">
                <input type="hidden" name="clearanceId" value="${sc.clearanceId}">
                <input type="number" name="discountPercentage" value="${sc.discountPercentage}"
                       class="form-control" style="width:60px; padding:0.2rem 0.4rem; font-size:0.78rem; height:28px; border-radius:4px;"
                       min="0" max="90" step="5">
                <button class="btn btn-info btn-sm" style="height:28px; padding:0 0.5rem;">✔</button>
              </form>
              <%-- Deactivate --%>
              <c:if test="${sc.discountApplied}">
                <form method="post" action="${pageContext.request.contextPath}/admin/deactivate-clearance" style="display:inline;">
                  <input type="hidden" name="clearanceId" value="${sc.clearanceId}">
                  <button class="btn btn-warning btn-sm">Deactivate</button>
                </form>
              </c:if>
              <%-- Remove --%>
              <form method="post" action="${pageContext.request.contextPath}/admin/remove-clearance" style="display:inline;"
                    onsubmit="return confirm('Remove this clearance record?')">
                <input type="hidden" name="clearanceId" value="${sc.clearanceId}">
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
