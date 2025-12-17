package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import thang.itplus.dao.CustomerDAO;
import thang.itplus.dao.EmployeeDAO;
import thang.itplus.models.User;
import thang.itplus.models.Employee; // Import model Employee
import java.sql.SQLException;
import java.util.Date;
import java.util.Random;

/**
 * Servlet để cập nhật thông tin khách hàng.
 */
public class UpdateCustomerController extends HttpServlet {

    private CustomerDAO customerDAO;
    private EmployeeDAO employeeDAO; // Thêm EmployeeDAO

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
        employeeDAO = new EmployeeDAO(); // Khởi tạo EmployeeDAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String errorMessage = null;
        String successMessage = null;
        
        // Khai báo biến roleStr ở phạm vi rộng hơn
        String roleStr = null; 

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                errorMessage = "Không tìm thấy ID khách hàng để cập nhật.";
            } else {
                int id = Integer.parseInt(idParam);
                
                User existingUser = customerDAO.selectUserById(id);

                if (existingUser == null) {
                    errorMessage = "Người dùng với ID " + id + " không tồn tại.";
                } else {
                    String name = request.getParameter("name");
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String phone = request.getParameter("phone");
                    String address = request.getParameter("address");
                    
                    // Lấy roleStr từ form
                    roleStr = request.getParameter("role");

                    if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                        errorMessage = "Tên và Email là các trường bắt buộc.";
                    } else {
                        // Lấy vai trò CŨ trước khi cập nhật
                        User.Role oldRole = existingUser.getRole();
                        
                        User.Role newRole = null;
                        
                        // --- 1. LOGIC ÁNH XẠ VAI TRÒ (Fix lỗi Enum) ---
                        if (roleStr != null) {
                            if (roleStr.equalsIgnoreCase("customer")) {
                                newRole = User.Role.customer;
                            } else if (roleStr.equalsIgnoreCase("admin")) {
                                newRole = User.Role.admin;
                            } else if (roleStr.equalsIgnoreCase("employee")) {
                                newRole = User.Role.EMPLOYEE; // Ánh xạ tới hằng số chữ HOA
                            } else {
                                errorMessage = "Vai trò không hợp lệ.";
                                System.err.println("Lỗi vai trò: " + roleStr + " không hợp lệ.");
                            }
                        } else {
                            errorMessage = "Không có thông tin vai trò.";
                        }
                        // ------------------------------------------------
                        
                        if (errorMessage == null) {
                            // Cập nhật thông tin User
                            existingUser.setName(name.trim());
                            existingUser.setEmail(email.trim());
                            if (password != null && !password.trim().isEmpty()) {
                                 // LƯU Ý: Cần Hash mật khẩu ở đây
                                 existingUser.setPassword(password);
                            }
                            existingUser.setPhone(phone != null ? phone.trim() : null);
                            existingUser.setAddress(address != null ? address.trim() : null);
                            existingUser.setRole(newRole); // Thiết lập vai trò mới
                            
                            boolean updateSuccess = customerDAO.updateUser(existingUser);
                            
                            // --- 2. LOGIC TẠO BẢN GHI EMPLOYEE (Fix lỗi không hiển thị) ---
                            if (updateSuccess && newRole == User.Role.EMPLOYEE && oldRole != User.Role.EMPLOYEE) {
                                // Nếu vai trò được nâng cấp thành EMPLOYEE và chưa có bản ghi Employee
                                
                                if (employeeDAO.selectEmployeeById(id) == null) { // Giả định EmployeeID = UserID
                                    // Tạo Employee ID ngẫu nhiên (hoặc dùng logic khác)
                                    Random rand = new Random();
                                    int newEmployeeId;
                                    do {
                                        newEmployeeId = 200000 + rand.nextInt(800000);
                                    } while (employeeDAO.selectEmployeeById(newEmployeeId) != null); 
                                    
                                    // Gán các giá trị mặc định cho Employee
                                    Employee newEmployee = new Employee(
                                        newEmployeeId, 
                                        id, // User ID
                                        name.trim(), 
                                        email.trim(), 
                                        phone != null ? phone.trim() : null, 
                                        address != null ? address.trim() : null, 
                                        "Nhân viên mới", // Vị trí mặc định
                                        0.0,             // Lương mặc định
                                        new Date(),      // Ngày thuê hiện tại
                                        "Active"
                                    );
                                    
                                    if (employeeDAO.insertEmployee(newEmployee)) {
                                        successMessage = "Cập nhật tài khoản và thăng cấp thành công! Vui lòng chỉnh sửa thông tin nhân viên (Lương, Vị trí).";
                                    } else {
                                        errorMessage = "Cập nhật tài khoản thành công, nhưng không thể tạo bản ghi chi tiết nhân viên.";
                                    }
                                }
                            } else if (updateSuccess) {
                                successMessage = "Cập nhật khách hàng '" + existingUser.getName() + "' thành công!";
                            } else {
                                errorMessage = "Cập nhật khách hàng '" + existingUser.getName() + "' không thành công! Có thể lỗi CSDL hoặc không có thay đổi.";
                            }
                        }
                    }
                }
            }
        } catch (NumberFormatException e) {
            errorMessage = "ID khách hàng không hợp lệ. Vui lòng nhập một số nguyên.";
            System.err.println("NumberFormatException in UpdateCustomerController: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            errorMessage = "Lỗi CSDL khi cập nhật khách hàng: " + e.getMessage();
            System.err.println("SQLException in UpdateCustomerController: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "Đã xảy ra lỗi không mong muốn khi cập nhật khách hàng: " + e.getMessage();
            e.printStackTrace();
        } finally {
            if (successMessage != null) {
                session.setAttribute("successMessage", successMessage);
            } else if (errorMessage != null) {
                session.setAttribute("errorMessage", errorMessage);
            }
            // Chuyển hướng về trang quản lý khách hàng
            response.sendRedirect(request.getContextPath() + "/customer-list");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer-list");
    }

    @Override
    public String getServletInfo() {
        return "Servlet for updating customer information.";
    }
}