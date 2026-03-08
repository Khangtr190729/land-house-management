/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.tenant;

import java.io.IOException;
import java.util.List;

import DALs.maintenanceRequest.MaintenanceRequestDAO;
import Models.authentication.AuthResult;
import Models.dto.MaintenanceRequestDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author truon
 */
@WebServlet("/tenant/maintenance")
public class MaintenanceRequestForTenantController extends HttpServlet {

    private final MaintenanceRequestDAO dao = new MaintenanceRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthResult user = (AuthResult) request.getSession().getAttribute("auth");
        if (user == null || user.getTenant() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        if ("view".equals(action)) {
            showMaintenanceDetail(request, response, user);
            return;
        }
        int tenantId = user.getTenant().getTenantId();
        List<MaintenanceRequestDTO> list = dao.getRequestsByTenantId(tenantId);
        request.setAttribute("requests", list);
        request.setAttribute("totalRequest", list.size());
        request.getRequestDispatcher("/views/tenant/maintenanceListForTenant.jsp")
                .forward(request, response);
    }

    private void showMaintenanceDetail(HttpServletRequest request,
            HttpServletResponse response,
            AuthResult user)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            MaintenanceRequestDTO maintenance = dao.getRequestById(id);
            if (maintenance == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            if (maintenance.getTenantId() != user.getTenant().getTenantId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            request.setAttribute("maintenance", maintenance);
            request.getRequestDispatcher("/views/tenant/viewMaintenance.jsp")
                    .forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
