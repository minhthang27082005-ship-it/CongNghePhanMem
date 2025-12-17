package thang.itplus.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import thang.itplus.dao.OrderDao;
import thang.itplus.models.Cart;
import thang.itplus.models.Order;
import thang.itplus.models.Payment;
import thang.itplus.models.User;
import thang.itplus.models.Voucher; 
import thang.itplus.models.Payment.PaymentMethod;

public class PaymentServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    private void setCheckoutAttributes(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null) {
                request.setAttribute("totalAmount", cart.calculateTotalAmount()); 
                request.setAttribute("cart", cart); 
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart == null || cart.getListItems().isEmpty()) {
                response.sendRedirect("cartdetail"); 
                return;
            }

            setCheckoutAttributes(request); 

            request.getRequestDispatcher("/payment.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Lỗi trong doGet của PaymentServlet: " + e.getMessage());
            setCheckoutAttributes(request);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi chuẩn bị trang thanh toán.");
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect("login.jsp"); 
                return;
            }
            
            Integer userId = currentUser.getUser_id(); 
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart == null || cart.getListItems().isEmpty()) { 
                setCheckoutAttributes(request); 
                request.setAttribute("errorMessage", "Giỏ hàng của bạn trống hoặc không tồn tại.");
                request.getRequestDispatcher("/payment.jsp").forward(request, response); 
                return;
            }
            
            // 2. Lấy dữ liệu từ Form
            String shippingAddress = request.getParameter("shipping_address");
            String phoneNumber = request.getParameter("phone_number");
            String paymentMethodStr = request.getParameter("paymentMethod");
            
            if (shippingAddress == null || shippingAddress.isEmpty() || phoneNumber == null || phoneNumber.isEmpty()) {
                setCheckoutAttributes(request); 
                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin giao hàng.");
                request.getRequestDispatcher("/payment.jsp").forward(request, response); 
                return;
            }

            // 3. Xử lý Voucher và Chuẩn bị Models
            
            Integer appliedVoucherId = null;
            Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");
            Double discountAmount = (Double) session.getAttribute("discountAmount"); 
            
            if (appliedVoucher != null) {
                appliedVoucherId = appliedVoucher.getVoucher_id();
            }
            if (discountAmount == null) {
                discountAmount = 0.0;
            }
            
            // Tính toán TỔNG TIỀN HÀNG (Total Amount Before Discount)
            BigDecimal totalAmountBeforeDiscount = cart.calculateTotalAmount(); 
            
            // ⭐ FIX: Tính toán tổng tiền cuối cùng (Total Amount) sau khi đã trừ giảm giá
            BigDecimal finalTotalAmount = totalAmountBeforeDiscount.subtract(new BigDecimal(discountAmount));
            if (finalTotalAmount.compareTo(BigDecimal.ZERO) < 0) {
                 finalTotalAmount = BigDecimal.ZERO;
            }
            
            Order order = new Order();
            order.setUser_id(userId);
            order.setTotal_amount(finalTotalAmount); // SỬ DỤNG TỔNG TIỀN CUỐI CÙNG
            order.setShipping_address(shippingAddress);
            order.setPhone_number(phoneNumber);
            order.setVoucherId(appliedVoucherId);

            Payment payment = new Payment();
            payment.setAmount(finalTotalAmount); // SỬ DỤNG TỔNG TIỀN CUỐI CÙNG
            
            payment.setPayment_method(PaymentMethod.valueOf(paymentMethodStr.toUpperCase())); 
            payment.setPayment_date(LocalDateTime.now());

            // GỌI LOGIC TRANSACTION
            boolean success = orderDao.processCheckout(order, cart, payment);

            // 4. Xử lý kết quả Transaction
            if (success) {
                session.removeAttribute("cart"); 
                session.removeAttribute("appliedVoucher");
                session.removeAttribute("discountAmount"); 
                
                request.setAttribute("orderId", order.getOrder_id());
                
                response.sendRedirect("order-success.jsp"); 
            } else {
                // Lỗi Transaction Rollback (Lỗi CSDL hoặc thiếu Stock)
                setCheckoutAttributes(request); 
                request.setAttribute("errorMessage", "Lỗi CSDL: Đã xảy ra lỗi nghiêm trọng khi xử lý đơn hàng. Dữ liệu đã được khôi phục. Vui lòng thử lại. (Kiểm tra Stock và ràng buộc Khóa ngoại!)");
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
            }

        } catch (IllegalArgumentException e) {
            setCheckoutAttributes(request); 
            request.setAttribute("errorMessage", "Phương thức thanh toán không hợp lệ.");
            request.getRequestDispatcher("/payment.jsp").forward(request, response); 
        } catch (Exception e) {
            e.printStackTrace();
            setCheckoutAttributes(request); 
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
        }
    }
}