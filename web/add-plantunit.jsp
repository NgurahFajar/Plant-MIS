<%@ page import="java.sql.*" %>
<%@ page import="com.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.jsp" %>
</head>
<body>
    <jsp:include page="sidebar.jsp" />

    <div class="content">
        <div class="container-fluid">
            <h2>Add New Plant Detail Unit</h2>
            <form method="post">
                <div class="mb-3">
                    <label>Code</label>
                    <input type="text" name="code" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Title</label>
                    <input type="text" name="title" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Description</label>
                    <textarea name="description" class="form-control" rows="4"></textarea>
                </div>
                <button type="submit" class="btn btn-success">Save</button>
                <a href="detail-unit.jsp" class="btn btn-secondary">Back</a>
            </form>

            <%
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    try {
                        Connection conn = DBConnection.getConnection();
                        PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO plant_detail_unit (code, title, description) VALUES (?, ?, ?)"
                        );
                        ps.setString(1, request.getParameter("code"));
                        ps.setString(2, request.getParameter("title"));
                        ps.setString(3, request.getParameter("description"));
                        ps.executeUpdate();
                        response.sendRedirect("detail-unit.jsp");
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger mt-3'>Error: " + e.getMessage() + "</div>");
                    }
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
