<%@ page import="java.sql.*" %>
<%@ page import="com.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String code = "", title = "", description = "";

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM plant_detail_type WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            code = rs.getString("code");
            title = rs.getString("title");
            description = rs.getString("description");
        }
        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error fetching data: " + e.getMessage() + "</div>");
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
        <h2>Edit Plant Detail Type</h2>
        <form method="post">
            <div class="mb-3">
                <label>Code</label>
                <input type="text" name="code" value="<%= code %>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Title</label>
                <input type="text" name="title" value="<%= title %>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Description</label>
                <textarea name="description" class="form-control" rows="4"><%= description %></textarea>
            </div>
            <button type="submit" class="btn btn-success">Update</button>
            <a href="detail-type.jsp" class="btn btn-secondary">Back</a>
        </form>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                try {
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                        "UPDATE plant_detail_type SET code=?, title=?, description=? WHERE id=?"
                    );
                    ps.setString(1, request.getParameter("code"));
                    ps.setString(2, request.getParameter("title"));
                    ps.setString(3, request.getParameter("description"));
                    ps.setInt(4, id);
                    ps.executeUpdate();

                    ps.close();
                    conn.close();

                    response.sendRedirect("detail-type.jsp");
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger mt-3'>Error updating: " + e.getMessage() + "</div>");
                }
            }
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
