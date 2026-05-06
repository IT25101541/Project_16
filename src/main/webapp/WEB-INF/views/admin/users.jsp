<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>User Management – FreshCart Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="👥 User Management" scope="request"/>
<jsp:include page="sidebar.jsp"/>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem; flex-wrap:wrap; gap:0.75rem;">
  <div style="font-size:0.9rem; color:var(--text-light);">${users.size()} registered users</div>
</div>

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
        <tr><td colspan="7" style="text-align:center; color:var(--text-light); padding:2rem;">No registered users.</td></tr>
      </c:if>
      <c:forEach var="u" items="${users}">
        <tr>
          <td style="font-size:0.78rem; color:var(--text-light);">${u.userId}</td>
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
                      onsubmit="return confirm('Delete user ${u.username}?')">
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
