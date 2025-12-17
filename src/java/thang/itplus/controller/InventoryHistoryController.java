package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import thang.itplus.dao.InventoryDao;
import thang.itplus.models.InventoryTransaction;
import thang.itplus.models.User;
import thang.itplus.models.User.Role;


@WebServlet(name = "InventoryHistoryController", urlPatterns = {"/lichsukho"})
public class InventoryHistoryController extends HttpServlet {
    
    private final InventoryDao inventoryDao = new InventoryDao(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Bảo vệ: Chỉ cho phép Employee và Admin truy cập
        if (currentUser == null || (currentUser.getRole() != Role.EMPLOYEE && currentUser.getRole() != Role.admin)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Truy cập bị từ chối.");
            return;
        }

        // QLK_08: Lấy tham số lọc theo ngày
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        try {
            // Lấy lịch sử giao dịch (có lọc)
            List<InventoryTransaction> historyList = inventoryDao.getHistory(startDate, endDate);
            
            request.setAttribute("historyList", historyList);

            // ⭐ Sử dụng Layout
            request.setAttribute("pageTitle", "Lịch Sử Nhập/Xuất Kho");
            request.setAttribute("contentPage", "inventory_history.jsp");

            // Chuyển tiếp đến trang LAYOUT
            request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi CSDL khi tải lịch sử kho.");
            // ⭐ Sửa: Chuyển hướng về Profile mặc định
            response.sendRedirect(request.getContextPath() + "/employee/profile");
        }
    }
}