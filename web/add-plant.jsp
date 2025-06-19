<%@page import="java.sql.*" %>
<%@page import="com.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
     <%@ include file="head.jsp" %>
</head>
<body>
       <jsp:include page="sidebar.jsp" />

    <div class="content">
        <div class="container-fluid">
            <h2>Add New Plant</h2>
            <form method="post">

                <div class="mb-3">
                    <label>Plant Number</label>
                    <input type="text" name="plant_number" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Planted Date</label>
                    <input type="date" name="planted_date" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Description</label>
                    <textarea name="description" class="form-control"></textarea>
                </div>
                <div class="mb-3">
                    <label>Latitude</label>
                    <input type="text" name="latitude" class="form-control">
                </div>
                <div class="mb-3">
                    <label>Longitude</label>
                    <input type="text" name="longitude" class="form-control">
                </div>
                <div class="mb-3">
                    <label>Altitude</label>
                    <input type="text" name="altitude" class="form-control">
                </div>
                <div class="mb-3">
                    <label>Location</label>
                    <select name="location_id" class="form-select" required>
                        <option value="">-- Select Location --</option>
                        <%
                            try {
                                Connection conn = DBConnection.getConnection();
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT id, name FROM location");
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                        <%
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.println("<option disabled>Error loading locations</option>");
                            }
                        %>
                    </select>
                </div>
                <div class="mb-3">
                    <label>Variety</label>
                    <select name="variety_id" class="form-select" required>
                        <option value="">-- Select Variety --</option>
                        <%
                            try {
                                Connection conn = DBConnection.getConnection();
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT id, name FROM plant_variety");
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                        <%
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.println("<option disabled>Error loading varieties</option>");
                            }
                        %>
                    </select>
                </div>

                <!-- Optional Initial Plant Detail -->
                <h5 class="mt-4">Plant Detail</h5>
                <div class="mb-3">
                    <label>Detail Type</label>
                    <select class="form-select" name="detail_type_id">
                        <option value="">-- Select Detail Type --</option>
                        <%
                            try {
                                Connection conn = DBConnection.getConnection();
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT id, title FROM plant_detail_type");
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("title") %></option>
                        <%
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.println("<option disabled>Error loading detail types</option>");
                            }
                        %>
                    </select>
                </div>
                <div class="mb-3">
                    <label>Value</label>
                    <input type="number" step="0.01" name="value" class="form-control">
                </div>
                <div class="mb-3">
                    <label>Unit</label>
                    <select class="form-select" name="unit_id">
                        <option value="">-- Select Unit --</option>
                        <%
                            try {
                                Connection conn = DBConnection.getConnection();
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT id, title FROM plant_detail_unit");
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("title") %></option>
                        <%
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.println("<option disabled>Error loading units</option>");
                            }
                        %>
                    </select>
                </div>
                <div class="mb-3">
                    <label>Detail Date</label>
                    <input type="datetime-local" name="detail_date" class="form-control">
                </div>
                <div class="mb-3">
                    <label>Detail Description</label>
                    <textarea name="detail_description" class="form-control"></textarea>
                </div>

                <button type="submit" class="btn btn-success">Save</button>
                <a href="plants.jsp" class="btn btn-secondary">Back</a>
            </form>

            <%
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    try {
                        Connection conn = DBConnection.getConnection();
                        conn.setAutoCommit(false);

                        // Insert plant without ID (auto-increment)
                        PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO plant (plant_number, planted_date, description, latitude, longitude, altitude, location_id, variety_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                            Statement.RETURN_GENERATED_KEYS
                        );
                        ps.setString(1, request.getParameter("plant_number"));
                        ps.setString(2, request.getParameter("planted_date"));
                        ps.setString(3, request.getParameter("description"));
                        ps.setDouble(4, Double.parseDouble(request.getParameter("latitude")));
                        ps.setDouble(5, Double.parseDouble(request.getParameter("longitude")));
                        ps.setDouble(6, Double.parseDouble(request.getParameter("altitude")));
                        ps.setInt(7, Integer.parseInt(request.getParameter("location_id")));
                        ps.setInt(8, Integer.parseInt(request.getParameter("variety_id")));
                        ps.executeUpdate();

                        ResultSet generatedKeys = ps.getGeneratedKeys();
                        int generatedPlantId = 0;
                        if (generatedKeys.next()) {
                            generatedPlantId = generatedKeys.getInt(1);
                        }

                        // Insert plant detail if provided
                        if (request.getParameter("detail_type_id") != null && !request.getParameter("detail_type_id").isEmpty()) {
                            PreparedStatement psDetail = conn.prepareStatement(
                                "INSERT INTO plant_detail (plant_id, detail_type_id, user_id, detail_date, value, unit_id, description) VALUES (?, ?, ?, ?, ?, ?, ?)"
                            );
                            psDetail.setInt(1, generatedPlantId);
                            psDetail.setInt(2, Integer.parseInt(request.getParameter("detail_type_id")));
                            psDetail.setInt(3, 1); // Hardcoded user_id for now
                            psDetail.setTimestamp(4, Timestamp.valueOf(request.getParameter("detail_date").replace("T", " ") + ":00"));
                            psDetail.setDouble(5, Double.parseDouble(request.getParameter("value")));
                            psDetail.setInt(6, Integer.parseInt(request.getParameter("unit_id")));
                            psDetail.setString(7, request.getParameter("detail_description"));
                            psDetail.executeUpdate();
                        }

                        conn.commit();
                        conn.close();
                        response.sendRedirect("plants.jsp");
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
