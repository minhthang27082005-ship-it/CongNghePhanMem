package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import thang.itplus.dao.EmployeeDAO;
import thang.itplus.models.Employee;
import thang.itplus.models.User;
import thang.itplus.models.User.Role;

@WebServlet(name = "EmployeeProfileController", urlPatterns = {"/employee/profile"})
public class EmployeeProfileController extends HttpServlet {
    
    private final EmployeeDAO employeeDAO = new EmployeeDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // 1. Kiểm tra phân quyền
        if (currentUser == null || currentUser.getRole() != Role.EMPLOYEE) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Truy cập bị từ chối.");
            return;
        }

        try {
            // 2. Lấy thông tin chi tiết hồ sơ nhân viên dựa trên User ID
            // ⭐ ĐÃ SỬA: Dùng phương thức selectEmployeeByUserId (khớp với EmployeeDAO)
            Employee employeeProfile = employeeDAO.selectEmployeeByUserId(currentUser.getUser_id()); 
            
            // 3. Đặt hồ sơ vào request scope
            request.setAttribute("employeeProfile", employeeProfile);
            
            // 4. Thiết lập Layout (Dẫn đến employee_profile.jsp)
            request.setAttribute("pageTitle", "Hồ Sơ Cá Nhân");
            request.setAttribute("contentPage", "employee_profile.jsp"); 
            
            // 5. Forward đến Layout để hiển thị Sidebar
            request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi khi tải hồ sơ nhân viên: " + e.getMessage());
            // Forward đến trang lỗi chung hoặc dashboard
            response.sendRedirect(request.getContextPath() + "/logout"); 
        }
    }
}