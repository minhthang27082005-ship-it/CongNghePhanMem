package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import thang.itplus.dao.CustomerDAO;
import thang.itplus.models.User;

@WebServlet(name = "AddCustomerController", urlPatterns = {"/add-customer"})
public class AddCustomerController extends HttpServlet {

    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String errorMessage = null;
        String successMessage = null;

        try {
            String idParam = request.getParameter("id");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String roleStr = request.getParameter("role");

            int id = 0;

            if (idParam == null || idParam.trim().isEmpty()) {
                errorMessage = "ID là trường bắt buộc.";
            } else {
                try {
                    id = Integer.parseInt(idParam);
                    if (id <= 0) {
                        errorMessage = "ID phải là số nguyên dương.";
                    }
                } catch (NumberFormatException e) {
                    errorMessage = "ID không hợp lệ. Vui lòng nhập một số nguyên.";
                }
            }

            if (name == null || name.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()) {
                errorMessage = "Tên, Email và Mật khẩu là các trường bắt buộc.";
            }

            User.Role role = null;
            if (roleStr == null || roleStr.trim().isEmpty()) {
                errorMessage = "Vai trò là trường bắt buộc.";
            } else {
                try {
                    role = User.Role.valueOf(roleStr);
                } catch (IllegalArgumentException e) {
                    errorMessage = "Vai trò không hợp lệ.";
                    System.err.println("Lỗi vai trò: " + roleStr + " không hợp lệ.");
                    e.printStackTrace();
                }
            }

            if (errorMessage == null) {
                User newUser = new User(id, name.trim(), email.trim(), password.trim(),
                        (phone != null ? phone.trim() : null),
                        (address != null ? address.trim() : null),
                        role);

                customerDAO.insertUser(newUser);
                successMessage = "Thêm khách hàng '" + name + "' thành công!";
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate entry") || e.getErrorCode() == 1062) {
                errorMessage = "ID '" + request.getParameter("id") + "' đã tồn tại. Vui lòng chọn ID khác.";
            } else {
                errorMessage = "Lỗi CSDL khi thêm khách hàng: " + e.getMessage();
            }
            System.err.println("SQLException in AddCustomerController: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "Đã xảy ra lỗi không mong muốn khi thêm khách hàng: " + e.getMessage();
            System.err.println("General Exception in AddCustomerController: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (successMessage != null) {
                session.setAttribute("successMessage", successMessage);
            } else if (errorMessage != null) {
                session.setAttribute("errorMessage", errorMessage);
            }
            User currentUser = (User) session.getAttribute("user");
            if (currentUser != null && currentUser.getRole() == User.Role.EMPLOYEE) {
                // Nếu là nhân viên, quay về trang quản lý của nhân viên
                response.sendRedirect(request.getContextPath() + "/employee/customers");
            } else {
                // Nếu là admin, quay về trang mặc định của admin
                response.sendRedirect(request.getContextPath() + "/customer-list");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer-list");
    }

    @Override
    public String getServletInfo() {
        return "Servlet for adding new customer information.";
    }
}
