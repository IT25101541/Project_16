<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>User Management – FreshCart Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    .search-bar {
      display: flex; gap: 0.75rem; align-items: center;
      background: white; border-radius: var(--radius-sm);
      padding: 0.5rem 0.75rem;
      border: 2px solid var(--border);
      box-shadow: var(--shadow-sm);
      max-width: 420px;
      transition: border-color 0.2s;
    }
    .search-bar:focus-within { border-color: var(--green-mid); }
    .search-bar input {
      border: none; background: transparent; flex: 1;
      font-family: 'Nunito', sans-serif; font-size: 0.92rem;
      font-weight: 600; color: var(--text-dark);
      outline: none;
    }
    .search-bar button {
      background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
      border: none; color: white; padding: 0.38rem 0.9rem;
      border-radius: 8px; font-weight: 700; font-size: 0.85rem;
      cursor: pointer; font-family: 'Nunito', sans-serif;
      transition: all 0.2s;
    }
    .search-bar button:hover { opacity: 0.9; }
    .search-result-info {
      background: var(--green-pale); color: var(--green-dark);
      border-radius: 8px; padding: 0.5rem 1rem;
      font-size: 0.85rem; font-weight: 700;
      display: flex; align-items: center; gap: 0.5rem;
    }
  </style>
</head>
<body>
<c:set var="pageTitle" value="👥 User Management" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<%-- Top bar: count + search --%>
<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem; flex-wrap:wrap; gap:0.75rem;">
  <div>
    <div style="font-size:0.9rem; color:var(--text-light);">
      ${users.size()} user${users.size() != 1 ? 's' : ''}
      <c:if test="${not empty searchQuery}"> found for "<strong>${searchQuery}</strong>"</c:if>
    </div>
  </div>

  <%-- Search form --%>
  <form method="get" action="${pageContext.request.contextPath}/admin/users" style="display:flex; gap:0.5rem; align-items:center;">
    <div class="search-bar">
      <span style="color:var(--text-light); font-size:1rem;">🔍</span>
      <input type="text" name="search" value="${searchQuery}"
             placeholder="Search by name, email or phone..." autocomplete="off">
      <button type="submit">Search</button>
    </div>
    <c:if test="${not empty searchQuery}">
      <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary btn-sm">✕ Clear</a>
    </c:if>
  </form>
</div>

<%-- Search result banner --%>
<c:if test="${not empty searchQuery}">
  <div class="search-result-info" style="margin-bottom:1rem;">
    🔍 Showing results for: <strong>"${searchQuery}"</strong> — ${users.size()} match${users.size() != 1 ? 'es' : ''}
  </div>
</c:if>

<div class="card" style="padding:0; overflow:hidden;">
  <table class="data-table">
    <thead>
      <tr>
        <th>User ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Role</th>
        <th>Status</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <c:if test="${empty users}">
        <tr>
          <td colspan="7" style="text-align:center; color:var(--text-light); padding:3rem;">
            <div style="font-size:2rem; margin-bottom:0.5rem;">🔍</div>
            <c:choose>
              <c:when test="${not empty searchQuery}">No users found matching "<strong>${searchQuery}</strong>"</c:when>
              <c:otherwise>No registered users yet.</c:otherwise>
            </c:choose>
          </td>
        </tr>
      </c:if>
      <c:forEach var="u" items="${users}">
        <tr>
          <td style="font-size:0.75rem; color:var(--text-light);">${u.userId}</td>
          <td style="font-weight:700;">${u.username}</td>
          <td>${u.email}</td>
          <td>${u.phone}</td>
          <td><span class="status-badge ${u.role == 'ADMIN' ? 'status-processing' : 'status-active'}">${u.role}</span></td>
          <td>
            <c:choose>
              <c:when test="${u.blocked}"><span class="status-badge status-blocked">BLOCKED</span></c:when>
              <c:otherwise><span class="status-badge status-active">ACTIVE</span></c:otherwise>
            </c:choose>
          </td>
          <td>
            <div style="display:flex; gap:0.4rem; flex-wrap:wrap;">
              <c:if test="${u.role != 'ADMIN'}">
                <c:choose>
                  <c:when test="${u.blocked}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/unblock-user" style="display:inline;">
                      <input type="hidden" name="userId" value="${u.userId}">
                      <button class="btn btn-info btn-sm">✅ Unblock</button>
                    </form>
                  </c:when>
                  <c:otherwise>
                    <form method="post" action="${pageContext.request.contextPath}/admin/block-user" style="display:inline;">
                      <input type="hidden" name="userId" value="${u.userId}">
                      <button class="btn btn-warning btn-sm">🚫 Block</button>
                    </form>
                  </c:otherwise>
                </c:choose>
                <form method="post" action="${pageContext.request.contextPath}/admin/delete-user" style="display:inline;"
                      onsubmit="return confirm('Permanently delete user ${u.username}?')">
                  <input type="hidden" name="userId" value="${u.userId}">
                  <button class="btn btn-danger btn-sm">🗑️ Delete</button>
                </form>
              </c:if>
            </div>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<jsp:include page="sidebar-close.jsp"/>
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
