package Controllers.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Services.admin.DashboardService;

public class AdminDashboardController extends HttpServlet {

    private final DashboardService service = new DashboardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalTenants = service.getTotalTenants();
        int availableRooms = service.getAvailableRooms();
        int maintenanceRequests = service.getMaintenanceRequests();
        int occupiedRooms = service.getOccupiedRooms();
        int activeContracts = service.getActiveContracts();

        String range = request.getParameter("range");
        double revenue;

        if ("3months".equals(range)) {
            revenue = service.getRevenueLast3Months();
        } else if ("6months".equals(range)) {
            revenue = service.getRevenueLast6Months();
        } else if ("1year".equals(range)) {
            revenue = service.getRevenueLast1Year();
        } else {
            range = "month";
            revenue = service.getMonthlyRevenue();
        }

        request.setAttribute("totalTenants", totalTenants);
        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("maintenanceRequests", maintenanceRequests);
        request.setAttribute("occupiedRooms", occupiedRooms);
        request.setAttribute("activeContracts", activeContracts);
        request.setAttribute("revenue", revenue);
        request.setAttribute("range", range);

        request.getRequestDispatcher("/views/admin/dashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    public String getServletInfo() {
        return "Admin Dashboard Controller";
    }
}