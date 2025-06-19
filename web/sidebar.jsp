<link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css"/>
<script src="assets/bootstrap/js/bootstrap.bundle.min.js"></script>


<nav id="sidebar" class="sidebar d-none d-md-block">
  <div class="sidebar-header sticky-top bg-success text-white py-3 border-bottom border-light d-flex align-items-center justify-content-center flex-row px-3">
    <img src="assets/plantlogo.svg" alt="Logo" style="height: 30px;">
    <h4 class="mb-0">Plant MIS</h4>
</div>

    <a href="dashboard-plant.jsp">Home</a>
    <a href="masterdata-plant.jsp">MasterData</a>
  <div>
  <a id="desktopSystemToggle" class="d-flex align-items-center justify-content-between text-white px-3 py-2"
     href="#" role="button">
      <span><i class="fas fa-cogs me-2"></i>System</span>
      <i id="desktopChevron" class="fas fa-chevron-down"></i>
  </a>
  <div id="desktopSystemMenu" class="collapse">
      <a href="system.jsp" class="text-white px-4 py-2 d-block text-decoration-none">System Page</a>
      <a href="#" onclick="confirmLogout()" class="text-white px-4 py-2 d-block text-decoration-none" style="background-color: #dc3545;">
          <i class="fas fa-sign-out-alt me-2"></i>Logout</a>
  </div>
</div>

    
</nav>

<!-- Mobile Top Bar (with logo and menu icon) -->
<div class="mobile-topbar d-md-none bg-success text-white py-3 border-bottom border-light d-flex justify-content-between align-items-center px-3 fixed-top">
    <div class="d-flex align-items-center">
        <img src="assets/plantlogo.svg" alt="Logo" style="height: 30px; margin-right: 10px;">
        <h4 class="mb-0">Plant MIS</h4>
    </div>
    <button id="sidebarToggle" class="btn text-white">
        <i id="toggleIcon" class="fas fa-bars"></i>
    </button>
</div>


<div id="mobileSidebar" class="mobile-sidebar d-md-none">
    <a href="dashboard-plant.jsp">Dashboard</a>
    <a href="masterdata-plant.jsp">MasterData</a>
 <a id="mobileSystemToggle" class="d-flex align-items-center justify-content-between text-white px-3 py-2"
   href="#" role="button">
    <span><i class="fas fa-cogs me-2"></i>System</span>
    <i id="mobileChevron" class="fas fa-chevron-down"></i>
</a>
<div id="mobileSystemMenu" class="collapse">
    <a href="system.jsp" class="text-white px-4 py-2 d-block text-decoration-none">System Page</a>
    <a href="#" onclick="confirmLogout()" class="text-white px-4 py-2 d-block text-decoration-none" style="background-color: #dc3545;">
        <i class="fas fa-sign-out-alt me-2"></i>Logout
    </a>
</div>




</div>

<div id="overlay" class="overlay d-md-none"></div>

<style>
  .content {
    padding: 20px;
  }

  @media (max-width: 767.98px) {
    .content {
      padding-top: 70px; /* only applies on mobile */
    }
  }
    .sidebar {
        background-color: #198754;
        color: white;
        min-height: 100vh;
        width: 250px;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 100;
        overflow-y: auto;
    }

    .sidebar a {
        color: white;
        text-decoration: none;
        padding: 12px 16px;
        display: block;
    }

    .sidebar a:hover {
        background-color: #157347;
    }

    /* Mobile top bar stays at top */
.mobile-topbar {
    height: 56px;
    z-index: 1060; /* Ensure it's above everything */
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 16px;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
}


/* Slide-in sidebar from left */
.mobile-sidebar {
    position: fixed;
    top: 0;
    left: -250px;
    width: 180px;
    height: 100%;
    background-color: #198754;
    color: white;
    z-index: 1050;
    padding-top: 56px; /* space for topbar */
    transition: left 0.3s ease;
}

.mobile-sidebar a {
    color: white;
    text-decoration: none;
    padding: 12px 16px;
    display: block;
}

.mobile-sidebar a:hover {
    background-color: #157347;
}

/* Show when toggled */
.mobile-sidebar.show {
    left: 0;
}

/* Overlay background */
.overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1040;
    display: none;
}

.overlay.show {
    display: block;
}
</style>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const toggleBtn = document.getElementById("sidebarToggle");
        const sidebar = document.getElementById("mobileSidebar");
        const overlay = document.getElementById("overlay");

        if (!toggleBtn || !sidebar || !overlay) {
            console.warn("Sidebar toggle elements not found.");
            return;
        }

        toggleBtn.addEventListener("click", () => {
            sidebar.classList.toggle("show");
            overlay.classList.toggle("show");

            const icon = document.getElementById("toggleIcon");
            if (icon) {
                icon.classList.toggle("fa-bars");
                icon.classList.toggle("fa-times");
            }
        });

        overlay.addEventListener("click", () => {
            sidebar.classList.remove("show");
            overlay.classList.remove("show");

            const icon = document.getElementById("toggleIcon");
            if (icon) {
                icon.classList.add("fa-bars");
                icon.classList.remove("fa-times");
            }
        });
    });
</script>
<script src="assets/sweetalert2/package/dist/sweetalert2.all.min.js"></script>
<script>
function confirmLogout() {
    Swal.fire({
        title: 'Are you sure?',
        text: 'You will be logged out of the system.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Yes, logout',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = 'logout.jsp';
        }
    });
}
</script>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const toggleBtn = document.getElementById("mobileSystemToggle");
    const collapseTarget = document.getElementById("mobileSystemMenu");
    const chevron = document.getElementById("mobileChevron");

    toggleBtn.addEventListener("click", function (e) {
        e.preventDefault();
        const bsCollapse = bootstrap.Collapse.getOrCreateInstance(collapseTarget);
        bsCollapse.toggle();

        // Toggle chevron direction
        chevron.classList.toggle("fa-chevron-down");
        chevron.classList.toggle("fa-chevron-up");
    });

    // Optional: reset chevron on collapse end
    collapseTarget.addEventListener('hidden.bs.collapse', function () {
        chevron.classList.add("fa-chevron-down");
        chevron.classList.remove("fa-chevron-up");
    });

    collapseTarget.addEventListener('shown.bs.collapse', function () {
        chevron.classList.remove("fa-chevron-down");
        chevron.classList.add("fa-chevron-up");
    });
});
</script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const desktopToggleBtn = document.getElementById("desktopSystemToggle");
    const desktopCollapseTarget = document.getElementById("desktopSystemMenu");
    const desktopChevron = document.getElementById("desktopChevron");

    desktopToggleBtn.addEventListener("click", function (e) {
        e.preventDefault();
        const bsCollapse = bootstrap.Collapse.getOrCreateInstance(desktopCollapseTarget);
        bsCollapse.toggle();

        desktopChevron.classList.toggle("fa-chevron-down");
        desktopChevron.classList.toggle("fa-chevron-up");
    });

    desktopCollapseTarget.addEventListener('hidden.bs.collapse', function () {
        desktopChevron.classList.add("fa-chevron-down");
        desktopChevron.classList.remove("fa-chevron-up");
    });

    desktopCollapseTarget.addEventListener('shown.bs.collapse', function () {
        desktopChevron.classList.remove("fa-chevron-down");
        desktopChevron.classList.add("fa-chevron-up");
    });
});
</script>


