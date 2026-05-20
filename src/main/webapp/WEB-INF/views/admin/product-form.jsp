<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>${empty product ? 'Add Product' : 'Edit Product'} – FreshCart Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    .image-upload-area {
      border: 2px dashed var(--border);
      border-radius: var(--radius-sm);
      padding: 1.5rem;
      text-align: center;
      cursor: pointer;
      transition: all 0.25s;
      background: #fafff9;
      position: relative;
    }
    .image-upload-area:hover { border-color: var(--green-mid); background: var(--green-pale); }
    .image-upload-area.drag-over { border-color: var(--green-mid); background: var(--green-pale); }
    .image-upload-area input[type="file"] {
      position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; height: 100%;
    }
    .upload-icon { font-size: 2.5rem; margin-bottom: 0.5rem; }
    .upload-text { font-weight: 700; color: var(--text-mid); font-size: 0.9rem; }
    .upload-hint { font-size: 0.78rem; color: var(--text-light); margin-top: 0.25rem; }

    .image-preview-wrap {
      margin-top: 1rem;
      display: none;
      position: relative;
    }
    .image-preview-wrap img {
      width: 100%; max-height: 200px;
      object-fit: cover;
      border-radius: var(--radius-sm);
      border: 2px solid var(--border);
    }
    .img-preview-label {
      font-size: 0.75rem; font-weight: 700; color: var(--green-dark);
      margin-bottom: 0.4rem; display: flex; align-items: center; gap: 0.4rem;
    }

    .current-img-wrap {
      margin-bottom: 1rem;
    }
    .current-img-wrap img {
      width: 100%; max-height: 160px; object-fit: cover;
      border-radius: var(--radius-sm); border: 2px solid var(--green-pale);
    }
    .current-img-label {
      font-size: 0.75rem; font-weight: 700; color: var(--text-mid);
      margin-bottom: 0.4rem;
    }

    .tab-toggle {
      display: flex; gap: 0; border: 2px solid var(--border);
      border-radius: var(--radius-sm); overflow: hidden; margin-bottom: 1rem;
    }
    .tab-btn {
      flex: 1; padding: 0.5rem; font-weight: 700; font-size: 0.85rem;
      border: none; background: white; color: var(--text-mid);
      cursor: pointer; transition: all 0.2s; font-family: 'Nunito', sans-serif;
    }
    .tab-btn.active { background: var(--green-mid); color: white; }
  </style>
</head>
<body>
<c:set var="pageTitle" value="${empty product ? '➕ Add Product' : '✏️ Edit Product'}" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<div style="max-width:650px;">
  <div class="card">
    <div style="font-weight:800; font-size:1rem; margin-bottom:1.25rem;">
      ${empty product ? '➕ Add New Product' : '✏️ Edit Product'}
    </div>

    <%-- IMPORTANT: enctype multipart for file upload --%>
    <form method="post" action="${pageContext.request.contextPath}/admin/save-product"
          enctype="multipart/form-data">
      <input type="hidden" name="productId" value="${product.productId}">

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">

        <div class="form-group" style="grid-column:1/-1;">
          <label class="form-label">Product Name</label>
          <input type="text" name="name" class="form-control"
                 value="${product.name}" placeholder="e.g. Basmati Rice 1kg" required>
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
          <input type="number" name="price" class="form-control"
                 value="${product.price}" step="0.01" min="0" required>
        </div>

        <div class="form-group">
          <label class="form-label">Stock Quantity</label>
          <input type="number" name="stock" class="form-control"
                 value="${product.stockQuantity}" min="0" required>
        </div>

        <div class="form-group">
          <label class="form-label">Manufacture Date</label>
          <input type="date" name="manufactureDate" class="form-control"
                 value="${product.manufactureDate}" required>
        </div>

        <div class="form-group">
          <label class="form-label">Expiry Date</label>
          <input type="date" name="expiryDate" class="form-control"
                 value="${product.expiryDate}" required>
        </div>

        <%-- ── IMAGE SECTION ── --%>
        <div class="form-group" style="grid-column:1/-1;">
          <label class="form-label">Product Image</label>

          <%-- Show current image if editing --%>
          <c:if test="${not empty product.imageUrl}">
            <div class="current-img-wrap">
              <div class="current-img-label">📷 Current Image</div>
              <img src="${pageContext.request.contextPath}${product.imageUrl}"
                   onerror="this.style.display='none'"
                   alt="Current product image">
            </div>
          </c:if>

          <%-- Toggle: upload file OR enter URL --%>
          <div class="tab-toggle">
            <button type="button" class="tab-btn active" id="tabUpload"
                    onclick="showTab('upload')">📁 Upload Image</button>
            <button type="button" class="tab-btn" id="tabUrl"
                    onclick="showTab('url')">🔗 Image URL</button>
          </div>

          <%-- Upload panel --%>
          <div id="panelUpload">
            <div class="image-upload-area" id="uploadArea">
              <input type="file" name="imageFile" id="imageFile"
                     accept="image/*" onchange="previewImage(this)">
              <div class="upload-icon">📤</div>
              <div class="upload-text">Click or drag &amp; drop an image here</div>
              <div class="upload-hint">PNG, JPG, WEBP — max 5 MB</div>
            </div>
            <div class="image-preview-wrap" id="previewWrap">
              <div class="img-preview-label">✅ Selected image preview:</div>
              <img id="previewImg" src="" alt="Preview">
            </div>
          </div>

          <%-- URL panel --%>
          <div id="panelUrl" style="display:none;">
            <input type="text" name="imageUrl" id="imageUrl" class="form-control"
                   value="${product.imageUrl}"
                   placeholder="/static/img/products/myproduct.jpg or https://...">
            <div style="font-size:0.78rem; color:var(--text-light); margin-top:0.4rem;">
              Enter an image URL or path starting with /static/img/
            </div>
          </div>
        </div>

      </div><%-- end grid --%>

      <div style="display:flex; gap:0.75rem; margin-top:1rem;">
        <button type="submit" class="btn btn-primary">
          ${empty product ? '➕ Add Product' : '💾 Save Changes'}
        </button>
        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>
</div>

<jsp:include page="sidebar-close.jsp"/>
<script>
  function showTab(tab) {
    document.getElementById('panelUpload').style.display = tab === 'upload' ? 'block' : 'none';
    document.getElementById('panelUrl').style.display    = tab === 'url'    ? 'block' : 'none';
    document.getElementById('tabUpload').classList.toggle('active', tab === 'upload');
    document.getElementById('tabUrl').classList.toggle('active', tab === 'url');
    // disable the inactive field so it doesn't submit empty
    document.getElementById('imageFile').disabled = tab !== 'upload';
    document.getElementById('imageUrl').disabled  = tab !== 'url';
  }

  function previewImage(input) {
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = e => {
        document.getElementById('previewImg').src = e.target.result;
        document.getElementById('previewWrap').style.display = 'block';
      };
      reader.readAsDataURL(input.files[0]);
      document.getElementById('uploadArea').style.borderColor = 'var(--green-mid)';
    }
  }

  // Drag & drop visual feedback
  const area = document.getElementById('uploadArea');
  if (area) {
    area.addEventListener('dragover',  () => area.classList.add('drag-over'));
    area.addEventListener('dragleave', () => area.classList.remove('drag-over'));
    area.addEventListener('drop',      () => area.classList.remove('drag-over'));
  }

  // init: upload tab active by default
  showTab('upload');

  // If product already has imageUrl, show url tab
  const existingUrl = '${product.imageUrl}';
  if (existingUrl && existingUrl.trim() !== '') showTab('url');
</script>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
