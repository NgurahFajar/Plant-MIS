<%@page import="java.sql.*"%>
<%@page import="com.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet roleRs = null;

    try {
        conn = DBConnection.getConnection();
        roleRs = conn.prepareStatement("SELECT * FROM app_role").executeQuery();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error loading roles: " + e.getMessage() + "</div>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.jsp" %>
</head>
<body>
<jsp:include page="sidebar.jsp" />

<div class="content">
    <div class="container-fluid">
        <h2>Add User</h2>
        <form method="post">
            <div class="mb-3">
                <label>Username</label>
                <input type="text" name="username" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Email</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Role</label>
                <select name="role_id" class="form-select" required>
                    <option value="">-- Select Role --</option>
                    <%
                        while (roleRs.next()) {
                            long roleId = roleRs.getLong("id");
                            String roleName = roleRs.getString("name");
                    %>
                    <option value="<%= roleId %>"><%= roleName %></option>
                    <% } %>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Add User</button>
            <a href="users.jsp" class="btn btn-secondary">Cancel</a>
        </form>

        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                try {
                    String username = request.getParameter("username");
                    String email = request.getParameter("email");
                    long roleId = Long.parseLong(request.getParameter("role_id"));

                    ps = conn.prepareStatement("INSERT INTO app_user (username, email, role_id) VALUES (?, ?, ?)");
                    ps.setString(1, username);
                    ps.setString(2, email);
                    ps.setLong(3, roleId);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        response.sendRedirect("users.jsp");
                    } else {
                        out.println("<div class='alert alert-danger mt-3'>Failed to add user.</div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger mt-3'>Error: " + e.getMessage() + "</div>");
                }
            }

            if (roleRs != null) roleRs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
