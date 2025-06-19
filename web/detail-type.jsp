<%@ page import="java.sql.*" %>
<%@ page import="com.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.jsp" %>
</head>
<body>
<%@ include file="sidebar.jsp" %>

<div id="loader" class="d-flex justify-content-center align-items-center"
     style="position: fixed; width: 100%; height: 100%; background-color: white; z-index: 9999;">
    <div class="spinner-border text-success" role="status" style="width: 4rem; height: 4rem;">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 content">
    <div class="row mb-3">
        <div class="col-12 col-md-6 d-flex align-items-center">
            <h2 class="mb-2">Plant Detail Type</h2>
        </div>
        <div class="col-12 col-md-6 text-end">
            <a href="add-planttype.jsp" class="btn btn-success">Add New Type</a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered table-striped align-middle">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Code</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                int currentPage = 1;
                int recordsPerPage = 5;

                if (request.getParameter("page") != null) {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                }

                int start = (currentPage - 1) * recordsPerPage;

                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    conn = DBConnection.getConnection();

                    ps = conn.prepareStatement("SELECT * FROM plant_detail_type LIMIT ?, ?");
                    ps.setInt(1, start);
                    ps.setInt(2, recordsPerPage);
                    rs = ps.executeQuery();

                    int rowNumber = start + 1;
                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rowNumber++ %></td>
                    <td><%= rs.getString("code") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("description") %></td>
                    <td>
                        <div class="d-flex flex-column align-items-center gap-2">
                            <button type="button" class="btn btn-sm"
                                style="background-color: orange; border-color: darkorange; color: white;"
                                onclick="location.href='edit-planttype.jsp?id=<%= rs.getInt("id") %>'">
                                <img src="assets/edit.svg" alt="Edit" style="width:20px; height:20px;">
                            </button>

                            <button type="button" class="btn btn-danger btn-sm btn-delete" data-id="<%= rs.getInt("id") %>">
                                <img src="assets/recyclebin.svg" alt="Delete" style="width:20px; height:20px;">
                            </button>
                        </div>
                    </td>
                </tr>
            <%
                    }
                    rs.close();
                    ps.close();

                    ps = conn.prepareStatement("SELECT COUNT(*) FROM plant_detail_type");
                    rs = ps.executeQuery();
                    int totalRecords = 0;
                    if (rs.next()) {
                        totalRecords = rs.getInt(1);
                    }
                    int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
            %>
            </tbody>
        </table>
    </div>

    <nav>
        <ul class="pagination justify-content-center">
            <%
                for (int i = 1; i <= totalPages; i++) {
            %>
                <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                    <a class="page-link" href="detail-type.jsp?page=<%= i %>"><%= i %></a>
                </li>
            <%
                }
            %>
        </ul>
    </nav>

    <%
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            out.println("<tr><td colspan='5' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
        }
    %>
</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.querySelectorAll('.btn-delete').forEach(button => {
        button.addEventListener('click', function () {
            const id = this.getAttribute('data-id');

            Swal.fire({
                title: 'Are you sure?',
                text: 'This record will be deleted permanently!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'delete-planttype.jsp?id=' + id;
                }
            });
        });
    });

    window.addEventListener('load', function () {
        const loader = document.getElementById('loader');
        loader.style.transition = 'opacity 0.5s ease';
        loader.style.opacity = '0';
        setTimeout(() => {
            loader.style.display = 'none';
            loader.style.pointerEvents = 'none';
        }, 500);
    });
</script>
</body>
</html>
