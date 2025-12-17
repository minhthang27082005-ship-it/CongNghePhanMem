package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;

import thang.itplus.dao.EmployeeDAO;
import thang.itplus.models.Employee;
import thang.itplus.models.User;
import thang.itplus.models.User.Role; // Bổ sung

/**
 * Servlet để hiển thị danh sách tất cả nhân viên HOẶC hồ sơ cá nhân (tùy vai trò).
 */
public class EmployeeListController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if (currentUser.getRole() == Role.admin) {
                // 2. LÀ ADMIN: Lấy tất cả nhân viên (danh sách)
                List<Employee> listEmployee = employeeDAO.selectAllEmployees();
                request.setAttribute("listEmployee", listEmployee);
                // Chuyển hướng đến trang danh sách ADMIN (cho phép CRUD)
                request.getRequestDispatcher("/employee.jsp").forward(request, response);
                
            } else if (currentUser.getRole() == Role.EMPLOYEE) {
                // 3. LÀ EMPLOYEE: Chỉ lấy hồ sơ cá nhân của họ
                int userId = currentUser.getUser_id();
                // ⭐ Cần đảm bảo EmployeeDAO có phương thức selectEmployeeByUserId(userId)
                Employee profile = employeeDAO.selectEmployeeByUserId(userId); 

                if (profile != null) {
                    // Đặt đối tượng Employee duy nhất vào request scope
                    request.setAttribute("employeeProfile", profile);
                    // Chuyển hướng đến trang Profile cá nhân (chỉ xem chi tiết)
                    request.getRequestDispatcher("/employee_profile.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy hồ sơ nhân viên của bạn.");
                    request.getRequestDispatcher("/employee_dashboard.jsp").forward(request, response);
                }
                
            } else {
                // Vai trò khác
                response.sendRedirect(request.getContextPath() + "/home");
            }

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi CSDL khi tải dữ liệu nhân viên: " + e.getMessage());
            e.printStackTrace();
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi không xác định: " + e.getMessage());
            e.printStackTrace();
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}