<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .navbar {
    background: linear-gradient(135deg, #0d3b1f 0%, #155c2a 50%, #1a7a35 100%) !important;
    border-bottom: none !important;
    box-shadow: 0 4px 24px rgba(13,59,31,0.45) !important;
  }
  .navbar-brand {
    color: #ffffff !important;
    font-size: 1.6rem;
  }
  .navbar-brand .brand-accent { color: #ffd54f !important; }
  .navbar-brand .brand-icon {
    background: rgba(255,255,255,0.15) !important;
    box-shadow: 0 4px 12px rgba(0,0,0,0.2) !important;
  }
  .navbar-brand:hover { transform: scale(1.03); }

  .nav-link {
    color: rgba(255,255,255,0.85) !important;
    font-weight: 700;
    border-radius: 10px;
    padding: 0.4rem 0.9rem;
    transition: all 0.2s;
  }
  .nav-link:hover {
    color: #ffffff !important;
    background: rgba(255,255,255,0.15) !important;
  }
  .nav-link::after { background: #ffd54f !important; }

  .nav-user-chip {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    background: rgba(255,255,255,0.12);
    border: 1px solid rgba(255,255,255,0.2);
    border-radius: 50px;
    padding: 0.3rem 0.9rem 0.3rem 0.4rem;
    color: white !important;
    font-weight: 700;
    font-size: 0.87rem;
    text-decoration: none;
    transition: all 0.2s;
  }
  .nav-user-chip:hover {
    background: rgba(255,255,255,0.22) !important;
    color: white !important;
    transform: none;
  }
  .nav-user-avatar {
    width: 28px; height: 28px;
    border-radius: 50%;
    background: linear-gradient(135deg, #ffd54f, #ffb300);
    display: flex; align-items: center; justify-content: center;
    font-size: 0.75rem;
    font-weight: 900;
    color: #1a1a1a;
    flex-shrink: 0;
  }
  .nav-divider {
    width: 1px; height: 22px;
    background: rgba(255,255,255,0.2);
    margin: 0 0.25rem;
  }
  .nav-logout {
    color: #ff8a80 !important;
    display: flex; align-items: center; gap: 0.35rem;
    padding: 0.4rem 0.85rem;
    border-radius: 10px;
    font-weight: 700; font-size: 0.87rem;
    text-decoration: none;
    transition: all 0.2s;
    border: 1px solid rgba(255,138,128,0.3);
  }
  .nav-logout:hover {
    background: rgba(255,138,128,0.15) !important;
    color: #ff8a80 !important;
    border-color: rgba(255,138,128,0.6);
  }
  .cart-badge {
    background: #ffd54f !important;
    color: #1a1a1a !important;
    font-weight: 900;
  }
</style>

<nav class="navbar">
  <a class="navbar-brand" href="${pageContext.request.contextPath}/shop/categories">
    <div class="brand-icon">🛒</div>
    Fresh<span class="brand-accent">Cart</span>
  </a>
  <div class="navbar-nav">
    <a class="nav-link" href="${pageContext.request.contextPath}/shop/categories">🏪 Shop</a>
    <a class="nav-link" href="${pageContext.request.contextPath}/shop/clearance">🏷️ Deals</a>
    <a class="nav-link" href="${pageContext.request.contextPath}/shop/cart">
      🛒 Cart <span class="cart-badge">•</span>
    </a>
    <a class="nav-link" href="${pageContext.request.contextPath}/shop/order-history">📦 Orders</a>
    <div class="nav-divider"></div>
    <a class="nav-user-chip" href="${pageContext.request.contextPath}/user/profile">
      <div class="nav-user-avatar">
        ${sessionScope.loggedUser.username.substring(0,1).toUpperCase()}
      </div>
      ${sessionScope.loggedUser.username}
    </a>
    <a class="nav-logout" href="${pageContext.request.contextPath}/user/logout">
      🚪 Logout
    </a>
  </div>
</nav>
