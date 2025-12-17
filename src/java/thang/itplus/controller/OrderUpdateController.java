package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.OrderDao;
import thang.itplus.models.Order;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet(name = "OrderUpdateController", urlPatterns = {"/update-order"})
public class OrderUpdateController extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); 

        try {
            // 1. Lấy ID đơn hàng từ form
            int orderId = Integer.parseInt(request.getParameter("order_id")); 
            
            // 2. Lấy thông tin đơn hàng hiện tại từ Database để giữ lại các trường quan trọng
            Order existingOrder = orderDao.getOrderById(orderId);
            
            if (existingOrder == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy đơn hàng ID: " + orderId);
                response.sendRedirect(request.getContextPath() + "/orderlist");
                return;
            }

            // 3. Khởi tạo đối tượng cập nhật
            Order updatedOrder = new Order();
            updatedOrder.setOrder_id(orderId);
            updatedOrder.setUser_id(Integer.parseInt(request.getParameter("customer_id")));
            
            // --- SỬA LỖI NGÀY THÁNG (FIX LỖI INDEX 10) ---
            // Input date từ form chỉ trả về yyyy-MM-dd, cần dùng LocalDate để parse
            String orderDateStr = request.getParameter("order_date");
            if (orderDateStr != null && !orderDateStr.isEmpty()) {
                LocalDate localDate = LocalDate.parse(orderDateStr);
                // Chuyển về LocalDateTime (thêm giờ 00:00:00)
                updatedOrder.setOrder_date(localDate.atStartOfDay());
            } else {
                updatedOrder.setOrder_date(existingOrder.getOrder_date());
            }
            
            updatedOrder.setTotal_amount(new BigDecimal(request.getParameter("total_amount")));

            // --- SỬA LỖI TRẠNG THÁI (STATUS) ---
            // So sánh với tên Enum (name) để khớp với value="PHE_DUYET" từ form
            String statusStr = request.getParameter("status"); 
            Order.Status status = Order.Status.PHE_DUYET; // Mặc định
            for (Order.Status s : Order.Status.values()) {
                if (s.name().equalsIgnoreCase(statusStr)) {
                    status = s;
                    break;
                }
            }
            updatedOrder.setStatus(status);
            
            // --- BẢO TOÀN ĐỊA CHỈ VÀ SỐ ĐIỆN THOẠI ---
            // Lấy lại dữ liệu thật từ existingOrder để không bị ghi đè thành "Địa chỉ mặc định"
            updatedOrder.setShipping_address(existingOrder.getShipping_address());
            updatedOrder.setPhone_number(existingOrder.getPhone_number());
            updatedOrder.setVoucherId(existingOrder.getVoucherId());

            // 4. Thực hiện cập nhật vào CSDL
            boolean success = orderDao.updateOrder(updatedOrder); 

            if (success) {
                request.getSession().setAttribute("successMessage", "Cập nhật đơn hàng ID " + orderId + " thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Cập nhật đơn hàng ID " + orderId + " thất bại.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/orderlist");
    }
}