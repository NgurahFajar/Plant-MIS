<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>Users - Plant MIS</title>
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
            <h2 class="mb-2">User Management</h2>
        </div>
        <div class="col-12 col-md-6 text-end">
            <a href="add-user.jsp" class="btn btn-success">Add User</a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered table-striped align-middle">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DBConnection.getConnection();
                    String sql = "SELECT u.id, u.username, u.email, r.name as role_name FROM app_user u JOIN app_role r ON u.role_id = r.id";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();

                    int rowNumber = 1;
                    while (rs.next()) {
                        long userId = rs.getLong("id");
                        String username = rs.getString("username");
                        String email = rs.getString("email");
                        String role = rs.getString("role_name");
            %>
            <tr>
                <td><%= rowNumber++ %></td>
                <td><%= username %></td>
                <td><%= email %></td>
                <td><%= role %></td>
                <td>
                    <div class="d-flex flex-column align-items-center gap-2">
                        <button type="button" class="btn btn-sm"
                                style="background-color: orange; border-color: darkorange; color: white;"
                                onclick="location.href='edit-user.jsp?id=<%= userId %>'">
                            <img src="assets/edit.svg" alt="Edit" style="width:20px; height:20px;">
                        </button>

                        <button type="button" class="btn btn-danger btn-sm btn-delete" data-id="<%= userId %>">
                            <img src="assets/recyclebin.svg" alt="Delete" style="width:20px; height:20px;">
                        </button>
                    </div>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' class='text-danger'>Error loading users: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
            </tbody>
        </table>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.querySelectorAll('.btn-delete').forEach(button => {
        button.addEventListener('click', function () {
            const id = this.getAttribute('data-id');

            Swal.fire({
                title: 'Are you sure?',
                text: 'This user will be deleted permanently!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'delete-user.jsp?id=' + id;
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
