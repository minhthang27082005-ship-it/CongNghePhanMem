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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "OrderAddController", urlPatterns = {"/add-order"})
public class OrderAddController extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Đảm bảo request dùng encoding UTF-8 để xử lý dữ liệu tiếng Việt (nếu cần)
        request.setCharacterEncoding("UTF-8"); 

        try {
            // Lấy thông tin từ form orders.jsp
            // order_id được tạo tự động trong DB, nên ta chỉ cần lấy các trường còn lại.
            // Tuy nhiên, form ở orders.jsp đang gửi order_id (chế độ cứng), ta sẽ bỏ qua trường này khi Add
            
            int userId = Integer.parseInt(request.getParameter("customer_id")); // Giả định customer_id = user_id
            String orderDateStr = request.getParameter("order_date");
            BigDecimal totalAmount = new BigDecimal(request.getParameter("total_amount"));
            String statusStr = request.getParameter("status"); 
            
            // Tạo đối tượng Order mới
            Order newOrder = new Order();
            newOrder.setUser_id(userId);
            newOrder.setTotal_amount(totalAmount);
            // Thiết lập ngày giờ. Nếu orderDateStr rỗng, dùng thời gian hiện tại của Order() constructor.
            if (orderDateStr != null && !orderDateStr.isEmpty()) {
                // Định dạng ngày từ HTML input type="date" là YYYY-MM-DD
                newOrder.setOrder_date(LocalDateTime.parse(orderDateStr + " 00:00:00", DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))); 
            }
            
            // Chuyển đổi trạng thái từ chuỗi sang Enum (hoặc giả định DAO xử lý String trực tiếp)
            // Dựa trên Order.java, ta cần tìm Enum từ giá trị dbValue
            Order.Status status = Order.Status.values()[0]; // Default
            for (Order.Status s : Order.Status.values()) {
                if (s.getDbValue().equalsIgnoreCase(statusStr)) {
                    status = s;
                    break;
                }
            }
            newOrder.setStatus(status);
            
            // Gán giá trị mặc định cho các trường còn thiếu (shipping_address, phone_number,...)
            newOrder.setShipping_address("Địa chỉ mặc định");
            newOrder.setPhone_number("0000000000");
            
            // Giả định OrderDao có phương thức insertOrder(Order order)
            // (Bạn cần tự thêm phương thức này vào OrderDao.java)
            boolean success = orderDao.insertOrder(newOrder); 

            if (success) {
                request.getSession().setAttribute("successMessage", "Thêm đơn hàng thành công! ID: " + newOrder.getOrder_id());
            } else {
                request.getSession().setAttribute("errorMessage", "Thêm đơn hàng thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        
        // Chuyển hướng về trang danh sách để cập nhật
        response.sendRedirect(request.getContextPath() + "/orderlist"); 
    }
}