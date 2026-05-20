<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Product Management – FreshCart Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="🛍️ Product Management" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem; flex-wrap:wrap; gap:0.75rem;">
  <div style="font-size:0.9rem; color:var(--text-light);">${products.size()} products</div>
  <a href="${pageContext.request.contextPath}/admin/product-add" class="btn btn-primary">+ Add Product</a>
</div>

<div class="card" style="padding:0; overflow:hidden;">
  <table class="data-table">
    <thead>
      <tr>
        <th>ID</th><th>Name</th><th>Category</th><th>Price</th>
        <th>Stock</th><th>Expiry</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <c:if test="${empty products}">
        <tr><td colspan="7" style="text-align:center; color:var(--text-light); padding:2rem;">No products found.</td></tr>
      </c:if>
      <c:forEach var="p" items="${products}">
        <tr>
          <td style="font-size:0.78rem; color:var(--text-light);">${p.productId}</td>
          <td style="font-weight:700;">${p.name}</td>
          <td><span class="status-badge status-active">${p.category}</span></td>
          <td style="font-weight:700; color:var(--green-dark);">LKR <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></td>
          <td>
            <span class="${p.stockQuantity < 10 ? 'status-badge status-cancelled' : 'status-badge status-active'}">
              ${p.stockQuantity}
            </span>
          </td>
          <td style="font-size:0.85rem;">${p.expiryDate}</td>
          <td>
            <div style="display:flex; gap:0.4rem;">
              <a href="${pageContext.request.contextPath}/admin/product-edit?id=${p.productId}" class="btn btn-warning btn-sm">✏️ Edit</a>
              <form method="post" action="${pageContext.request.contextPath}/admin/delete-product" style="display:inline;"
                    onsubmit="return confirm('Delete ${p.name}?')">
                <input type="hidden" name="productId" value="${p.productId}">
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
