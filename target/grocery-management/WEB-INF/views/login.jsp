<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Sign In – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    .auth-split {
      min-height: 100vh;
      display: flex;
    }
    /* Left panel — background image */
    .auth-left {
      flex: 1;
      background-image: url('${pageContext.request.contextPath}/static/img/grocery-bg.jpg');
      background-size: cover;
      background-position: center;
      position: relative;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      justify-content: flex-end;
      padding: 3rem;
    }
    .auth-left::before {
      content: '';
      position: absolute; inset: 0;
      background: linear-gradient(160deg, rgba(21,92,42,0.7) 0%, rgba(0,0,0,0.7) 100%);
    }
    .auth-left-content {
      position: relative; z-index: 1; color: white;
      animation: fadeInUp 0.8s ease 0.2s both;
    }
    .auth-left-content h2 {
      font-family: 'Poppins', sans-serif;
      font-size: 2.4rem; font-weight: 800;
      line-height: 1.15; margin-bottom: 0.75rem;
      text-shadow: 0 2px 16px rgba(0,0,0,0.4);
    }
    .auth-left-content h2 span { color: #ffd54f; }
    .auth-left-content p {
      font-size: 1rem; opacity: 0.88; font-weight: 600;
      max-width: 340px; line-height: 1.6;
      text-shadow: 0 1px 8px rgba(0,0,0,0.4);
    }
    .auth-features {
      display: flex; flex-direction: column; gap: 0.75rem; margin-top: 2rem;
    }
    .auth-feature {
      display: flex; align-items: center; gap: 0.75rem;
      background: rgba(255,255,255,0.12);
      backdrop-filter: blur(8px);
      padding: 0.65rem 1rem; border-radius: 12px;
      font-weight: 700; font-size: 0.88rem;
      border: 1px solid rgba(255,255,255,0.2);
      animation: slideRight 0.6s ease both;
    }
    .auth-feature:nth-child(1) { animation-delay: 0.3s; }
    .auth-feature:nth-child(2) { animation-delay: 0.45s; }
    .auth-feature:nth-child(3) { animation-delay: 0.6s; }
    .auth-feature-icon {
      width: 32px; height: 32px; border-radius: 8px;
      background: rgba(255,255,255,0.2);
      display: flex; align-items: center; justify-content: center;
      font-size: 1rem; flex-shrink: 0;
    }

    /* Right panel — form */
    .auth-right {
      width: 480px; flex-shrink: 0;
      background: #fafff9;
      display: flex; align-items: center; justify-content: center;
      padding: 2.5rem;
    }
    .auth-right-inner {
      width: 100%; max-width: 380px;
      animation: scaleIn 0.5s cubic-bezier(.34,1.56,.64,1);
    }
    .auth-right .auth-logo { margin-bottom: 2rem; }
    .auth-right .auth-logo-icon { animation: float 3s ease-in-out infinite; }

    /* Input icon wrapper */
    .input-wrapper { position: relative; }
    .input-icon {
      position: absolute; left: 0.9rem; top: 50%;
      transform: translateY(-50%);
      font-size: 1rem; color: var(--text-light);
      pointer-events: none;
    }
    .input-wrapper .form-control { padding-left: 2.6rem; }

    @keyframes slideRight {
      from { opacity: 0; transform: translateX(-20px); }
      to   { opacity: 1; transform: translateX(0); }
    }

    @media (max-width: 768px) {
      .auth-split { flex-direction: column; }
      .auth-left  { min-height: 220px; padding: 1.5rem; }
      .auth-left-content h2 { font-size: 1.6rem; }
      .auth-features { display: none; }
      .auth-right { width: 100%; }
    }
  </style>
</head>
<body>
<div class="auth-split">

  <%-- LEFT — Hero panel --%>
  <div class="auth-left">
    <div class="auth-left-content">
      <h2>Fresh Groceries,<br>Delivered to Your <span>Door</span></h2>
      <p>Shop from hundreds of fresh products across 8 categories. Fast delivery, great prices.</p>
      <div class="auth-features">
        <div class="auth-feature">
          <div class="auth-feature-icon">🚚</div>
          <span>Same-day delivery available</span>
        </div>
        <div class="auth-feature">
          <div class="auth-feature-icon">🏷️</div>
          <span>Up to 50% off near-expiry deals</span>
        </div>
        <div class="auth-feature">
          <div class="auth-feature-icon">🌿</div>
          <span>Farm-fresh quality guaranteed</span>
        </div>
      </div>
    </div>
  </div>

  <%-- RIGHT — Login form --%>
  <div class="auth-right">
    <div class="auth-right-inner">
      <div class="auth-logo">
        <div class="auth-logo-icon">🛒</div>
        <h1>Fresh<span>Cart</span></h1>
        <p>Your online grocery store</p>
      </div>

      <div class="auth-title">Welcome back!</div>

      <c:if test="${not empty error}">
        <div class="alert alert-error">⚠️ ${error}</div>
      </c:if>
      <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
      </c:if>
      <c:if test="${param.deleted == 'true'}">
        <div class="alert alert-info">ℹ️ Your account has been deleted.</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/user/login">
        <div class="form-group">
          <label class="form-label">Email Address</label>
          <div class="input-wrapper">
            <span class="input-icon">✉️</span>
            <input type="email" name="email" class="form-control"
                   placeholder="you@example.com" required autofocus>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">Password</label>
          <div class="input-wrapper">
            <span class="input-icon">🔒</span>
            <input type="password" name="password" class="form-control"
                   placeholder="Enter your password" required>
          </div>
        </div>
        <div style="text-align:right; margin-bottom:1.25rem;">
          <a href="${pageContext.request.contextPath}/user/forgot-password"
             class="auth-link" style="font-size:0.85rem;">Forgot password?</a>
        </div>
        <button type="submit" class="btn btn-primary btn-block btn-lg"
                style="font-size:1rem;">
          Sign In →
        </button>
      </form>

      <div class="auth-divider">or</div>
      <div style="text-align:center; font-size:0.9rem; color:var(--text-mid);">
        New to FreshCart?
        <a href="${pageContext.request.contextPath}/user/register" class="auth-link">
          Create a free account
        </a>
      </div>

      <div style="margin-top:2rem; text-align:center;">
        <div style="display:flex; justify-content:center; gap:1.5rem; font-size:0.78rem; color:var(--text-light);">
          <span>🔒 Secure & Encrypted</span>
          <span>🌿 100% Fresh</span>
          <span>⚡ Fast Delivery</span>
        </div>
      </div>
    </div>
  </div>

</div>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
