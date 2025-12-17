package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import thang.itplus.dao.OrderDao;
import thang.itplus.models.Order;
import thang.itplus.models.OrderDetail;
import thang.itplus.models.Payment; 
import thang.itplus.models.Voucher; 
import thang.itplus.models.User;
import thang.itplus.models.User.Role; // ⭐ BỔ SUNG: Import Role Enum

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderDetailController", urlPatterns = {"/orderdetail"})
public class OrderDetailController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String orderIdParam = request.getParameter("orderId");
        
        // 1. Kiểm tra đăng nhập và Order ID hợp lệ
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu Order ID.");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdParam);
            Order order = orderDao.getOrderById(orderId); 
            
            // 2. Kiểm tra Order tồn tại
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng ID: " + orderId);
                return;
            }
            
            // 3. Kiểm tra quyền truy cập (ĐÃ SỬA DỤNG ENUM CHÍNH XÁC)
            // ⭐ SỬA LỖI: So sánh trực tiếp với Enum hằng số User.Role.admin
            boolean isAdmin = currentUser.getRole() == Role.admin; 
            
            if (!isAdmin && order.getUser_id() != currentUser.getUser_id()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập đơn hàng này.");
                return;
            }
            
            // 4. Lấy chi tiết sản phẩm (Order Details)
            List<OrderDetail> details = orderDao.getOrderDetails(orderId);
            
            // 5. Lấy thông tin thanh toán (Payment)
            Payment payment = orderDao.getPaymentByOrderId(orderId);
            
            // 6. Lấy thông tin Mã giảm giá (Voucher)
            Voucher voucher = null;
            if (order.getVoucherId() != null) {
                voucher = orderDao.getVoucherById(order.getVoucherId());
            }
            
            // 7. Đặt vào Request Scope
            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.setAttribute("payment", payment); 
            request.setAttribute("voucher", voucher); 
            
            // 8. Chuyển tiếp đến trang JSP
            request.getRequestDispatcher("/order_detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xử lý chi tiết đơn hàng.");
        }
    }
}