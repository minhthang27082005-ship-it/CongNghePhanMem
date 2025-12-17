package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import thang.itplus.dao.ProductDao;
import thang.itplus.models.Product;
import thang.itplus.models.User;
import thang.itplus.models.User.Role;


@WebServlet(name = "EmployeeProductListController", urlPatterns = {"/employee/products"})
public class EmployeeProductListController extends HttpServlet {

    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // ⭐ Bảo vệ: Chỉ cho phép Employee và Admin truy cập
        if (currentUser == null || (currentUser.getRole() != Role.EMPLOYEE && currentUser.getRole() != Role.admin)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Truy cập bị từ chối.");
            return;
        }

        try {
            // Lấy danh sách sản phẩm
            List<Product> list = productDao.getAllProduct();
            
            // Đặt vào request scope để JSP hiển thị
            request.setAttribute("listProduct", list);

            // ⭐ Sử dụng Layout
            request.setAttribute("pageTitle", "Kiểm Tra Tồn Kho");
            request.setAttribute("contentPage", "product_list_emp.jsp");
            
            // ⭐ Chuyển tiếp đến trang LAYOUT
            request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi CSDL khi tải danh sách sản phẩm.");
            // ⭐ Sửa: Chuyển hướng về Profile mặc định
            response.sendRedirect(request.getContextPath() + "/employee/profile");
        }
    }
}