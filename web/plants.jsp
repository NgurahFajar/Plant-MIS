<%@ page import="java.sql.*" %>
<%@ page import="com.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
   <%@ include file="head.jsp" %>
</head>
<body>
<div class="container-fluid">
    <div class="row flex-nowrap">
        <!-- Sidebar -->
       <jsp:include page="sidebar.jsp" />
        <!-- Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 content">
           <div class="row mb-3">
    <div class="col-12 col-md-6 d-flex align-items-center">
        <h2 class="mb-2">Plant Data</h2>
    </div>
    <div class="col-12 col-md-6 d-flex justify-content-md-end justify-content-start align-items-center">
        <a href="add-plant.jsp" class="btn btn-success mb-2">+ Add Plant</a>
    </div>
</div>
            <p class="text-muted">Live data fetched from the database.</p>

            <!-- Filter Form -->
            <form method="get" class="row g-3 mb-4">
                <%
                    Connection filterConn = null;
                    PreparedStatement locStmt = null, varStmt = null;
                    ResultSet locRs = null, varRs = null;

                    try {
                        filterConn = DBConnection.getConnection();
                        locStmt = filterConn.prepareStatement("SELECT id, name FROM location");
                        locRs = locStmt.executeQuery();
                %>
                <div class="col-12 col-md-4">
                    <select name="location_id" class="form-select">
                        <option value="">-- All Locations --</option>
                        <%
                            while (locRs.next()) {
                                String locId = locRs.getString("id");
                                String locName = locRs.getString("name");
                                String selected = locId.equals(request.getParameter("location_id")) ? "selected" : "";
                        %>
                        <option value="<%= locId %>" <%= selected %>><%= locName %></option>
                        <% } %>
                    </select>
                </div>
                <%
                        varStmt = filterConn.prepareStatement("SELECT id, name FROM plant_variety");
                        varRs = varStmt.executeQuery();
                %>
                <div class="col-12 col-md-4">
                    <select name="variety_id" class="form-select">
                        <option value="">-- All Varieties --</option>
                        <%
                            while (varRs.next()) {
                                String varId = varRs.getString("id");
                                String varName = varRs.getString("name");
                                String selected = varId.equals(request.getParameter("variety_id")) ? "selected" : "";
                        %>
                        <option value="<%= varId %>" <%= selected %>><%= varName %></option>
                        <% } %>
                    </select>
                </div>
                <%
                    } finally {
                        if (locRs != null) locRs.close();
                        if (varRs != null) varRs.close();
                        if (locStmt != null) locStmt.close();
                        if (varStmt != null) varStmt.close();
                        if (filterConn != null) filterConn.close();
                    }
                %>
                <div class="col-12 col-md-4">
                    <input type="text" name="search" class="form-control" placeholder="Search..."
                           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" />
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-outline-success w-100">Filter</button>
                </div>
            </form>
<div id="loadingSpinner" class="text-center my-4" style="display:none;">
    <div class="spinner-border text-success" role="status" style="width: 3rem; height: 3rem;">
        <span class="visually-hidden">Loading...</span>
    </div>
    <div>Loading data...</div>
</div>

          <%
                    // Show table only if filter parameters are set
                    boolean showTable = true;
                    String searchParam = request.getParameter("search");
                    String locationParam = request.getParameter("location_id");
                    String varietyParam = request.getParameter("variety_id");

                    if ((searchParam != null && !searchParam.trim().isEmpty()) ||
                        (locationParam != null && !locationParam.trim().isEmpty()) ||
                        (varietyParam != null && !varietyParam.trim().isEmpty())) {
                        showTable = true;
                    }

                    if (showTable) {
                        Connection conn = null;
                        PreparedStatement stmt = null, countStmt = null;
                        ResultSet rs = null, countRs = null;
                        int count = 1;

                        int itemsPerPage = 10;
                        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                        int offset = (currentPage - 1) * itemsPerPage;

                        try {
                            conn = DBConnection.getConnection();

                            StringBuilder sql = new StringBuilder(
                                "SELECT p.*, l.name AS location_name, v.name AS variety_name " +
                                "FROM plant p " +
                                "LEFT JOIN location l ON p.location_id = l.id " +
                                "LEFT JOIN plant_variety v ON p.variety_id = v.id WHERE 1=1"
                            );

                            StringBuilder countSql = new StringBuilder(
                                "SELECT COUNT(*) FROM plant p " +
                                "LEFT JOIN location l ON p.location_id = l.id " +
                                "LEFT JOIN plant_variety v ON p.variety_id = v.id WHERE 1=1"
                            );

                            if (searchParam != null && !searchParam.trim().isEmpty()) {
                                sql.append(" AND (p.plant_number LIKE ? OR p.description LIKE ?)");
                                countSql.append(" AND (p.plant_number LIKE ? OR p.description LIKE ?)");
                            }
                            if (locationParam != null && !locationParam.trim().isEmpty()) {
                                sql.append(" AND p.location_id = ?");
                                countSql.append(" AND p.location_id = ?");
                            }
                            if (varietyParam != null && !varietyParam.trim().isEmpty()) {
                                sql.append(" AND p.variety_id = ?");
                                countSql.append(" AND p.variety_id = ?");
                            }

                            sql.append(" LIMIT ? OFFSET ?");

                            countStmt = conn.prepareStatement(countSql.toString());
                            int countParamIndex = 1;
                            if (searchParam != null && !searchParam.trim().isEmpty()) {
                                countStmt.setString(countParamIndex++, "%" + searchParam + "%");
                                countStmt.setString(countParamIndex++, "%" + searchParam + "%");
                            }
                            if (locationParam != null && !locationParam.trim().isEmpty()) {
                                countStmt.setString(countParamIndex++, locationParam);
                            }
                            if (varietyParam != null && !varietyParam.trim().isEmpty()) {
                                countStmt.setString(countParamIndex++, varietyParam);
                            }

                            countRs = countStmt.executeQuery();
                            int totalRecords = 0;
                            if (countRs.next()) {
                                totalRecords = countRs.getInt(1);
                            }
                            int totalPages = (int) Math.ceil((double) totalRecords / itemsPerPage);

                            stmt = conn.prepareStatement(sql.toString());
                            int paramIndex = 1;
                            if (searchParam != null && !searchParam.trim().isEmpty()) {
                                stmt.setString(paramIndex++, "%" + searchParam + "%");
                                stmt.setString(paramIndex++, "%" + searchParam + "%");
                            }
                            if (locationParam != null && !locationParam.trim().isEmpty()) {
                                stmt.setString(paramIndex++, locationParam);
                            }
                            if (varietyParam != null && !varietyParam.trim().isEmpty()) {
                                stmt.setString(paramIndex++, varietyParam);
                            }
                            stmt.setInt(paramIndex++, itemsPerPage);
                            stmt.setInt(paramIndex++, offset);

                            rs = stmt.executeQuery();
                %>
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Plant Number</th>
                                <th>Planted Date</th>
                                <th>Description</th>
                                <th>Location</th>
                                <th>Variety</th>
                                <th>Latitude</th>
                                <th>Longitude</th>
                                <th>Altitude</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int rowNumber = (currentPage - 1) * itemsPerPage + 1;
                                while (rs.next()) {
                                    long id = rs.getLong("id");
                                    String plantNumber = rs.getString("plant_number");
                                    Date plantedDate = rs.getDate("planted_date");
                                    String description = rs.getString("description");
                                    String locationName = rs.getString("location_name");
                                    String varietyName = rs.getString("variety_name");
                                    double latitude = rs.getDouble("latitude");
                                    double longitude = rs.getDouble("longitude");
                                    double altitude = rs.getDouble("altitude");
                            %>
                            <tr>
                                <td><%= rowNumber++ %></td>
                                <td><%= plantNumber %></td>
                                <td><%= plantedDate %></td>
                                <td><%= description %></td>
                                <td><%= locationName != null ? locationName : "-" %></td>
                                <td><%= varietyName != null ? varietyName : "-" %></td>
                                <td><%= latitude %></td>
                                <td><%= longitude %></td>
                                <td><%= altitude %></td>
                            
                                
                                <td>    
                                 
                            <div class="d-flex flex-column align-items-center gap-2">
                                    <button type="button" class="btn btn-sm" style="background-color: orange; border-color: darkorange; color: white;"
                                    onclick="location.href='edit-plant.jsp?id=<%= id %>'">
                              <img src="assets/edit.svg" alt="Edit" style="width:20px; height:20px; margin-left:5px;">
                                              </button>

                                   <button type="button" class="btn btn-danger btn-sm btn-delete" data-id="<%= id %>">
                                        <img src="assets/recyclebin.svg" alt="Delete" style="width:20px; height:20px; margin-right:0px;">
                                      </button>
                       
                            </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <nav>
                    <ul class="pagination justify-content-center">
                        <% for (int i = 1; i <= totalPages; i++) {
                            String activeClass = (i == currentPage) ? "active" : "";
                        %>
                        <li class="page-item <%= activeClass %>">
                            <a class="page-link" href="?search=<%= searchParam != null ? searchParam : "" %>&location_id=<%= locationParam != null ? locationParam : "" %>&variety_id=<%= varietyParam != null ? varietyParam : "" %>&page=<%= i %>"><%= i %></a>
                        </li>
                        <% } %>
                    </ul>
                </nav>
                <%
                        } catch (Exception e) {
                            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
                            try { if (countRs != null) countRs.close(); } catch (Exception ignored) {}
                            try { if (countStmt != null) countStmt.close(); } catch (Exception ignored) {}
                            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
                        }
                    } else {
                %>
                <p class="text-center text-muted">Please use the filter above and click "Filter" to view plant data.</p>
                <%
                    }
                %>
            </div>
        </div>
    </div>


<!-- Overlay -->
<div id="overlay" class="content-overlay"></div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


<script>
  document.querySelectorAll('.btn-delete').forEach(button => {
    button.addEventListener('click', function () {
      const plantId = this.getAttribute('data-id');

      Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#198754',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!'
      }).then((result) => {
        if (result.isConfirmed) {
          window.location.href = 'delete-plant.jsp?id=' + plantId;
        }
      });
    });
  });
</script>
<script>
    const filterForm = document.querySelector('form');
    const loadingSpinner = document.getElementById('loadingSpinner');

    filterForm.addEventListener('submit', () => {
        loadingSpinner.style.display = 'block'; // show spinner
    });
</script>

</body>

</html>
