package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

import thang.itplus.dao.EmployeeDAO;
import thang.itplus.dao.UserDao;
import thang.itplus.models.Employee;
import thang.itplus.models.User;
import thang.itplus.models.User.Role;

@WebServlet(name = "EmployeeUpdateProfileController", urlPatterns = {"/update-profile"})
public class EmployeeUpdateProfileController extends HttpServlet {

    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || currentUser.getRole() != Role.EMPLOYEE) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Truy cập bị từ chối.");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            // Lưu ý: Tên tham số trong JSP là 'employee_id' và 'user_id' (cần kiểm tra lại JSP nếu có lỗi)
            // Hiện tại, tôi dùng các tham số đã thấy trong code bạn cung cấp.
            int employeeId = Integer.parseInt(request.getParameter("employee_id"));
            int userId = Integer.parseInt(request.getParameter("user_id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // 1. Kiểm tra bảo mật: Chỉ được sửa hồ sơ của chính mình
            if (userId != currentUser.getUser_id()) {
                session.setAttribute("errorMessage", "Không được phép sửa hồ sơ người khác.");
                // ⭐ Redirect về Profile
                response.sendRedirect(request.getContextPath() + "/employee/profile");
                return;
            }

            // 2. Tạo đối tượng Employee và User để truyền vào DAO
            Employee updatedEmployee = new Employee();
            updatedEmployee.setEmployee_id(employeeId);
            updatedEmployee.setName(name);
            updatedEmployee.setEmail(email);
            updatedEmployee.setPhone(phone);
            updatedEmployee.setAddress(address);

            User updatedUser = new User();
            updatedUser.setUser_id(userId);
            updatedUser.setName(name);
            updatedUser.setEmail(email);
            updatedUser.setPhone(phone);
            updatedUser.setAddress(address);

            // 3. Thực hiện cập nhật Transaction (Employees và Users)
            String newPassword = request.getParameter("newPassword");

// 2. Cập nhật dòng gọi DAO (truyền thêm newPassword)
            boolean success = employeeDAO.updateEmployeeProfile(updatedEmployee, updatedUser, newPassword);

            if (success) {
                // 4. Cập nhật lại session 
                User updatedCurrentUser = userDao.selectUserById(userId);

                if (updatedCurrentUser != null) {
                    session.setAttribute("user", updatedCurrentUser); // Đồng bộ Session
                    session.setAttribute("successMessage", "Cập nhật hồ sơ cá nhân thành công.");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật thành công vào DB, nhưng không thể tải lại hồ sơ User.");
                }
            }

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật: " + e.getMessage());
        }

        // ⭐ Chuyển hướng về trang profile cá nhân
        response.sendRedirect(request.getContextPath() + "/employee/profile");
    }
}
