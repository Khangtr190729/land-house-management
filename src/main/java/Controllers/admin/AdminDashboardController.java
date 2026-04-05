package Controllers.admin;

import java.io.IOException;
import java.util.List;

import Models.entity.Bill;
import Models.entity.Utility;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Services.admin.DashboardService;
// Nguyen Huu Lap
// Admin DashBoard
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
        final List<Bill> latestBills = service.getLatest10Bills();
        List<Utility> utilities = service.getListUtilities();

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
        request.setAttribute("latestBills", latestBills);
        request.setAttribute("utilities", utilities);

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