<%@page import="java.sql.*" %>
<%@page import="com.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
    long id = Long.parseLong(request.getParameter("id"));
    out.println("Deleting plant with ID: " + id); // Tambahkan untuk debug
    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement("DELETE FROM plant WHERE id = ?");
        ps.setLong(1, id);
        ps.executeUpdate();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    }
    response.sendRedirect("plants.jsp");
%>
