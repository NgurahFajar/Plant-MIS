<%@page import="java.sql.*"%>
<%@page import="com.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    long id = Long.parseLong(request.getParameter("id"));
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    ResultSet roleRs = null;

    String username = "";
    String email = "";
    long selectedRoleId = 0;

    try {
        conn = DBConnection.getConnection();

        // Load user
        ps = conn.prepareStatement("SELECT * FROM app_user WHERE id = ?");
        ps.setLong(1, id);
        rs = ps.executeQuery();

        if (rs.next()) {
            username = rs.getString("username");
            email = rs.getString("email");
            selectedRoleId = rs.getLong("role_id");
        } else {
            out.println("<div class='alert alert-danger'>User not found!</div>");
            return;
        }

        // Load roles
        roleRs = conn.prepareStatement("SELECT * FROM app_role").executeQuery();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error loading user: " + e.getMessage() + "</div>");
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
        <h2>Edit User</h2>
        <form method="post">
            <div class="mb-3">
                <label>Username</label>
                <input type="text" name="username" class="form-control" value="<%= username %>" required>
            </div>
            <div class="mb-3">
                <label>Email</label>
                <input type="email" name="email" class="form-control" value="<%= email %>" required>
            </div>
            <div class="mb-3">
                <label>Role</label>
                <select name="role_id" class="form-select" required>
                    <option value="">-- Select Role --</option>
                    <%
                        while (roleRs.next()) {
                            long roleId = roleRs.getLong("id");
                            String roleName = roleRs.getString("name");
                            String selected = (roleId == selectedRoleId) ? "selected" : "";
                    %>
                    <option value="<%= roleId %>" <%= selected %>><%= roleName %></option>
                    <% } %>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Update</button>
            <a href="users.jsp" class="btn btn-secondary">Cancel</a>
        </form>

        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                try {
                    String newUsername = request.getParameter("username");
                    String newEmail = request.getParameter("email");
                    long newRoleId = Long.parseLong(request.getParameter("role_id"));

                    PreparedStatement updateStmt = conn.prepareStatement(
                        "UPDATE app_user SET username=?, email=?, role_id=? WHERE id=?"
                    );
                    updateStmt.setString(1, newUsername);
                    updateStmt.setString(2, newEmail);
                    updateStmt.setLong(3, newRoleId);
                    updateStmt.setLong(4, id);

                    int updated = updateStmt.executeUpdate();
                    if (updated > 0) {
                        response.sendRedirect("users.jsp");
                    } else {
                        out.println("<div class='alert alert-danger mt-3'>Update failed.</div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger mt-3'>Error updating user: " + e.getMessage() + "</div>");
                }
            }

            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (roleRs != null) roleRs.close();
            if (conn != null) conn.close();
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
