<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Plant MIS</title>
<link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css"/>
<script src="assets/bootstrap/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="assets/fontawesome/css/all.min.css" />
<link rel="stylesheet" href="assets/sweetalert2/package/dist/sweetalert2.min.css">
 <script src="assets/sweetalert2/package/dist/sweetalert2.all.min.js"></script> 
<style>
    body {
        min-height: 100vh;
        margin: 0;
        padding: 0;
    }

    .content {
        padding: 20px;
    }

    @media (min-width: 768px) {
        .content {
            margin-left: 250px;
        }
    }

    .table thead {
        background-color: #198754;
        color: white;
    }

    .card:hover {
        box-shadow: 0 0 10px rgba(0,0,0,0.2);
        transform: scale(1.02);
        transition: all 0.3s;
    }

    .no-data-message {
        display: flex;
        justify-content: center;
        align-items: center;
        color: #6c757d;
        font-style: italic;
        font-size: 1.2rem;
        min-height: 200px;
    }
</style>
<script src="assets/sweetalert2/package/dist/sweetalert2.all.min.js"></script>
