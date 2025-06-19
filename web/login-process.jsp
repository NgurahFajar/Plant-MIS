<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<%@ page import="java.sql.*, com.DBConnection, javax.servlet.http.HttpSession" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT * FROM app_user WHERE username = ? AND password = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password); // Note: Use password hashing in production!
        rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("user_id", rs.getInt("id"));
            session.setAttribute("username", rs.getString("username"));
            session.setAttribute("role_id", rs.getInt("role_id"));
            response.sendRedirect("dashboard-plant.jsp");
        } else {
            response.sendRedirect("login.jsp?error=invalid");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=exception");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
