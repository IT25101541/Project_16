<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>My Profile – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container">
  <div class="page-header">
    <div class="page-title">👤 My Profile</div>
  </div>

  <c:if test="${not empty success}"><div class="alert alert-success" data-dismiss="auto">✅ ${success}</div></c:if>
  <c:if test="${not empty error}"><div class="alert alert-error">⚠️ ${error}</div></c:if>

  <div style="max-width:500px;">
    <div class="card">
      <div style="font-weight:800; font-size:1rem; margin-bottom:1.25rem;">Edit Profile</div>
      <form method="post" action="${pageContext.request.contextPath}/user/update-profile">
        <div class="form-group">
          <label class="form-label">Full Name</label>
          <input type="text" name="username" class="form-control" value="${user.username}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Email Address</label>
          <input type="email" name="email" class="form-control" value="${user.email}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Phone Number</label>
          <input type="tel" name="phone" class="form-control" value="${user.phone}">
        </div>
        <button type="submit" class="btn btn-primary">Save Changes</button>
      </form>
    </div>

    <div class="card" style="margin-top:1rem; border:2px solid var(--red-light);">
      <div style="font-weight:800; font-size:1rem; color:var(--red); margin-bottom:0.75rem;">⚠️ Danger Zone</div>
      <form method="post" action="${pageContext.request.contextPath}/user/delete-account"
            onsubmit="return confirm('Are you sure? This cannot be undone.')">
        <button type="submit" class="btn btn-danger">Delete My Account</button>
      </form>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
