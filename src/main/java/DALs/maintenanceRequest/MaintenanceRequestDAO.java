/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DALs.maintenanceRequest;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import Models.dto.MaintenanceRequestDTO;
import Utils.database.DBContext;

/**
 *
 * @author Truong Hoang Khang - CE190729
 */
public class MaintenanceRequestDAO extends DBContext {

    public List<MaintenanceRequestDTO> getAllRequests() {
        List<MaintenanceRequestDTO> list = new ArrayList<>();
        String sql = "SELECT "
                + "mr.request_id, "
                + "r.room_number, "
                + "t.full_name, "
                + "mr.issue_category, "
                + "mr.status, "
                + "mr.description "
                + "FROM MAINTENANCE_REQUEST mr "
                + "JOIN ROOM r ON mr.room_id = r.room_id "
                + "JOIN TENANT t ON mr.tenant_id = t.tenant_id "
                + "ORDER BY mr.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MaintenanceRequestDTO dto = new MaintenanceRequestDTO();
                dto.setRequestId(rs.getInt("request_id"));
                dto.setRoomNumber(rs.getString("room_number"));
                dto.setFullName(rs.getString("full_name"));
                dto.setIssueCategory(rs.getString("issue_category"));
                dto.setStatus(rs.getString("status"));
                dto.setDescription(rs.getString("description"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public MaintenanceRequestDTO getRequestById(int id) {
        String sql = "SELECT "
                + "mr.request_id, "
                + "r.room_number, "
                + "t.full_name, "
                + "mr.issue_category, "
                + "mr.status, "
                + "mr.description, "
                + "mr.image_url, "
                + "mr.created_at, "
                + "mr.completed_at "
                + "FROM MAINTENANCE_REQUEST mr "
                + "JOIN ROOM r ON mr.room_id = r.room_id "
                + "JOIN TENANT t ON mr.tenant_id = t.tenant_id "
                + "WHERE mr.request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            ps.setInt(1, id);
            if (rs.next()) {
                MaintenanceRequestDTO dto = new MaintenanceRequestDTO();
                dto.setRequestId(rs.getInt("request_id"));
                dto.setRoomNumber(rs.getString("room_number"));
                dto.setFullName(rs.getString("full_name"));
                dto.setIssueCategory(rs.getString("issue_category"));
                dto.setStatus(rs.getString("status"));
                dto.setDescription(rs.getString("description"));
                dto.setImageUrl(rs.getString("image_url"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setCompletedAt(rs.getTimestamp("completed_at"));
                return dto;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public int countRequest() {
        String sql = "SELECT COUNT(*) FROM MAINTENANCE_REQUEST";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
