package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import java.sql.SQLException;
import java.text.ParseException;

import thang.itplus.dao.CustomerDAO;
import thang.itplus.dao.EmployeeDAO;
import thang.itplus.models.Employee;
import thang.itplus.models.User;

/**
 * Servlet để thêm nhân viên mới vào hệ thống.
 */
public class AddEmployeeController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private EmployeeDAO employeeDAO;
    private CustomerDAO userDAO; 
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    public void init() throws ServletException {
        super.init(); 
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
            // --- 1. LẤY DỮ LIỆU & XỬ LÝ LỖI NUMBER FORMAT ---
            
            // Xử lý Employee ID (integer)
            int employeeId = -1;
            String employeeIdParam = request.getParameter("employee_id");
            if (employeeIdParam != null && !employeeIdParam.isEmpty()) {
                employeeId = Integer.parseInt(employeeIdParam);
            } else {
                session.setAttribute("errorMessage", "ID nhân viên không được để trống.");
                response.sendRedirect(request.getContextPath() + "/employeelist");
                return;
            }
            
            // Xử lý Salary (double)
            double salary = 0.0; 
            String salaryParam = request.getParameter("salary");
            if (salaryParam != null && !salaryParam.isEmpty()) {
                salary = Double.parseDouble(salaryParam);
            } else {
                session.setAttribute("errorMessage", "Lương không được để trống.");
                response.sendRedirect(request.getContextPath() + "/employeelist");
                return;
            }
            
            // Lấy các tham số còn lại
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String position = request.getParameter("position");
            String hireDateStr = request.getParameter("hireDate");
            String status = request.getParameter("status");
            String role = request.getParameter("role");

            // VALIDATION: Kiểm tra các trường bắt buộc (Không thay đổi)
            if (name == null || name.isEmpty()
                    || email == null || email.isEmpty()
                    || password == null || password.isEmpty()
                    || confirmPassword == null || confirmPassword.isEmpty()
                    || !password.equals(confirmPassword)
                    || role == null || role.isEmpty()) {

                session.setAttribute("errorMessage", "Vui lòng điền đầy đủ các trường Tên, Email, Mật khẩu, Xác nhận mật khẩu (phải khớp) và Vai trò.");
                response.sendRedirect(request.getContextPath() + "/employeelist");
                return;
            }

            // Xử lý hireDate (java.util.Date)
            Date hireDate = null;
            if (hireDateStr != null && !hireDateStr.isEmpty()) {
                try {
                    hireDate = DATE_FORMAT.parse(hireDateStr);
                } catch (ParseException e) {
                    session.setAttribute("errorMessage", "Định dạng ngày vào làm không hợp lệ. Vui lòng sử dụng YYYY-MM-DD.");
                    response.sendRedirect(request.getContextPath() + "/employeelist");
                    return;
                }
            }

            // SERVER-SIDE CHECK: Kiểm tra trùng ID nhân viên (employeeId)
            if (employeeDAO.selectEmployeeById(employeeId) != null) {
                session.setAttribute("errorMessage", "ID nhân viên đã tồn tại. Vui lòng chọn ID khác.");
                response.sendRedirect(request.getContextPath() + "/employeelist");
                return;
            }
            
            // --- 2. XỬ LÝ USER VÀ VAI TRÒ ---
            
            // Tạo User ID duy nhất
            Random rand = new Random();
            int newUserId;
            do {
                newUserId = 100000 + rand.nextInt(900000); 
            } while (userDAO.selectUserById(newUserId) != null);

            // Ánh xạ vai trò (Logic đã sửa, đảm bảo không lỗi Enum)
            User.Role userRole = null;
            String roleInput = request.getParameter("role"); 

            if (roleInput.equalsIgnoreCase("Employee")) {
                userRole = User.Role.EMPLOYEE; 
            } else if (roleInput.equalsIgnoreCase("Admin")) {
                userRole = User.Role.admin; 
            } else if (roleInput.equalsIgnoreCase("Customer")) {
                userRole = User.Role.customer; 
            } else {
                 session.setAttribute("errorMessage", "Giá trị vai trò không hợp lệ.");
                 response.sendRedirect(request.getContextPath() + "/employeelist");
                 return;
            }

            // LƯU Ý QUAN TRỌNG: Hash mật khẩu trước khi lưu vào DB!
            User newUser = new User(newUserId, name, email, password, phone, address, userRole);

            // Gọi phương thức insertUser.
            userDAO.insertUser(newUser);

            // --- 3. TẠO VÀ LƯU EMPLOYEE ---
            
            Employee newEmployee = new Employee(employeeId, newUserId, name, email, phone, address, position, salary, hireDate, status);

            // Insert Employee vào DB
            boolean employeeInserted = employeeDAO.insertEmployee(newEmployee);

            if (employeeInserted) {
                session.setAttribute("successMessage", "Thêm nhân viên mới thành công!");
            } else {
                session.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm thông tin chi tiết nhân viên. (Đã thêm User nhưng không thêm được Employee).");
            }

        } catch (NumberFormatException e) {
            // Khối này sẽ chỉ bắt lỗi nếu logic kiểm tra rỗng ở trên bị thiếu hoặc giá trị đầu vào là NaN
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ. Vui lòng kiểm tra ID, Lương hoặc các trường số.");
            System.err.println("NumberFormatException: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) { 
            session.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu khi thêm nhân viên: " + e.getMessage());
            System.err.println("SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi không xác định khi thêm nhân viên: " + e.getMessage());
            System.err.println("General Exception: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/employeelist");
    }
}