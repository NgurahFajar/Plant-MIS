<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.jsp" %>
    <title>Login - Plant MIS</title>
</head>
<body>

<div id="loader" class="d-flex justify-content-center align-items-center"
     style="position: fixed; width: 100%; height: 100%; background-color: white; z-index: 9999;">
    <div class="spinner-border text-success" role="status" style="width: 4rem; height: 4rem;">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<div class="container d-flex justify-content-center align-items-center vh-100">
    <div class="card p-4 shadow-lg" style="min-width: 300px; max-width: 400px; width: 100%;">
        <h4 class="mb-3 text-center">Plant MIS Login</h4>

        <% String error = request.getParameter("error"); %>
        <div id="errorAlert" class="alert alert-danger alert-dismissible fade<%= (error != null && error.equals("invalid")) ? " show" : "" %>" role="alert" style="<%= (error == null) ? "display:none;" : "" %>">
            <strong>Invalid login!</strong> Please check your username and password.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>

        <form action="login-process.jsp" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" name="username" class="form-control" required />
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" name="password" class="form-control" required />
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-success">Login</button>
            </div>
        </form>
    </div>
</div>

<script>
    window.addEventListener('load', function () {
        const loader = document.getElementById('loader');
        loader.style.transition = 'opacity 0.5s ease';
        loader.style.opacity = '0';
        setTimeout(() => {
            loader.style.display = 'none';
            loader.style.pointerEvents = 'none';
        }, 500);
    });

    const alertEl = document.getElementById('errorAlert');
    if (alertEl && alertEl.classList.contains('show')) {
        setTimeout(() => {
            alertEl.classList.remove('show');
            alertEl.classList.add('fade');
            alertEl.style.opacity = '0';
            setTimeout(() => alertEl.style.display = 'none', 300); // remove after fade-out
        }, 4000);
    }
</script>

</body>
</html>
