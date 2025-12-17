package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.OrderDao;
import thang.itplus.models.Order;
import thang.itplus.models.User; // Giả định có model User

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyOrdersController", urlPatterns = {"/my-orders"})
public class MyOrdersController extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Kiểm tra đăng nhập
        User user = (User) request.getSession().getAttribute("user");
        
        if (user == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            int userId = user.getUser_id(); // Giả định model User có phương thức getUser_id()
            
            // 2. Lấy danh sách đơn hàng của người dùng này
            List<Order> orders = orderDao.getOrdersByUserId(userId); 
            
            // 3. Đặt vào request scope
            request.setAttribute("orders", orders);
            
            // 4. Chuyển tiếp đến JSP (có thể dùng lại orders.jsp hoặc tạo myorders.jsp riêng)
            // TẠM THỜI CHÚNG TA SẼ TẠO myorders.jsp ĐƠN GIẢN
            request.getRequestDispatcher("/myorders.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải đơn hàng của bạn: " + e.getMessage());
            request.getRequestDispatcher("/home").forward(request, response);
        }
    }
}