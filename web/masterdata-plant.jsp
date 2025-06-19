<%-- 
    Document   : plant
    Created on : 4 Jun 2025, 16.18.25
    Author     : jjbb3
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.jsp" %>
<!--    <style>
          body {
            min-height: 100vh;
        }

        .content {
            padding: 20px;
        }

        @media (min-width: 768px) {
            .content {
                margin-left: 250px; 
            }
        }

        .card:hover {
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            transform: scale(1.02);
            transition: all 0.3s;
        }
    </style>-->
</head>
<body>
    <!-- Sidebar -->
   <jsp:include page="sidebar.jsp" />

    <!-- Main Content -->
    <div class="content">
        <h2>Master Data</h2>
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mt-3">
            <div class="col">
                <a href="plants.jsp" class="text-decoration-none text-dark">
                    <div class="card h-100 border-success">
                        <div class="card-body">
                            <h5 class="card-title">Plants</h5>
                            <p class="card-text">Manage plant data here.</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="locations.jsp" class="text-decoration-none text-dark">
                    <div class="card h-100 border-success">
                        <div class="card-body">
                            <h5 class="card-title">Locations</h5>
                            <p class="card-text">Manage location data here.</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="varietas.jsp" class="text-decoration-none text-dark">
                    <div class="card h-100 border-success">
                        <div class="card-body">
                            <h5 class="card-title">Varietas</h5>
                            <p class="card-text">Manage variety data here.</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="detail-type.jsp" class="text-decoration-none text-dark">
                    <div class="card h-100 border-success">
                        <div class="card-body">
                            <h5 class="card-title">Detail Type</h5>
                            <p class="card-text">Detailed records of plants.</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="detail-unit.jsp" class="text-decoration-none text-dark">
                    <div class="card h-100 border-success">
                        <div class="card-body">
                            <h5 class="card-title">Detail Unit</h5>
                            <p class="card-text">Detailed records of plants.</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="users.jsp" class="text-decoration-none text-dark">
                    <div class="card h-100 border-success">
                        <div class="card-body">
                            <h5 class="card-title">Users</h5>
                            <p class="card-text">User management panel.</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
