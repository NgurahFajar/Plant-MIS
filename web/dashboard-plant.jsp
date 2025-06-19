<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="head.jsp" %>
    <title>Dashboard - Plant MIS</title>
</head>
<body>
    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Main Content -->
    <div class="content">
        <h2>Welcome to the Dashboard</h2>
        <p class="text-muted">Here's a quick overview of your system.</p>

        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mt-3">
            <div class="col">
                <div class="card border-success">
                    <div class="card-body">
                        <h5 class="card-title">Total Plants</h5>
                        <p class="card-text">123</p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card border-success">
                    <div class="card-body">
                        <h5 class="card-title">Locations Tracked</h5>
                        <p class="card-text">5 Regions</p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card border-success">
                    <div class="card-body">
                        <h5 class="card-title">Users</h5>
                        <p class="card-text">10 Active Users</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
