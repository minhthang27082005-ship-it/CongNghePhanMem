/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package thang.itplus.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.ProductDao;
import thang.itplus.dao.UserDao;
import thang.itplus.models.Product;
import thang.itplus.models.User;

/**
 *
 * @author a4698
 */
public class RegisterController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
// Trong RegisterController.java, phương thức doPost
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // ⭐ BƯỚC 1: Lấy và CẮT KHOẢNG TRẮNG (.trim()) cho TẤT CẢ CÁC TRƯỜNG
            // Sử dụng toán tử điều kiện để tránh NullPointerException nếu getParameter trả về null
            String name = request.getParameter("name") != null ? request.getParameter("name").trim() : "";
            String email = request.getParameter("email") != null ? request.getParameter("email").trim() : "";
            String password = request.getParameter("password") != null ? request.getParameter("password").trim() : "";
            String confirmPassword = request.getParameter("confirmPassword") != null ? request.getParameter("confirmPassword").trim() : "";
            String phone = request.getParameter("phone") != null ? request.getParameter("phone").trim() : "";
            String address = request.getParameter("address") != null ? request.getParameter("address").trim() : "";

            // ⭐ BƯỚC 2: Kiểm tra dữ liệu có rỗng không (chỉ chứa khoảng trắng)
            if (name.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty() || phone.isEmpty() || address.isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin (không được chỉ chứa khoảng trắng).");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // ⭐ BƯỚC 3: Kiểm tra Định dạng Email (Sử dụng regex chỉ chấp nhận chữ cái ở TLD)
            if (!isValidEmail(email)) {
                request.setAttribute("errorMessage", "Định dạng Email không hợp lệ. Phần tên miền cuối cùng chỉ được chứa chữ cái (ví dụ: user@domain.com).");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 4. Kiểm tra Mật khẩu Khớp (Logic đã sửa)
            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 5. Kiểm tra Độ mạnh Mật khẩu (Logic đã sửa)
            if (!isPasswordStrong(password)) {
                request.setAttribute("errorMessage", "Mật khẩu phải có ít nhất 6 ký tự, bao gồm 1 chữ hoa và 1 ký tự đặc biệt (!#$&*^%...).");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            UserDao dao = new UserDao();
            if (dao.isEmailExists(email)) {
                request.setAttribute("errorMessage", "Email này đã được đăng ký.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            User newUser = new User(0, name, email, password, phone, address, User.Role.customer);
            if (dao.addUser(newUser)) {
                request.setAttribute("successMessage", "Đăng ký thành công! Hãy đăng nhập.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý đăng ký: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

// Giữ nguyên phương thức isValidEmail với regex chỉ chấp nhận chữ cái ở TLD
    private boolean isValidEmail(String email) {
        String strictEmailRegex
                = "^[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}$";
        // Lưu ý: (?:[a-zA-Z0-9-]+\.)+ cho phép nhiều cấp tên miền như subdomain.domain.com

        return email.matches(strictEmailRegex);
    }
// (Giữ nguyên phương thức isPasswordStrong)

// Trong RegisterController.java
    private boolean isPasswordStrong(String password) {
        // 1. Kiểm tra độ dài
        if (password == null || password.length() < 6) {
            return false;
        }

        // 2. PHẢI CÓ chữ hoa
        if (!password.matches(".*[A-Z].*")) {
            return false;
        }

        // 3. PHẢI CÓ ký tự đặc biệt TỪ TẬP HỢP MỚI
        // TẬP HỢP MỚI: [! @ # $ % ^ & * -] (Thêm @)
        // Dùng \\ để thoát các ký tự đặc biệt của regex trong Java String
        String specialCharRegex = ".*[\\!\\@\\#\\$\\%\\^\\&\\*\\-].*";

        if (!password.matches(specialCharRegex)) {
            return false; // Mật khẩu không chứa ký tự đặc biệt hợp lệ
        }

        return true;
    }
}
