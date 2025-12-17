package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import thang.itplus.dao.OrderDao;
import thang.itplus.models.Order;
import thang.itplus.models.User;
import thang.itplus.models.User.Role;

@WebServlet(name = "UpdateOrderStatusController", urlPatterns = {"/employee/update-status"})
public class UpdateOrderStatusController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // 1. Kiểm tra phân quyền (chỉ Employee hoặc Admin mới được truy cập)
        if (currentUser == null || (currentUser.getRole() != Role.EMPLOYEE && currentUser.getRole() != Role.admin)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện chức năng này.");
            return;
        }
        
        // 2. Lấy tham số
        String orderIdStr = request.getParameter("orderId");
        String statusStr = request.getParameter("newStatus");

        if (orderIdStr == null || statusStr == null) {
            session.setAttribute("errorMessage", "Tham số không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/employee/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order.Status newStatus = null;
            
            // Tìm kiếm ENUM Status phù hợp với giá trị gửi lên
            for (Order.Status s : Order.Status.values()) {
                if (s.name().equalsIgnoreCase(statusStr)) {
                    newStatus = s;
                    break;
                }
            }

            if (newStatus == null) {
                 // Nếu không tìm thấy ENUM, thử tìm kiếm theo dbValue (ví dụ: "Phê duyệt")
                for (Order.Status s : Order.Status.values()) {
                    if (s.getDbValue().equalsIgnoreCase(statusStr)) {
                        newStatus = s;
                        break;
                    }
                }
                if (newStatus == null) {
                    session.setAttribute("errorMessage", "Trạng thái đơn hàng không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/employee/orders");
                    return;
                }
            }
            
            // 3. Thực hiện cập nhật trạng thái (QLĐH_03)
            orderDao.updateOrderStatus(orderId, newStatus);
            
            session.setAttribute("successMessage", "Cập nhật trạng thái đơn hàng #" + orderId + " thành công thành '" + newStatus.getDbValue() + "'.");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID đơn hàng không hợp lệ.");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi CSDL khi cập nhật trạng thái đơn hàng: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi không xác định: " + e.getMessage());
        }

        // Chuyển hướng về trang danh sách đơn hàng
        response.sendRedirect(request.getContextPath() + "/employee/orders");
    }
}