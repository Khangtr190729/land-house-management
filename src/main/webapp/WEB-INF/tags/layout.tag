<%-- 
    Document   : layout
    Created on : Feb 6, 2026, 6:17:05 AM
    Author     : Duong Thien Nhan - CE190741
--%>
<%@tag pageEncoding="UTF-8" body-content="scriptless"%>
<%@tag import="Models.authentication.AuthResult"%>
<%@tag import="Models.entity.Tenant"%>
<%@tag import="Models.entity.Staff"%>

<%@attribute name="title" required="false" type="java.lang.String"%>
<%@attribute name="active" required="false" type="java.lang.String"%>
<%@attribute name="cssFile" required="false" type="java.lang.String"%>
<%@attribute name="jsFile" required="false" type="java.lang.String"%>

<%
    String ctx = request.getContextPath();

    AuthResult auth = (AuthResult) session.getAttribute("auth");
    Tenant tenant = (auth == null) ? null : auth.getTenant();
    Staff staff = (auth == null) ? null : auth.getStaff();

    String role;
    if (auth == null) {
        role = "GUEST";
    } else if (auth.getRole() != null && !auth.getRole().isBlank()) {
        role = auth.getRole();
    } else if (staff != null) {
        role = (staff.getStaffRole() == null || staff.getStaffRole().isBlank()) ? "STAFF" : staff.getStaffRole();
    } else if (tenant != null) {
        role = "TENANT";
    } else {
        role = "GUEST";
    }

    String tenantStatus = (tenant == null || tenant.getAccountStatus() == null) ? null : tenant.getAccountStatus();
    boolean isTenantPending = (tenant != null && "PENDING".equalsIgnoreCase(tenantStatus));
    boolean isTenantActive = (tenant != null && "ACTIVE".equalsIgnoreCase(tenantStatus));

    String displayName = "Guest";
    if (!"GUEST".equalsIgnoreCase(role)) {
        displayName = (tenant != null && tenant.getFullName() != null) ? tenant.getFullName()
                : (staff != null && staff.getFullName() != null) ? staff.getFullName()
                : "User";
    }

    String firstLetter = (displayName != null && !displayName.isBlank())
            ? displayName.trim().substring(0, 1).toUpperCase()
            : "G";

    String _title = (title == null || title.isBlank()) ? "RentHouse" : title;
    String _active = (active == null) ? "" : active;

    String pageCss = (cssFile == null || cssFile.isBlank()) ? null : cssFile;
    String pageJs = (jsFile == null || jsFile.isBlank()) ? null : jsFile;

    boolean isTenant = "TENANT".equalsIgnoreCase(role);
    boolean isManager = "MANAGER".equalsIgnoreCase(role);
    boolean isAdmin = "ADMIN".equalsIgnoreCase(role);

    String roleLabel = role;
    if (isTenant && tenantStatus != null) {
        roleLabel = "TENANT • " + tenantStatus.toUpperCase();
    }
%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%=_title%></title>

        <link rel="icon" type="image/png"
              href="${pageContext.request.contextPath}/assets/images/logo/favicon_logo.png">

        <link rel="stylesheet" href="<%=ctx%>/assets/css/base/bootstrap.min.css">
        <link rel="stylesheet" href="<%=ctx%>/assets/css/layout/layout.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <% if (pageCss != null) { %>
        <link rel="stylesheet" href="<%=pageCss%>">
        <% } %>
    </head>

    <body>
        <div class="rh-layout">

            <div class="rh-sidebar-backdrop" id="rhSidebarBackdrop"></div>

            <aside class="rh-sidebar" id="rhSidebar">
                <div class="rh-sidebar-glow glow-1"></div>
                <div class="rh-sidebar-glow glow-2"></div>
                <div class="rh-sidebar-grid"></div>

                <div class="rh-logo">
                    <a href="<%=ctx%>/home" aria-label="RentHouse Home" class="rh-spotlight">
                        <img src="<%=ctx%>/assets/images/logo/logo.png" alt="RentHouse">
                    </a>
                </div>

                <nav class="rh-menu" id="rhMenu">
                    <a class="rh-link rh-spotlight <%= "home".equals(_active) ? "active" : ""%>" href="<%=ctx%>/home">
                        <i class="bi bi-house-door me-2"></i>
                        <span>Home</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "contact".equals(_active) ? "active" : ""%>" href="<%=ctx%>/contact">
                        <i class="bi bi-envelope me-2"></i>
                        <span>Contact</span>
                    </a>

                    <% if (isTenant) { %>
                    <div class="rh-section">Tenant</div>

                    <% if (isTenantPending) { %>
                    <a class="rh-link rh-spotlight <%= "t_contract".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/tenant/contract">
                        <i class="bi bi-file-earmark-text me-2"></i>
                        <span>My Contract</span>
                    </a>
                    <% } else { %>
                    <a class="rh-link rh-spotlight <%= "t_room".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/tenant/room">
                        <i class="bi bi-door-open me-2"></i>
                        <span>My Room</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "t_contract".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/tenant/contract">
                        <i class="bi bi-file-earmark-text me-2"></i>
                        <span>My Contract</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "t_bill".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/tenant/bill">
                        <i class="bi bi-receipt me-2"></i>
                        <span>My Bills</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "t_maintenance".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/maintenance">
                        <i class="bi bi-tools me-2"></i>
                        <span>Maintenance Requests</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "t_utility".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/tenant/utility">
                        <i class="bi bi-lightning-charge me-2"></i>
                        <span>Utility</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "t_profile".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/profile">
                        <i class="bi bi-person-circle me-2"></i>
                        <span>Profile</span>
                    </a>
                    <% } %>
                    <% } %>

                    <% if (isManager) { %>
                    <div class="rh-section">Manager</div>

                    <a class="rh-link rh-spotlight <%= "m_profile".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/profile">
                        <i class="bi bi-person-badge me-2"></i>
                        <span>My Profile</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "m_rooms".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/manager/rooms">
                        <i class="bi bi-building me-2"></i>
                        <span>Manage Rooms</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "m_tenants".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/manager/tenants">
                        <i class="bi bi-people me-2"></i>
                        <span>Manage Tenants</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "m_utilities".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/manager/utilities">
                        <i class="bi bi-lightning me-2"></i>
                        <span>Manage Utilities</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "m_contracts".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/manager/contracts">
                        <i class="bi bi-file-earmark-check me-2"></i>
                        <span>Manage Contracts</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "m_billing".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/manager/billing">
                        <i class="bi bi-cash-stack me-2"></i>
                        <span>Manage Billing</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "m_maintenance".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/manager/maintenance">
                        <i class="bi bi-wrench-adjustable me-2"></i>
                        <span>Manage Maintenance</span>
                    </a>

                    <div class="rh-spacer"></div>
                    <% } %>

                    <% if (isAdmin) { %>
                    <div class="rh-section">Admin</div>

                    <a class="rh-link rh-spotlight <%= "a_home".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/home">
                        <i class="bi bi-house-door me-2"></i>
                        <span>Home</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "a_dashboard".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/admin/home">
                        <i class="bi bi-speedometer2 me-2"></i>
                        <span>Admin Dashboard</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "a_profile".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/profile">
                        <i class="bi bi-person-circle me-2"></i>
                        <span>Admin Profile</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "a_accounts".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/admin/accounts">
                        <i class="bi bi-people-fill me-2"></i>
                        <span>Manage Accounts</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "a_contracts".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/admin/contracts">
                        <i class="bi bi-file-earmark-text me-2"></i>
                        <span>View All Contracts</span>
                    </a>

                    <a class="rh-link rh-spotlight <%= "a_rooms".equals(_active) ? "active" : ""%>"
                       href="<%=ctx%>/admin/rooms">
                        <i class="bi bi-building-gear me-2"></i>
                        <span>Room Administration</span>
                    </a>

                    <div class="rh-spacer"></div>
                    <a class="rh-dashboard admin rh-spotlight" href="<%=ctx%>/admin/home">
                        <i class="bi bi-shield-lock"></i>
                        <span>Admin Dashboard</span>
                    </a>
                    <% } %>
                </nav>
            </aside>

            <main class="rh-main">

                <header class="rh-topbar rh-spotlight">
                    <div class="rh-topbar-shine"></div>

                    <div class="rh-topbar-left">
                        <button class="rh-icon-btn rh-ripple" type="button" id="rhToggleSidebar" aria-label="Toggle sidebar">
                            <i class="bi bi-list"></i>
                        </button>

                        <nav class="rh-topnav" aria-label="Main navigation">
                            <a class="rh-topnav-link rh-ripple <%= "home".equals(_active) ? "active" : ""%>"
                               href="<%=ctx%>/home">HOME</a>

                            <a class="rh-topnav-link rh-ripple <%= "about".equals(_active) ? "active" : ""%>"
                               href="<%=ctx%>/about">ABOUT US</a>

                            <a class="rh-topnav-link rh-ripple <%= "news".equals(_active) ? "active" : ""%>"
                               href="<%=ctx%>/news">NEWS</a>

                            <a class="rh-topnav-link rh-ripple <%= "recruit".equals(_active) ? "active" : ""%>"
                               href="<%=ctx%>/recruitment">RECRUITMENT</a>

                            <a class="rh-topnav-link rh-ripple <%= "contact".equals(_active) ? "active" : ""%>"
                               href="<%=ctx%>/contact">CONTACT</a>
                        </nav>
                    </div>

                    <div class="rh-topbar-right">
                        <div class="rh-user rh-spotlight">
                            <div class="rh-avatar">
                                <img src="<%=ctx%>/assets/images/avatar/avtDefault.png" alt="Avatar">
                            </div>

                            <div class="rh-user-meta">
                                <div class="rh-user-name"><%=displayName%></div>
                                <div class="rh-user-role"><%=roleLabel%></div>
                            </div>

                            <% if (auth == null) { %>
                            <a class="rh-btn primary rh-ripple" href="<%=ctx%>/login">Login</a>
                            <% } else { %>
                            <a class="rh-btn outline rh-ripple js-logout" href="<%=ctx%>/logout">Logout</a>
                            <% } %>
                        </div>
                    </div>
                </header>

                <section class="rh-content">
                    <jsp:doBody/>
                </section>

                <footer class="rh-footer">
                    <span>2026 © SWP391 - Group 4</span>
                    <span class="rh-dot">•</span>
                    <a href="https://github.com/NhanDuong21/land-house-management"
                       target="_blank" rel="noopener noreferrer">
                        RentHouse Management
                    </a>
                </footer>

            </main>
        </div>

        <!-- LOGOUT MODAL -->
        <div class="rh-modal" id="rhLogoutModal" aria-hidden="true">
            <div class="rh-modal-backdrop" data-close-modal="true"></div>
            <div class="rh-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="rhLogoutTitle">
                <button type="button" class="rh-modal-close" id="rhCloseLogoutModal" aria-label="Close">
                    <i class="bi bi-x-lg"></i>
                </button>

                <div class="rh-modal-icon">
                    <i class="bi bi-box-arrow-right"></i>
                </div>

                <h3 class="rh-modal-title" id="rhLogoutTitle">Confirm Logout</h3>
                <p class="rh-modal-text">Are you sure you want to log out of RentHouse?</p>

                <div class="rh-modal-actions">
                    <button type="button" class="rh-btn ghost rh-ripple" id="rhCancelLogout">Cancel</button>
                    <a href="<%=ctx%>/logout" class="rh-btn danger rh-ripple" id="rhConfirmLogout">Logout</a>
                </div>
            </div>
        </div>

        <script src="<%=ctx%>/assets/js/core/layout.js"></script>
        <script src="<%=ctx%>/assets/js/vendor/bootstrap.bundle.min.js"></script>

        <% if (pageJs != null) { %>
        <script src="<%=pageJs%>"></script>
        <% } %>
    </body>
</html>