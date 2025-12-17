package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Cần import này
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.OrderDao;
import thang.itplus.models.Order;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderListController", urlPatterns = {"/orderlist"}) // <-- Đã thêm Annotation
public class OrderListController extends HttpServlet {
// ... nội dung còn lại giữ nguyên ...
    private OrderDao orderDao = new OrderDao(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            List<Order> orders = orderDao.getAllOrders(); 
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/orders.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi khi tải danh sách đơn hàng: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin");
        }
    }
}