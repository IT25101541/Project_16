<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Reset Password – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    .auth-wrapper { background-image: url('${pageContext.request.contextPath}/static/img/grocery-bg.jpg'); }
    .input-wrapper { position: relative; }
    .input-icon { position: absolute; left: 0.9rem; top: 50%; transform: translateY(-50%); font-size: 1rem; color: var(--text-light); pointer-events: none; }
    .input-wrapper .form-control { padding-left: 2.6rem; }
    .step-indicator {
      display: flex; align-items: center; justify-content: center;
      gap: 0; margin-bottom: 1.75rem;
    }
    .step-dot {
      width: 32px; height: 32px; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: 0.82rem; font-weight: 800;
      border: 2px solid var(--border);
      background: white; color: var(--text-light);
      transition: all 0.3s;
    }
    .step-dot.active { background: var(--green-mid); border-color: var(--green-mid); color: white; }
    .step-dot.done   { background: var(--green-dark); border-color: var(--green-dark); color: white; }
    .step-line { width: 60px; height: 2px; background: var(--border); }
    .step-line.done { background: var(--green-mid); }
  </style>
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card">
    <div class="auth-logo">
      <div class="auth-logo-icon">🔐</div>
      <h1>Fresh<span>Cart</span></h1>
      <p>Reset your password securely</p>
    </div>

    <%-- Step indicator --%>
    <div class="step-indicator">
      <div class="step-dot ${empty emailVerified ? 'active' : 'done'}">1</div>
      <div class="step-line ${empty emailVerified ? '' : 'done'}"></div>
      <div class="step-dot ${not empty emailVerified ? 'active' : ''}">2</div>
    </div>

    <c:if test="${not empty error}">
      <div class="alert alert-error">⚠️ ${error}</div>
    </c:if>

    <c:choose>
      <c:when test="${empty emailVerified}">
        <div class="auth-title">Find Your Account</div>
        <p style="text-align:center; color:var(--text-light); font-size:0.88rem; margin-bottom:1.5rem;">
          Enter your registered email to receive reset instructions.
        </p>
        <form method="post" action="${pageContext.request.contextPath}/user/forgot-password">
          <input type="hidden" name="step" value="verify">
          <div class="form-group">
            <label class="form-label">Email Address</label>
            <div class="input-wrapper">
              <span class="input-icon">✉️</span>
              <input type="email" name="email" class="form-control" placeholder="you@example.com" required autofocus>
            </div>
          </div>
          <button type="submit" class="btn btn-primary btn-block btn-lg">Continue →</button>
        </form>
      </c:when>
      <c:otherwise>
        <div class="auth-title">Set New Password</div>
        <div class="alert alert-success">✅ Account found: <strong>${email}</strong></div>
        <form method="post" action="${pageContext.request.contextPath}/user/forgot-password">
          <input type="hidden" name="step" value="reset">
          <input type="hidden" name="email" value="${email}">
          <div class="form-group">
            <label class="form-label">New Password</label>
            <div class="input-wrapper">
              <span class="input-icon">🔒</span>
              <input type="password" name="newPassword" class="form-control" placeholder="Minimum 6 characters" required minlength="6" autofocus>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Confirm New Password</label>
            <div class="input-wrapper">
              <span class="input-icon">🔒</span>
              <input type="password" name="confirmPassword" class="form-control" placeholder="Re-enter new password" required>
            </div>
          </div>
          <button type="submit" class="btn btn-primary btn-block btn-lg">Reset Password →</button>
        </form>
      </c:otherwise>
    </c:choose>

    <div style="text-align:center; margin-top:1.25rem;">
      <a href="${pageContext.request.contextPath}/user/login" class="auth-link" style="font-size:0.88rem;">
        ← Back to Login
      </a>
    </div>
  </div>
</div>
</body>
</html>
