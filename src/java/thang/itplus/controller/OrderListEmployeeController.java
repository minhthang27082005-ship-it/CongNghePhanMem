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
import thang.itplus.models.Payment;
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

        if (currentUser == null || (currentUser.getRole() != Role.EMPLOYEE && currentUser.getRole() != Role.admin)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền.");
            return;
        }

        String orderIdSearch = request.getParameter("orderIdSearch");
        try {
            // 1. Xử lý tìm kiếm chi tiết đơn hàng nếu có ID
            if (orderIdSearch != null && !orderIdSearch.isEmpty()) {
                int orderId = Integer.parseInt(orderIdSearch);
                Order searchOrder = orderDao.getOrderById(orderId);
                Payment payment = orderDao.getPaymentByOrderId(orderId);

                request.setAttribute("selectedOrder", searchOrder);
                request.setAttribute("payment", payment);
            }

            // 2. Luôn lấy danh sách tất cả đơn hàng để hiển thị bên dưới
            List<Order> orderList = orderDao.getAllOrders();
            request.setAttribute("orderList", orderList);

            request.setAttribute("pageTitle", "Quản Lý Đơn Hàng & Thanh Toán");
            request.setAttribute("contentPage", "order_list_employee.jsp");
            request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/employee/orders");
        }
    }
}
