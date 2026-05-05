<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Create Account – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    .auth-wrapper { background-image: url('${pageContext.request.contextPath}/static/img/grocery-bg.jpg'); }
    .input-wrapper { position: relative; }
    .input-icon { position: absolute; left: 0.9rem; top: 50%; transform: translateY(-50%); font-size: 1rem; color: var(--text-light); pointer-events: none; }
    .input-wrapper .form-control { padding-left: 2.6rem; }
    .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; }
    @media(max-width:480px){ .two-col{grid-template-columns:1fr;} }
  </style>
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card">
    <div class="auth-logo">
      <div class="auth-logo-icon">🛒</div>
      <h1>Fresh<span>Cart</span></h1>
      <p>Create your free account today</p>
    </div>
    <div class="auth-title">Join FreshCart</div>

    <c:if test="${not empty error}">
      <div class="alert alert-error">⚠️ ${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/user/register">
      <div class="two-col">
        <div class="form-group" style="grid-column:1/-1;">
          <label class="form-label">Full Name</label>
          <div class="input-wrapper">
            <span class="input-icon">👤</span>
            <input type="text" name="username" class="form-control" placeholder="Kamal Perera" required autofocus>
          </div>
        </div>
        <div class="form-group" style="grid-column:1/-1;">
          <label class="form-label">Email Address</label>
          <div class="input-wrapper">
            <span class="input-icon">✉️</span>
            <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
          </div>
        </div>
        <div class="form-group" style="grid-column:1/-1;">
          <label class="form-label">Phone Number</label>
          <div class="input-wrapper">
            <span class="input-icon">📱</span>
            <input type="tel" name="phone" class="form-control" placeholder="07X XXXXXXX" required>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Password</label>
          <div class="input-wrapper">
            <span class="input-icon">🔒</span>
            <input type="password" name="password" class="form-control" placeholder="Min 6 chars" required minlength="6">
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Confirm Password</label>
          <div class="input-wrapper">
            <span class="input-icon">🔒</span>
            <input type="password" name="confirmPassword" class="form-control" placeholder="Re-enter" required>
          </div>
        </div>
      </div>
      <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top:0.25rem;">
        Create Account →
      </button>
    </form>

    <div class="auth-divider">or</div>
    <div style="text-align:center; font-size:0.9rem; color:var(--text-mid);">
      Already have an account?
      <a href="${pageContext.request.contextPath}/user/login" class="auth-link">Sign in</a>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
