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
import thang.itplus.dao.OrderDao;
import thang.itplus.models.Order;
import thang.itplus.models.User;
import thang.itplus.models.User.Role;

@WebServlet(name = "OrderListEmployeeController", urlPatterns = {"/employee/orders"})
public class OrderListEmployeeController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // 1. Kiểm tra phân quyền
        if (currentUser == null || (currentUser.getRole() != Role.EMPLOYEE && currentUser.getRole() != Role.admin)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }

        try {
            // 2. Lấy danh sách tất cả đơn hàng
            List<Order> orderList = orderDao.getAllOrders();

            // 3. Đặt vào Request Scope
            request.setAttribute("orderList", orderList);
            
            // ⭐ SỬA ĐỔI: Sử dụng Layout
            request.setAttribute("pageTitle", "Danh Sách Đơn Hàng");
            request.setAttribute("contentPage", "order_list_employee.jsp");
            
            // 4. Chuyển tiếp đến trang LAYOUT
            request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi tải danh sách đơn hàng: " + e.getMessage());
            
            // ⭐ Sửa: Chuyển hướng về Profile mặc định
            response.sendRedirect(request.getContextPath() + "/employee/profile"); 
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}