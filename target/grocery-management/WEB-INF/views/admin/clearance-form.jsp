<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Add Clearance Record – FreshCart Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="➕ Add Clearance Record" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<div style="max-width:600px;">
  <div class="card">
    <div style="font-weight:800; font-size:1rem; margin-bottom:1.25rem;">Create Discount Record for Near-Expiry Product</div>
    <form method="post" action="${pageContext.request.contextPath}/admin/save-clearance">
      <input type="hidden" name="clearanceId" value="">

      <div class="form-group">
        <label class="form-label">Select Product</label>
        <select name="productId" class="form-control" required onchange="fillProductDetails(this)">
          <option value="">-- Select a product --</option>
          <c:forEach var="p" items="${products}">
            <option value="${p.productId}"
                    data-name="${p.name}"
                    data-price="${p.price}"
                    data-expiry="${p.expiryDate}"
                    data-mfg="${p.manufactureDate}"
                    data-stock="${p.stockQuantity}">
              ${p.name} (${p.category}) – LKR ${p.price}
            </option>
          </c:forEach>
        </select>
      </div>

      <input type="hidden" name="productName" id="productName">
      <input type="hidden" name="originalPrice" id="originalPrice">

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
        <div class="form-group">
          <label class="form-label">Manufacture Date</label>
          <input type="date" name="manufactureDate" id="manufactureDate" class="form-control" required>
        </div>
        <div class="form-group">
          <label class="form-label">Expiry Date</label>
          <input type="date" name="expiryDate" id="expiryDate" class="form-control" required>
        </div>
        <div class="form-group">
          <label class="form-label">Stock Quantity</label>
          <input type="number" name="stockQuantity" id="stockQuantity" class="form-control" min="1" required>
        </div>
        <div class="form-group">
          <label class="form-label">Stock Condition</label>
          <select name="stockCondition" class="form-control" required>
            <option value="LOW">LOW (1–20 units)</option>
            <option value="MEDIUM">MEDIUM (21–50 units)</option>
            <option value="HIGH">HIGH (50+ units)</option>
          </select>
        </div>
      </div>

      <div class="alert alert-info" style="font-size:0.85rem;">
        ℹ️ Discount will be automatically calculated based on days to expiry:<br>
        ≤1 day → 50% &nbsp;|&nbsp; ≤3 days → 35% &nbsp;|&nbsp; ≤7 days → 20% &nbsp;|&nbsp; ≤14 days → 10% &nbsp;|&nbsp; else → 5%
      </div>

      <div style="display:flex; gap:0.75rem;">
        <button type="submit" class="btn btn-primary">➕ Create Record</button>
        <a href="${pageContext.request.contextPath}/admin/clearance" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>
</div>

<jsp:include page="sidebar-close.jsp"/>
<script>
function fillProductDetails(sel) {
  const opt = sel.options[sel.selectedIndex];
  document.getElementById('productName').value   = opt.dataset.name   || '';
  document.getElementById('originalPrice').value  = opt.dataset.price  || '';
  document.getElementById('expiryDate').value     = opt.dataset.expiry || '';
  document.getElementById('manufactureDate').value = opt.dataset.mfg   || '';
  document.getElementById('stockQuantity').value  = opt.dataset.stock  || '';
}
</script>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
