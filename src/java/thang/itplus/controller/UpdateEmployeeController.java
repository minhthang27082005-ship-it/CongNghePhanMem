package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.sql.SQLException;
import java.text.ParseException;

import thang.itplus.dao.CustomerDAO;
import thang.itplus.dao.EmployeeDAO;
import thang.itplus.models.Employee;
import thang.itplus.models.User;

/**
 * Servlet để cập nhật thông tin nhân viên hiện có.
 * Xử lý dữ liệu từ form trên employee.jsp.
 *
 * @author a4698
 */
// @jakarta.servlet.annotation.WebServlet("/update-employee")
public class UpdateEmployeeController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private EmployeeDAO employeeDAO;
    private CustomerDAO userDAO;

    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    public void init() throws ServletException { 
        super.init(); // Thêm super.init()
        employeeDAO = new EmployeeDAO();
        userDAO = new CustomerDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/employeelist");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        try {
            // Lấy tham số
            int employeeId = Integer.parseInt(request.getParameter("employee_id")); 
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String position = request.getParameter("position");
            
            double salary = 0.0; 
            String salaryParam = request.getParameter("salary");
            if (salaryParam != null && !salaryParam.isEmpty()) {
                salary = Double.parseDouble(salaryParam);
            } else {
                session.setAttribute("errorMessage", "Lương không được để trống.");
                response.sendRedirect(request.getContextPath() + "/employeelist");
                return;
            }

            String hireDateStr = request.getParameter("hireDate");
            String status = request.getParameter("status");
            String role = request.getParameter("role"); // Giá trị vai trò từ form

            // VALIDATION
            if (name == null || name.isEmpty() ||
                email == null || email.isEmpty() ||
                role == null || role.isEmpty()) {
                
                session.setAttribute("errorMessage", "Vui lòng điền đầy đủ các trường Tên, Email và Vai trò.");
                response.sendRedirect(request.getContextPath() + "/employeelist");
                return;
            }

            // Xử lý hireDate
            Date hireDate = null;
            if (hireDateStr != null && !hireDateStr.isEmpty()) {
                try {
                    hireDate = DATE_FORMAT.parse(hireDateStr);
                } catch (ParseException e) {
                    session.setAttribute("errorMessage", "Định dạng ngày vào làm không hợp lệ. Vui lòng sử dụngyyyy-MM-DD.");
                    response.sendRedirect(request.getContextPath() + "/employeelist");
                    return;
                }
            }
            
            // Lấy nhân viên hiện có
            Employee existingEmployee = employeeDAO.selectEmployeeById(employeeId);
            if (existingEmployee == null) {
                session.setAttribute("errorMessage", "Không tìm thấy nhân viên cần cập nhật.");
                response.sendRedirect(request.getContextPath() + "/employeelist");
                return;
            }
            int userId = existingEmployee.getUser_id();

            // Cập nhật Employee
            Employee employeeToUpdate = new Employee(employeeId, userId, name, email, phone, address, position, salary, hireDate, status);
            boolean employeeUpdated = employeeDAO.updateEmployee(employeeToUpdate);

            // Cập nhật User
            User userToUpdate = userDAO.selectUserById(userId);
            if (userToUpdate == null) {
                 session.setAttribute("errorMessage", "Không tìm thấy thông tin tài khoản người dùng liên quan.");
                 response.sendRedirect(request.getContextPath() + "/employeelist");
                 return;
            }

            userToUpdate.setName(name);
            userToUpdate.setEmail(email);
            userToUpdate.setPhone(phone);
            userToUpdate.setAddress(address);
            
            // --- ĐOẠN CODE ĐÃ SỬA ĐỂ KHẮC PHỤC LỖI ENUM ---
            User.Role userRole = null;
            String roleInput = request.getParameter("role"); // Lấy giá trị: "Employee" hoặc "Admin"

            try {
                if (roleInput.equalsIgnoreCase("Employee")) {
                    userRole = User.Role.EMPLOYEE; // Khớp với hằng số chữ HOA
                } else if (roleInput.equalsIgnoreCase("Admin")) {
                    userRole = User.Role.admin; // Khớp với hằng số chữ thường
                } else if (roleInput.equalsIgnoreCase("Customer")) {
                    userRole = User.Role.customer; // Khớp với hằng số chữ thường
                } else {
                    session.setAttribute("errorMessage", "Giá trị vai trò không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/employeelist");
                    return;
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Lỗi ánh xạ vai trò: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/employeelist");
                return;
            }
            userToUpdate.setRole(userRole);
            // ---------------------------------------------
            
            // Giữ mật khẩu cũ
            // Cần selectUserById lần nữa vì userToUpdate ở trên có thể không chứa mật khẩu (tùy thuộc vào DAO)
            userToUpdate.setPassword(userDAO.selectUserById(userId).getPassword()); 
            
            // Gọi phương thức update User.
            boolean userUpdated = userDAO.updateUser(userToUpdate); 

            if (employeeUpdated && userUpdated) {
                session.setAttribute("successMessage", "Cập nhật thông tin nhân viên và tài khoản người dùng thành công!");
            } else if (employeeUpdated) {
                session.setAttribute("errorMessage", "Cập nhật thông tin nhân viên thành công, nhưng không thể cập nhật thông tin tài khoản người dùng.");
            } else {
                session.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật thông tin nhân viên.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ. Vui lòng kiểm tra ID, Lương hoặc các trường số.");
            System.err.println("NumberFormatException: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu khi cập nhật nhân viên: " + e.getMessage());
            System.err.println("SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi không xác định khi cập nhật nhân viên: " + e.getMessage());
            System.err.println("General Exception: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/employeelist");
    }
}