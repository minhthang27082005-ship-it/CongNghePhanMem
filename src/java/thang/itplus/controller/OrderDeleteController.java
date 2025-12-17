package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.OrderDao;

import java.io.IOException;

@WebServlet(name = "OrderDeleteController", urlPatterns = {"/delete-order"})
public class OrderDeleteController extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy ID đơn hàng từ hidden input trong form xóa
            int orderId = Integer.parseInt(request.getParameter("id")); 
            
            // Giả định OrderDao có phương thức deleteOrder(int orderId)
            // (Bạn cần tự thêm phương thức này vào OrderDao.java)
            boolean success = orderDao.deleteOrder(orderId); 

            if (success) {
                request.getSession().setAttribute("successMessage", "Xóa đơn hàng ID " + orderId + " thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Xóa đơn hàng ID " + orderId + " thất bại.");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Lỗi: ID đơn hàng không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi khi xóa đơn hàng: " + e.getMessage());
        }
        
        // Chuyển hướng về trang danh sách để cập nhật
        response.sendRedirect(request.getContextPath() + "/orderlist"); 
    }
}