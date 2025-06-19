<%@ page import="java.sql.*" %>
<%@ page import="com.DBConnection" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement("DELETE FROM plant_detail_type WHERE id = ?");
        ps.setInt(1, id);
        ps.executeUpdate();
        conn.close();
    } catch (Exception e) {
        out.println("<script>alert('Delete failed: " + e.getMessage() + "');</script>");
    }
    response.sendRedirect("detail-type.jsp");
%>
