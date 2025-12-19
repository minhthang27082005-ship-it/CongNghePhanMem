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
import thang.itplus.dao.ProductDao;
import thang.itplus.dao.InventoryDao;
import thang.itplus.models.User;
import thang.itplus.models.Product;
import thang.itplus.models.InventoryTransaction;

@WebServlet(name = "InventoryManagerController", urlPatterns = {"/quanlykho"})
public class InventoryManagerController extends HttpServlet {
    
    private final ProductDao productDao = new ProductDao();
    private final InventoryDao inventoryDao = new InventoryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Bảo vệ quyền truy cập
        if (currentUser == null || (currentUser.getRole() != User.Role.EMPLOYEE && currentUser.getRole() != User.Role.admin)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            // 1. Tải danh sách tồn kho
            List<Product> productList = productDao.getAllProduct();
            request.setAttribute("listProduct", productList);

            // 2. Tải lịch sử giao dịch (có lọc nếu có)
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            List<InventoryTransaction> historyList = inventoryDao.getHistory(startDate, endDate);
            request.setAttribute("historyList", historyList);

            // 3. Cấu hình Layout
            request.setAttribute("pageTitle", "Quản Lý Kho Hàng");
            request.setAttribute("contentPage", "inventory_management.jsp");

            request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi CSDL khi tải dữ liệu kho.");
            response.sendRedirect(request.getContextPath() + "/employee/profile");
        }
    }
}