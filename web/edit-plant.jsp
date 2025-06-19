<%@page import="java.sql.*" %>
<%@page import="com.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
    long id = Long.parseLong(request.getParameter("id"));
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null, locRs = null, varRs = null, typeRs = null, unitRs = null, detailRs = null;

    String plantNumber = "";
    Date plantedDate = null;
    String description = "";
    long selectedLocationId = 0, selectedVarietyId = 0;
    double latitude = 0, longitude = 0, altitude = 0;

    try {
        conn = DBConnection.getConnection();

        ps = conn.prepareStatement("SELECT * FROM plant WHERE id = ?");
        ps.setLong(1, id);
        rs = ps.executeQuery();

        if (rs.next()) {
            plantNumber = rs.getString("plant_number");
            plantedDate = rs.getDate("planted_date");
            description = rs.getString("description");
            selectedLocationId = rs.getLong("location_id");
            selectedVarietyId = rs.getLong("variety_id");
            latitude = rs.getDouble("latitude");
            longitude = rs.getDouble("longitude");
            altitude = rs.getDouble("altitude");
        } else {
            out.println("<h3>Plant not found!</h3>");
            return;
        }

        locRs = conn.prepareStatement("SELECT id, name FROM location").executeQuery();
        varRs = conn.prepareStatement("SELECT id, name FROM plant_variety").executeQuery();
        PreparedStatement typeStmt = conn.prepareStatement("SELECT id, title FROM plant_detail_type", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        typeRs = typeStmt.executeQuery();
        PreparedStatement unitStmt = conn.prepareStatement("SELECT id, title FROM plant_detail_unit", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        unitRs = unitStmt.executeQuery();

        PreparedStatement detailStmt = conn.prepareStatement("SELECT * FROM plant_detail WHERE plant_id = ?");
        detailStmt.setLong(1, id);
        detailRs = detailStmt.executeQuery();

    } catch(Exception e) {
        out.println("Error loading data: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.jsp" %>
</head>
<body>
<jsp:include page="sidebar.jsp" />
<div class="content container-fluid">
    <h2>Edit Plant</h2>
    <form method="post">
        <!-- Plant Info -->
        <div class="mb-3"><label>Plant Number</label>
            <input type="text" name="plant_number" class="form-control" value="<%= plantNumber %>" required>
        </div>
        <div class="mb-3"><label>Planted Date</label>
            <input type="date" name="planted_date" class="form-control" value="<%= plantedDate %>" required>
        </div>
        <div class="mb-3"><label>Description</label>
            <textarea name="description" class="form-control"><%= description %></textarea>
        </div>
        <div class="mb-3"><label>Latitude</label>
            <input type="text" name="latitude" class="form-control" value="<%= latitude %>">
        </div>
        <div class="mb-3"><label>Longitude</label>
            <input type="text" name="longitude" class="form-control" value="<%= longitude %>">
        </div>
        <div class="mb-3"><label>Altitude</label>
            <input type="text" name="altitude" class="form-control" value="<%= altitude %>">
        </div>

        <!-- Dropdowns -->
        <div class="mb-3"><label>Location</label>
            <select name="location_id" class="form-select" required>
                <option value="">-- Select Location --</option>
                <%
                    while (locRs.next()) {
                        long locId = locRs.getLong("id");
                        String selected = (locId == selectedLocationId) ? "selected" : "";
                %>
                    <option value="<%= locId %>" <%= selected %>><%= locRs.getString("name") %></option>
                <% } %>
            </select>
        </div>

        <div class="mb-3"><label>Variety</label>
            <select name="variety_id" class="form-select" required>
                <option value="">-- Select Variety --</option>
                <%
                    while (varRs.next()) {
                        long varId = varRs.getLong("id");
                        String selected = (varId == selectedVarietyId) ? "selected" : "";
                %>
                    <option value="<%= varId %>" <%= selected %>><%= varRs.getString("name") %></option>
                <% } %>
            </select>
        </div>

        <hr>
        <h4>Plant Details</h4>
        <%
            int detailIndex = 0;
            while (detailRs.next()) {
                long detailId = detailRs.getLong("id");
                int detailTypeId = detailRs.getInt("detail_type_id");
                int unitId = detailRs.getInt("unit_id");
                double value = detailRs.getDouble("value");
                Timestamp detailDate = detailRs.getTimestamp("detail_date");
                String detailDesc = detailRs.getString("description");
        %>
            <div class="border rounded p-3 mb-3">
                <input type="hidden" name="detail_id_<%= detailIndex %>" value="<%= detailId %>">

                <div class="mb-2"><label>Detail Type</label>
                    <select name="detail_type_id_<%= detailIndex %>" class="form-select">
                        <%
                            typeRs.beforeFirst();
                            while (typeRs.next()) {
                                int tId = typeRs.getInt("id");
                                String selected = (tId == detailTypeId) ? "selected" : "";
                        %>
                            <option value="<%= tId %>" <%= selected %>><%= typeRs.getString("title") %></option>
                        <% } %>
                    </select>
                </div>

                <div class="mb-2"><label>Value</label>
                    <input type="number" step="0.01" name="value_<%= detailIndex %>" class="form-control" value="<%= value %>">
                </div>

                <div class="mb-2"><label>Unit</label>
                    <select name="unit_id_<%= detailIndex %>" class="form-select">
                        <%
                            unitRs.beforeFirst();
                            while (unitRs.next()) {
                                int uId = unitRs.getInt("id");
                                String selected = (uId == unitId) ? "selected" : "";
                        %>
                            <option value="<%= uId %>" <%= selected %>><%= unitRs.getString("title") %></option>
                        <% } %>
                    </select>
                </div>

                <div class="mb-2"><label>Detail Date</label>
                    <input type="datetime-local" name="detail_date_<%= detailIndex %>" class="form-control"
                           value="<%= (detailDate != null) ? detailDate.toLocalDateTime().toString().replace(' ', 'T') : "" %>">
                </div>

                <div class="mb-2"><label>Description</label>
                    <textarea name="detail_description_<%= detailIndex %>" class="form-control"><%= detailDesc %></textarea>
                </div>

                <div class="form-check mt-2">
                    <input class="form-check-input" type="checkbox" name="delete_detail_<%= detailIndex %>" value="yes" id="deleteDetail<%= detailIndex %>">
                    <label class="form-check-label text-danger" for="deleteDetail<%= detailIndex %>">
                        Delete this detail
                    </label>
                </div>
            </div>
        <%
            detailIndex++;
            }
        %>
        <input type="hidden" name="detail_count" value="<%= detailIndex %>">

        <!-- Add New Detail -->
        <h4>Add New Detail</h4>
        <div class="border rounded p-3 mb-3">
            <div class="mb-2"><label>Detail Type</label>
                <select name="detail_type_id_new" class="form-select">
                    <%
                        typeRs.beforeFirst();
                        while (typeRs.next()) {
                    %>
                        <option value="<%= typeRs.getInt("id") %>"><%= typeRs.getString("title") %></option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="mb-2"><label>Value</label>
                <input type="number" step="0.01" name="value_new" class="form-control">
            </div>
            <div class="mb-2"><label>Unit</label>
                <select name="unit_id_new" class="form-select">
                    <%
                        unitRs.beforeFirst();
                        while (unitRs.next()) {
                    %>
                        <option value="<%= unitRs.getInt("id") %>"><%= unitRs.getString("title") %></option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="mb-2"><label>Detail Date</label>
                <input type="datetime-local" name="detail_date_new" class="form-control">
            </div>
            <div class="mb-2"><label>Description</label>
                <textarea name="detail_description_new" class="form-control"></textarea>
            </div>
        </div>

        <button type="submit" class="btn btn-success">Save</button>
        <a href="plants.jsp" class="btn btn-secondary">Cancel</a>
    </form>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            String newPlantNumber = request.getParameter("plant_number");
            String newPlantedDate = request.getParameter("planted_date");
            String newDescription = request.getParameter("description");
            long newLocationId = Long.parseLong(request.getParameter("location_id"));
            long newVarietyId = Long.parseLong(request.getParameter("variety_id"));
            double newLatitude = Double.parseDouble(request.getParameter("latitude"));
            double newLongitude = Double.parseDouble(request.getParameter("longitude"));
            double newAltitude = Double.parseDouble(request.getParameter("altitude"));

            PreparedStatement updateStmt = conn.prepareStatement(
                "UPDATE plant SET plant_number=?, planted_date=?, description=?, location_id=?, variety_id=?, latitude=?, longitude=?, altitude=? WHERE id=?"
            );
            updateStmt.setString(1, newPlantNumber);
            updateStmt.setString(2, newPlantedDate);
            updateStmt.setString(3, newDescription);
            updateStmt.setLong(4, newLocationId);
            updateStmt.setLong(5, newVarietyId);
            updateStmt.setDouble(6, newLatitude);
            updateStmt.setDouble(7, newLongitude);
            updateStmt.setDouble(8, newAltitude);
            updateStmt.setLong(9, id);
            updateStmt.executeUpdate();

            // Handle existing details
            int count = Integer.parseInt(request.getParameter("detail_count"));
            for (int i = 0; i < count; i++) {
                long dId = Long.parseLong(request.getParameter("detail_id_" + i));
                boolean toDelete = "yes".equals(request.getParameter("delete_detail_" + i));

                if (toDelete) {
                    PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM plant_detail WHERE id = ?");
                    deleteStmt.setLong(1, dId);
                    deleteStmt.executeUpdate();
                } else {
                    int dtId = Integer.parseInt(request.getParameter("detail_type_id_" + i));
                    int uid = Integer.parseInt(request.getParameter("unit_id_" + i));
                    double val = Double.parseDouble(request.getParameter("value_" + i));
                    Timestamp dDate = Timestamp.valueOf(request.getParameter("detail_date_" + i).replace("T", " ") + ":00");
                    String dDesc = request.getParameter("detail_description_" + i);

                    PreparedStatement updateDetailStmt = conn.prepareStatement(
                        "UPDATE plant_detail SET detail_type_id=?, detail_date=?, value=?, unit_id=?, description=? WHERE id=?"
                    );
                    updateDetailStmt.setInt(1, dtId);
                    updateDetailStmt.setTimestamp(2, dDate);
                    updateDetailStmt.setDouble(3, val);
                    updateDetailStmt.setInt(4, uid);
                    updateDetailStmt.setString(5, dDesc);
                    updateDetailStmt.setLong(6, dId);
                    updateDetailStmt.executeUpdate();
                }
            }

            // Handle new detail
            String newValueStr = request.getParameter("value_new");
            String newDateStr = request.getParameter("detail_date_new");

            if (newValueStr != null && !newValueStr.isEmpty() &&
                newDateStr != null && !newDateStr.isEmpty()) {

                int newTypeId = Integer.parseInt(request.getParameter("detail_type_id_new"));
                double newValue = Double.parseDouble(newValueStr);
                int newUnitId = Integer.parseInt(request.getParameter("unit_id_new"));
                Timestamp newDate = Timestamp.valueOf(newDateStr.replace("T", " ") + ":00");
                String newDesc = request.getParameter("detail_description_new");
                long userId = 1; // Hardcoded user ID

                PreparedStatement insertStmt = conn.prepareStatement(
                    "INSERT INTO plant_detail (plant_id, detail_type_id, detail_date, value, unit_id, description, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)"
                );
                insertStmt.setLong(1, id);
                insertStmt.setInt(2, newTypeId);
                insertStmt.setTimestamp(3, newDate);
                insertStmt.setDouble(4, newValue);
                insertStmt.setInt(5, newUnitId);
                insertStmt.setString(6, newDesc);
                insertStmt.setLong(7, userId);
                insertStmt.executeUpdate();
            }

            conn.close();
            response.sendRedirect("plants.jsp");

        } catch (Exception e) {
            out.println("<div class='alert alert-danger mt-3'>Error: " + e.getMessage() + "</div>");
        }
    }
%>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
