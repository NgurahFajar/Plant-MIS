<%@ page import="java.sql.*" %>
<%@ page import="com.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect("detail-unit.jsp");
        return;
    }

    int id = Integer.parseInt(idParam);
    String code = "";
    String title = "";
    String description = "";

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM plant_detail_unit WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            code = rs.getString("code");
            title = rs.getString("title");
            description = rs.getString("description");
        } else {
            response.sendRedirect("detail-unit.jsp");
            return;
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
        <h2>Edit Plant Detail Unit</h2>
        <form method="post">
            <div class="mb-3">
                <label>Code</label>
                <input type="text" name="code" class="form-control" value="<%= code %>" required>
            </div>
            <div class="mb-3">
                <label>Title</label>
                <input type="text" name="title" class="form-control" value="<%= title %>" required>
            </div>
            <div class="mb-3">
                <label>Description</label>
                <textarea name="description" class="form-control" rows="4"><%= description %></textarea>
            </div>
            <button type="submit" class="btn btn-success">Update</button>
            <a href="detail-unit.jsp" class="btn btn-secondary">Back</a>
        </form>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                try {
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                        "UPDATE plant_detail_unit SET code = ?, title = ?, description = ? WHERE id = ?"
                    );
                    ps.setString(1, request.getParameter("code"));
                    ps.setString(2, request.getParameter("title"));
                    ps.setString(3, request.getParameter("description"));
                    ps.setInt(4, id);
                    ps.executeUpdate();
                    response.sendRedirect("detail-unit.jsp");
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
