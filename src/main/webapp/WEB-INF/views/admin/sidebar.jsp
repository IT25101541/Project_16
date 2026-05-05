<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
  .admin-layout { display:flex; min-height:100vh; }
  .sidebar {
    width: 240px; background: var(--green-dark); color: white;
    display: flex; flex-direction: column; flex-shrink: 0;
    position: sticky; top: 0; height: 100vh; overflow-y: auto;
  }
  .sidebar-brand {
    padding: 1.5rem 1.25rem;
    font-size: 1.3rem; font-weight: 900;
    border-bottom: 1px solid rgba(255,255,255,0.1);
  }
  .sidebar-brand span { color: #f39c12; }
  .sidebar-label {
    font-size: 0.7rem; font-weight: 800; letter-spacing: 1px;
    text-transform: uppercase; color: rgba(255,255,255,0.4);
    padding: 1rem 1.25rem 0.5rem;
  }
  .sidebar-link {
    display: flex; align-items: center; gap: 0.75rem;
    padding: 0.7rem 1.25rem;
    color: rgba(255,255,255,0.8);
    text-decoration: none; font-weight: 600; font-size: 0.92rem;
    transition: all 0.2s; border-left: 3px solid transparent;
  }
  .sidebar-link:hover, .sidebar-link.active {
    background: rgba(255,255,255,0.1);
    color: white; border-left-color: #f39c12;
  }
  .sidebar-link .icon { font-size: 1.1rem; width: 24px; text-align: center; }
  .admin-main { flex: 1; overflow: auto; }
  .admin-topbar {
    background: white; border-bottom: 2px solid var(--border);
    padding: 0.75rem 1.5rem;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 50;
    box-shadow: var(--shadow-sm);
  }
  .admin-topbar h2 { font-size: 1.1rem; font-weight: 800; color: var(--text-dark); }
  .admin-content { padding: 1.5rem; }
</style>

<div class="admin-layout">
  <div class="sidebar">
    <div class="sidebar-brand">🛒 Fresh<span>Cart</span><br><small style="font-size:0.7rem; opacity:0.6; font-weight:400;">Admin Panel</small></div>

    <div class="sidebar-label">Main</div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
      <span class="icon">📊</span> Dashboard
    </a>

    <div class="sidebar-label">Management</div>
    <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
      <span class="icon">👥</span> User Management
    </a>
    <a href="${pageContext.request.contextPath}/admin/products" class="sidebar-link">
      <span class="icon">🛍️</span> Product Management
    </a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link">
      <span class="icon">📦</span> Order Management
    </a>
    <a href="${pageContext.request.contextPath}/admin/deliveries" class="sidebar-link">
      <span class="icon">🚚</span> Delivery Management
    </a>
    <a href="${pageContext.request.contextPath}/admin/clearance" class="sidebar-link">
      <span class="icon">🏷️</span> Stock Clearance
    </a>

    <div style="margin-top:auto; padding:1rem 1.25rem; border-top:1px solid rgba(255,255,255,0.1);">
      <div style="font-size:0.82rem; color:rgba(255,255,255,0.5); margin-bottom:0.5rem;">
        Logged in as Admin
      </div>
      <a href="${pageContext.request.contextPath}/user/logout" class="sidebar-link" style="padding:0.4rem 0; color:rgba(255,100,100,0.9);">
        <span class="icon">🚪</span> Logout
      </a>
    </div>
  </div>
  <div class="admin-main">
    <div class="admin-topbar">
      <h2>${pageTitle}</h2>
      <div style="font-size:0.85rem; color:var(--text-light);">FreshCart Admin &nbsp;|&nbsp; ${sessionScope.loggedUser.username}</div>
    </div>
    <div class="admin-content">
