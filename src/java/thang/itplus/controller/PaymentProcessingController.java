package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

import thang.itplus.dao.OrderDao;
import thang.itplus.models.Order;
import thang.itplus.models.Payment;

@WebServlet(name = "PaymentProcessingController", urlPatterns = {"/payment_process"})
public class PaymentProcessingController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String orderIdStr = request.getParameter("orderId");
        
        // --- Xử lý QLĐH_11: Xuất Hóa Đơn PDF ---
        String action = request.getParameter("action");
        if ("export_pdf".equals(action) && orderIdStr != null) {
            session.setAttribute("successMessage", "QLĐH_11: Đã yêu cầu xuất Hóa đơn PDF cho Đơn hàng #" + orderIdStr + ".");
            response.sendRedirect(request.getContextPath() + "/payment_process?orderId=" + orderIdStr);
            return;
        }
        
        // --- Xử lý Xem Chi Tiết Đơn Hàng ---
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDao.getOrderById(orderId);
                Payment payment = orderDao.getPaymentByOrderId(orderId);
                
                request.setAttribute("order", order);
                request.setAttribute("payment", payment);
                
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID Đơn hàng không hợp lệ.");
            }
        }
        
        // ⭐ Sử dụng Layout
        request.setAttribute("pageTitle", "Xác Nhận & Hóa Đơn");
        request.setAttribute("contentPage", "payment_processing_view.jsp");
        
        // Chuyển tiếp đến Layout
        request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        
        if ("confirm_payment".equals(action) && orderIdStr != null) {
            
            try {
                int orderId = Integer.parseInt(orderIdStr);
                BigDecimal requiredAmount = new BigDecimal(request.getParameter("requiredAmount"));
                BigDecimal amountReceived = new BigDecimal(request.getParameter("amountReceived"));
                
                // Xử lý QLĐH_09 & QLĐH_10 (Thiếu/Thừa)
                int comparison = amountReceived.compareTo(requiredAmount);

                if (comparison < 0) {
                    // QLĐH_09: Thiếu tiền
                    BigDecimal difference = requiredAmount.subtract(amountReceived);
                    session.setAttribute("errorMessage", "QLĐH_09: Số tiền nhận được bị thiếu: " + difference.toPlainString() + " VNĐ.");
                } else {
                    // QLĐH_08: Đủ tiền hoặc Thừa tiền
                    
                    // (Cần bổ sung logic ghi nhận Payment vào DB tại đây)
                    
                    if (comparison > 0) {
                        // QLĐH_10: Thừa tiền
                        BigDecimal change = amountReceived.subtract(requiredAmount);
                        session.setAttribute("successMessage", "QLĐH_08: Thanh toán thành công. Tiền thừa cần trả lại: " + change.toPlainString() + " VNĐ (QLĐH_10).");
                    } else {
                        // Vừa đủ
                        session.setAttribute("successMessage", "QLĐH_08: Thanh toán thành công, đủ tiền.");
                    }
                }
                
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Dữ liệu nhập vào không hợp lệ.");
            }
        }
        
        // Chuyển hướng về trang xử lý thanh toán để hiển thị kết quả và tải lại thông tin đơn hàng
        response.sendRedirect(request.getContextPath() + "/payment_process?orderId=" + orderIdStr);
    }
}