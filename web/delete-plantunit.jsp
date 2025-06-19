<%@ page import="java.sql.*" %>
<%@ page import="com.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String idParam = request.getParameter("id");
    if (idParam != null) {
        try {
            int id = Integer.parseInt(idParam);
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM plant_detail_unit WHERE id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();

            ps.close();
            conn.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error deleting: " + e.getMessage() + "</div>");
        }
    }

    response.sendRedirect("detail-unit.jsp");
%>
