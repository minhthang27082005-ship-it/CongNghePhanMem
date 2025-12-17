package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

// Import các DAO cần thiết
import thang.itplus.dao.OrderDao;
import thang.itplus.dao.ProductDao;
import thang.itplus.dao.UserDao;
import thang.itplus.dao.EmployeeDAO;

// Import các Models
import thang.itplus.models.User;
import thang.itplus.models.Product; // Cần nếu dùng cho biểu đồ

/**
 * Servlet quản lý trang Dashboard cho Admin.
 */
public class AdminController extends HttpServlet {

    // Khởi tạo các DAO để sử dụng
    private final OrderDao orderDao = new OrderDao();
    private final ProductDao productDao = new ProductDao();
    private final UserDao userDao = new UserDao();
    private final EmployeeDAO employeeDao = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Lấy session hiện tại, không tạo nếu chưa có
        User loggedInUser = null;

        if (session != null) {
            // Lấy thông tin user (được lưu bằng khóa "user" trong LoginController)
            loggedInUser = (User) session.getAttribute("user");
        }
        
        // 1. KIỂM TRA QUYỀN TRUY CẬP (Bảo mật)
        // Nếu không có user trong session HOẶC user không phải là Admin, chuyển hướng về trang đăng nhập
        if (loggedInUser == null || loggedInUser.getRole() != User.Role.admin) {
             // Đặt thông báo lỗi nếu cần
             session.setAttribute("errorMessage", "Vui lòng đăng nhập với tài khoản Admin để truy cập.");
             response.sendRedirect(request.getContextPath() + "/login"); 
             return;
        }
        
        // 2. HIỂN THỊ THÔNG TIN QUẢN TRỊ VIÊN
        // Đặt đối tượng User vào request scope để admin.jsp hiển thị
        request.setAttribute("loggedInAdmin", loggedInUser); 

        // 3. XỬ LÝ CÁC CHỈ SỐ KPI ĐỘNG
        try {
            // KPI 1: Tổng Doanh thu (Hoàn thành)
            BigDecimal totalRevenue = orderDao.getTotalRevenue();
            request.setAttribute("totalRevenue", totalRevenue);

            // KPI 2: Tổng số Đơn hàng
            int totalOrders = orderDao.getTotalOrders(); 
            request.setAttribute("totalOrders", totalOrders);

            // KPI 3: Tổng số Sản phẩm
            int totalProducts = productDao.getTotalProducts();
            request.setAttribute("totalProducts", totalProducts);

            // KPI 4: Tổng số Nhân viên (Giả định có getTotalEmployees trong EmployeeDAO)
            int totalEmployees = employeeDao.getTotalEmployees(); // Cần đảm bảo EmployeeDAO có phương thức này
            request.setAttribute("totalEmployees", totalEmployees);
            
            // KPI 5: Tổng số Khách hàng
            int totalCustomers = userDao.getTotalCustomers(); // Cần đảm bảo UserDao có phương thức này
            request.setAttribute("totalCustomers", totalCustomers);
            
            
            // 4. XỬ LÝ DỮ LIỆU BIỂU ĐỒ
            
            // Biểu đồ 1: Doanh thu theo tháng (12 tháng gần nhất)
            Map<String, BigDecimal> monthlyRevenueMap = orderDao.getMonthlyRevenueData();
            // Chuyển Map thành List/Array cho JSP dễ dùng
            request.setAttribute("monthlyLabels", monthlyRevenueMap.keySet());
            request.setAttribute("monthlyData", monthlyRevenueMap.values());
            
            // Biểu đồ 2: Sản phẩm theo danh mục (Giả định có getProductsCountByCategory trong ProductDao)
            Map<String, Integer> categoryProductMap = productDao.getProductsCountByCategory();
            // Chuyển Map thành List/Array cho JSP dễ dùng
            request.setAttribute("categoryLabels", categoryProductMap.keySet());
            request.setAttribute("categoryData", categoryProductMap.values());

        } catch (Exception e) {
            // Ghi log lỗi và đặt thông báo lỗi cho người dùng
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu dashboard: " + e.getMessage());
        }

        // 5. Forward đến trang JSP
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
    
    // Giữ nguyên doPost nếu không cần xử lý POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Dashboard Controller";
    }
}