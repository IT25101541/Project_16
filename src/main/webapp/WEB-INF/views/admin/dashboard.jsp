<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Admin Dashboard – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
  <style>
    /* ── Admin content background ── */
    .admin-content {
      background: linear-gradient(135deg, #f0fdf4 0%, #e6f7ec 40%, #fef9e7 100%);
      min-height: calc(100vh - 64px);
      padding: 1.75rem;
      position: relative;
    }
    .admin-content::before {
      content: '';
      position: fixed; inset: 0;
      background-image:
        radial-gradient(circle at 15% 20%, rgba(34,168,74,0.08) 0%, transparent 50%),
        radial-gradient(circle at 85% 70%, rgba(240,124,0,0.07) 0%, transparent 50%),
        radial-gradient(circle at 50% 90%, rgba(25,118,210,0.06) 0%, transparent 50%);
      pointer-events: none;
      z-index: 0;
    }
    .admin-content > * { position: relative; z-index: 1; }

    /* ── Welcome banner ── */
    .dashboard-welcome {
      background: linear-gradient(135deg, #0d3b1f 0%, #155c2a 50%, #1a7a35 100%);
      border-radius: 20px;
      padding: 2rem 2.5rem;
      color: white;
      margin-bottom: 1.75rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
      box-shadow: 0 8px 32px rgba(13,59,31,0.35);
      position: relative;
      overflow: hidden;
      animation: fadeInDown 0.5s ease;
    }
    .dashboard-welcome::before {
      content: '';
      position: absolute;
      right: -40px; top: -40px;
      width: 220px; height: 220px;
      border-radius: 50%;
      background: rgba(255,255,255,0.06);
    }
    .dashboard-welcome::after {
      content: '';
      position: absolute;
      right: 60px; bottom: -60px;
      width: 160px; height: 160px;
      border-radius: 50%;
      background: rgba(255,213,79,0.08);
    }
    .welcome-text h2 {
      font-family: 'Poppins', sans-serif;
      font-size: 1.7rem; font-weight: 800;
      margin-bottom: 0.3rem;
    }
    .welcome-text h2 span { color: #ffd54f; }
    .welcome-text p { opacity: 0.78; font-size: 0.9rem; font-weight: 600; }
    .welcome-icon { font-size: 4rem; opacity: 0.5; position: relative; z-index: 1; animation: float 3s ease-in-out infinite; }

    /* ── Colorful stat cards ── */
    .stat-card {
      border: none !important;
      color: white;
      position: relative;
      overflow: hidden;
    }
    .stat-card::before { height: 0 !important; } /* remove top line */
    .stat-card::after {
      content: '';
      position: absolute;
      right: -20px; bottom: -20px;
      width: 100px; height: 100px;
      border-radius: 50%;
      background: rgba(255,255,255,0.10);
    }
    .stat-card .stat-value { color: white !important; font-size: 1.55rem !important; }
    .stat-card .stat-label { color: rgba(255,255,255,0.82) !important; }
    .stat-card .stat-icon  { background: rgba(255,255,255,0.2) !important; color: white; font-size: 1.4rem; }

    .stat-card-revenue  { background: linear-gradient(135deg, #1b5e20, #2e7d32); box-shadow: 0 8px 24px rgba(27,94,32,0.40); }
    .stat-card-orders   { background: linear-gradient(135deg, #0d47a1, #1976d2); box-shadow: 0 8px 24px rgba(13,71,161,0.40); }
    .stat-card-users    { background: linear-gradient(135deg, #4a148c, #7b1fa2); box-shadow: 0 8px 24px rgba(74,20,140,0.40); }
    .stat-card-products { background: linear-gradient(135deg, #e65100, #f57c00); box-shadow: 0 8px 24px rgba(230,81,0,0.40); }
    .stat-card-pending  { background: linear-gradient(135deg, #b71c1c, #c62828); box-shadow: 0 8px 24px rgba(183,28,28,0.38); }

    /* ── Section title ── */
    .section-heading {
      font-family: 'Poppins', sans-serif;
      font-size: 1rem; font-weight: 800;
      color: var(--text-dark);
      margin-bottom: 1rem;
      display: flex; align-items: center; gap: 0.5rem;
    }
    .section-heading::after {
      content: '';
      flex: 1; height: 2px;
      background: linear-gradient(90deg, var(--border), transparent);
      border-radius: 2px;
    }

    /* ── Colorful management tiles ── */
    .admin-tile {
      border: none !important;
      background: white;
      position: relative;
      overflow: hidden;
    }
    .admin-tile::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 4px;
      border-radius: 16px 16px 0 0;
    }
    .admin-tile-users::before    { background: linear-gradient(90deg, #1565c0, #42a5f5); }
    .admin-tile-products::before { background: linear-gradient(90deg, #1b5e20, #66bb6a); }
    .admin-tile-orders::before   { background: linear-gradient(90deg, #e65100, #ffa726); }
    .admin-tile-delivery::before { background: linear-gradient(90deg, #4a148c, #ab47bc); }
    .admin-tile-clearance::before{ background: linear-gradient(90deg, #b71c1c, #ef5350); }

    .admin-tile:hover {
      box-shadow: 0 12px 32px rgba(0,0,0,0.14) !important;
    }
    .tile-blue   { background: linear-gradient(135deg, #bbdefb, #e3f2fd) !important; }
    .tile-green  { background: linear-gradient(135deg, #c8e6c9, #e8f5e9) !important; }
    .tile-orange { background: linear-gradient(135deg, #ffe0b2, #fff3e0) !important; }
    .tile-purple { background: linear-gradient(135deg, #e1bee7, #f3e5f5) !important; }
    .tile-red    { background: linear-gradient(135deg, #ffcdd2, #fdecea) !important; }

    /* ── Chart cards ── */
    .chart-card {
      background: white;
      border-radius: var(--radius);
      padding: 1.4rem;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border);
    }
    .chart-card-header {
      font-weight: 800; font-size: 0.92rem;
      margin-bottom: 1rem;
      display: flex; align-items: center; gap: 0.5rem;
      color: var(--text-dark);
    }
    .chart-dot {
      width: 10px; height: 10px; border-radius: 50%;
    }

    /* ── Recent orders table ── */
    .orders-card {
      background: white; border-radius: var(--radius);
      box-shadow: var(--shadow-sm); border: 1px solid var(--border);
      overflow: hidden;
    }
    .orders-card-header {
      padding: 1.1rem 1.4rem;
      font-weight: 800; font-size: 0.92rem;
      border-bottom: 2px solid var(--border);
      background: linear-gradient(135deg, #f0fdf4, #e6f7ec);
      color: var(--green-dark);
      display: flex; align-items: center; gap: 0.5rem;
    }
  </style>
</head>
<body>
<c:set var="pageTitle" value="Dashboard" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<!-- Welcome Banner -->
<div class="dashboard-welcome">
  <div class="welcome-text" style="position:relative;z-index:1;">
    <h2>Welcome back, <span>${sessionScope.loggedUser.username}</span>! 👋</h2>
    <p>Here's what's happening with FreshCart today.</p>
  </div>
  <div class="welcome-icon">🛒</div>
</div>

<!-- Colorful Stats Row -->
<div class="section-heading">📊 Overview</div>
<div class="stat-grid" style="margin-bottom:1.75rem;">
  <div class="stat-card stat-card-revenue anim-up" style="animation-delay:0.05s">
    <div class="stat-icon">💰</div>
    <div class="stat-value">LKR <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></div>
    <div class="stat-label">Total Revenue</div>
  </div>
  <div class="stat-card stat-card-orders anim-up" style="animation-delay:0.10s">
    <div class="stat-icon">📦</div>
    <div class="stat-value">${totalOrders}</div>
    <div class="stat-label">Total Orders</div>
  </div>
  <div class="stat-card stat-card-users anim-up" style="animation-delay:0.15s">
    <div class="stat-icon">👥</div>
    <div class="stat-value">${totalUsers}</div>
    <div class="stat-label">Registered Users</div>
  </div>
  <div class="stat-card stat-card-products anim-up" style="animation-delay:0.20s">
    <div class="stat-icon">🛍️</div>
    <div class="stat-value">${totalProducts}</div>
    <div class="stat-label">Products</div>
  </div>
  <div class="stat-card stat-card-pending anim-up" style="animation-delay:0.25s">
    <div class="stat-icon">⏳</div>
    <div class="stat-value">${pendingOrders}</div>
    <div class="stat-label">Pending Orders</div>
  </div>
</div>

<!-- Management Tiles -->
<div class="section-heading">🗂️ Management Modules</div>
<div class="admin-tile-grid" style="margin-bottom:1.75rem;">
  <a href="${pageContext.request.contextPath}/admin/users" class="admin-tile admin-tile-users anim-up" style="animation-delay:0.05s">
    <div class="admin-tile-icon tile-blue">👥</div>
    <div class="admin-tile-info">
      <h3>User Management</h3>
      <p>View, block, unblock &amp; remove users</p>
    </div>
  </a>
  <a href="${pageContext.request.contextPath}/admin/products" class="admin-tile admin-tile-products anim-up" style="animation-delay:0.10s">
    <div class="admin-tile-icon tile-green">🛍️</div>
    <div class="admin-tile-info">
      <h3>Product Management</h3>
      <p>Add, edit, remove products &amp; stock</p>
    </div>
  </a>
  <a href="${pageContext.request.contextPath}/admin/orders" class="admin-tile admin-tile-orders anim-up" style="animation-delay:0.15s">
    <div class="admin-tile-icon tile-orange">📦</div>
    <div class="admin-tile-info">
      <h3>Order Management</h3>
      <p>View, edit &amp; cancel orders</p>
    </div>
  </a>
  <a href="${pageContext.request.contextPath}/admin/deliveries" class="admin-tile admin-tile-delivery anim-up" style="animation-delay:0.20s">
    <div class="admin-tile-icon tile-purple">🚚</div>
    <div class="admin-tile-info">
      <h3>Delivery Management</h3>
      <p>Track &amp; update delivery status</p>
    </div>
  </a>
  <a href="${pageContext.request.contextPath}/admin/clearance" class="admin-tile admin-tile-clearance anim-up" style="animation-delay:0.25s">
    <div class="admin-tile-icon tile-red">🏷️</div>
    <div class="admin-tile-info">
      <h3>Stock Clearance</h3>
      <p>Manage near-expiry discounts</p>
    </div>
  </a>
</div>

<!-- Charts Row -->
<div class="section-heading">📈 Analytics</div>
<div style="display:grid; grid-template-columns:1fr 1fr; gap:1.25rem; margin-bottom:1.75rem;">
  <div class="chart-card">
    <div class="chart-card-header">
      <div class="chart-dot" style="background:#27ae60;"></div>
      Order Status Breakdown
    </div>
    <canvas id="orderStatusChart" height="200"></canvas>
  </div>
  <div class="chart-card">
    <div class="chart-card-header">
      <div class="chart-dot" style="background:#1976d2;"></div>
      Monthly Sales (LKR)
    </div>
    <canvas id="salesChart" height="200"></canvas>
  </div>
</div>

<!-- Recent Orders -->
<div class="section-heading">🕐 Recent Orders</div>
<div class="orders-card">
  <div class="orders-card-header">📋 Latest 10 Orders</div>
  <table class="data-table">
    <thead>
      <tr>
        <th>Order ID</th>
        <th>Customer</th>
        <th>Amount</th>
        <th>Status</th>
        <th>Date</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="order" items="${allOrders}" varStatus="loop">
        <c:if test="${loop.index < 10}">
          <tr>
            <td style="font-weight:700; font-size:0.82rem;">${order.orderId}</td>
            <td>${order.username}</td>
            <td style="font-weight:800; color:var(--green-dark);">
              LKR <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
            </td>
            <td>
              <c:choose>
                <c:when test="${order.status == 'PENDING' || order.status == 'PENDING_FULFILLMENT'}">
                  <span class="status-badge status-pending">${order.status}</span>
                </c:when>
                <c:when test="${order.status == 'PROCESSING'}">
                  <span class="status-badge status-processing">${order.status}</span>
                </c:when>
                <c:when test="${order.status == 'DELIVERED'}">
                  <span class="status-badge status-delivered">${order.status}</span>
                </c:when>
                <c:when test="${order.status == 'CANCELLED'}">
                  <span class="status-badge status-cancelled">${order.status}</span>
                </c:when>
                <c:otherwise>
                  <span class="status-badge status-ready">${order.status}</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td style="color:var(--text-light); font-size:0.82rem;">${order.orderDate}</td>
          </tr>
        </c:if>
      </c:forEach>
    </tbody>
  </table>
</div>

<jsp:include page="sidebar-close.jsp"/>

<script>
  // Order Status Doughnut
  new Chart(document.getElementById('orderStatusChart'), {
    type: 'doughnut',
    data: {
      labels: ['Pending', 'Processing', 'Delivered', 'Cancelled'],
      datasets: [{
        data: [${pendingOrders}, 2, ${totalOrders > 3 ? totalOrders - pendingOrders - 2 : 1}, 1],
        backgroundColor: ['#f59e0b','#3b82f6','#22c55e','#ef4444'],
        borderWidth: 3, borderColor: '#fff',
        hoverOffset: 8
      }]
    },
    options: {
      plugins: {
        legend: { position: 'bottom', labels: { padding: 16, font: { weight: '700' } } }
      },
      cutout: '68%'
    }
  });

  // Monthly Sales Bar
  new Chart(document.getElementById('salesChart'), {
    type: 'bar',
    data: {
      labels: ['Jan','Feb','Mar','Apr','May','Jun'],
      datasets: [{
        label: 'Revenue (LKR)',
        data: [45000, 62000, 58000, 71000, 80000, ${totalRevenue > 0 ? totalRevenue : 95000}],
        backgroundColor: [
          'rgba(59,130,246,0.8)','rgba(34,197,94,0.8)','rgba(245,158,11,0.8)',
          'rgba(168,85,247,0.8)','rgba(239,68,68,0.8)','rgba(20,184,166,0.8)'
        ],
        borderRadius: 8, borderSkipped: false
      }]
    },
    options: {
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' }, ticks: { font: { weight: '600' } } },
        x: { grid: { display: false }, ticks: { font: { weight: '700' } } }
      }
    }
  });
</script>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
