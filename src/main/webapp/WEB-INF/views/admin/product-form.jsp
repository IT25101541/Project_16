<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>${empty product ? 'Add Product' : 'Edit Product'} – FreshCart Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="${empty product ? '➕ Add Product' : '✏️ Edit Product'}" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<div style="max-width:600px;">
  <div class="card">
    <div style="font-weight:800; font-size:1rem; margin-bottom:1.25rem;">
      ${empty product ? 'Add New Product' : 'Edit Product'}
    </div>
    <form method="post" action="${pageContext.request.contextPath}/admin/save-product">
      <input type="hidden" name="productId" value="${product.productId}">

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
        <div class="form-group" style="grid-column:1/-1;">
          <label class="form-label">Product Name</label>
          <input type="text" name="name" class="form-control" value="${product.name}" placeholder="e.g. Basmati Rice 1kg" required>
        </div>
        <div class="form-group">
          <label class="form-label">Category</label>
          <select name="category" class="form-control" required>
            <c:forEach var="cat" items="${['Fruits','Vegetables','Meat','Dairy','Bakery','Staple Grocery','Beverage','Frozen']}">
              <option value="${cat}" ${product.category == cat ? 'selected' : ''}>${cat}</option>
            </c:forEach>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Price (LKR)</label>
          <input type="number" name="price" class="form-control" value="${product.price}" step="0.01" min="0" required>
        </div>
        <div class="form-group">
          <label class="form-label">Stock Quantity</label>
          <input type="number" name="stock" class="form-control" value="${product.stockQuantity}" min="0" required>
        </div>
        <div class="form-group">
          <label class="form-label">Manufacture Date</label>
          <input type="date" name="manufactureDate" class="form-control" value="${product.manufactureDate}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Expiry Date</label>
          <input type="date" name="expiryDate" class="form-control" value="${product.expiryDate}" required>
        </div>
        <div class="form-group" style="grid-column:1/-1;">
          <label class="form-label">Image URL (optional)</label>
          <input type="text" name="imageUrl" class="form-control" value="${product.imageUrl}" placeholder="/static/img/product.png">
        </div>
      </div>

      <div style="display:flex; gap:0.75rem; margin-top:0.5rem;">
        <button type="submit" class="btn btn-primary">${empty product ? '➕ Add Product' : '💾 Save Changes'}</button>
        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>
</div>

<jsp:include page="sidebar-close.jsp"/>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
