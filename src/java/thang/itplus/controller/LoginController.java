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
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp; // Bổ sung
import java.util.Calendar; // Bổ sung
import java.util.Date;     // Bổ sung
import java.util.List;
import thang.itplus.dao.CategoryDao;
import thang.itplus.dao.UserDao;
import thang.itplus.models.Category;
import thang.itplus.models.User;

/**
 *
 * @author Admin
 */
public class LoginController extends HttpServlet {

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
            out.println("<title>Servlet LoginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginController at " + request.getContextPath() + "</h1>");
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
        try {
            HttpSession session = request.getSession();
            // CHỈ XÓA SESSION NẾU CÓ LOGIC XỬ LÝ LOGOUT KHÁC
            // session.removeAttribute("users"); 
            CategoryDao ctDao = new CategoryDao();
            List<Category> listCt = ctDao.getAllCategory();
            request.setAttribute("listCt", listCt);

            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (IOException e) {
            System.out.println(e.toString());

        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Xóa khoảng trắng ở đầu và cuối (Leading/Trailing Spaces)
            if (email != null) {
                email = email.trim();
            }
            if (password != null) {
                password = password.trim();
            }

            // --- BƯỚC 1: Kiểm tra dữ liệu hợp lệ (Không trống) ---
            if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
                request.setAttribute("errorMessage", "Email và Mật khẩu không được để trống.");
                CategoryDao ctDao = new CategoryDao();
                List<Category> listCt = ctDao.getAllCategory();
                request.setAttribute("listCt", listCt);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // --- BƯỚC 2: Kiểm tra định dạng email cơ bản trên Server ---
            String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$";
            if (!email.matches(emailRegex)) {
                request.setAttribute("errorMessage", "Định dạng email không hợp lệ. Vui lòng kiểm tra lại.");
                CategoryDao ctDao = new CategoryDao();
                List<Category> listCt = ctDao.getAllCategory();
                request.setAttribute("listCt", listCt);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            System.out.println("Received email (trimmed): '" + email + "'");
            System.out.println("Received password (trimmed): '" + password + "'");

            UserDao usDao = new UserDao();

            // BƯỚC 3: Lấy User theo email để kiểm tra trạng thái khóa
            User u = usDao.getUserByEmail(email);

            if (u != null) {

                // BƯỚC 4: Kiểm tra nếu tài khoản đang bị khóa
                if (u.getLockoutUntil() != null && u.getLockoutUntil().after(new Date())) {
                    long minutesRemaining = (u.getLockoutUntil().getTime() - new Date().getTime()) / 60000;

                    request.setAttribute("errorMessage", "Tài khoản đang bị khóa. Vui lòng thử lại sau khoảng " + (minutesRemaining + 1) + " phút.");

                    CategoryDao ctDao = new CategoryDao();
                    List<Category> listCt = ctDao.getAllCategory();
                    request.setAttribute("listCt", listCt);
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                // BƯỚC 5: Kiểm tra mật khẩu
                if (u.getPassword().equals(password)) {
                    // ĐĂNG NHẬP THÀNH CÔNG: Reset số lần thử VÀ mở khóa
                    usDao.resetLoginAttemptsAndUnlock(email);

                    System.out.println("Login success: User = " + u.getName());
                    HttpSession session = request.getSession();
                    session.setAttribute("user", u);
                    session.setMaxInactiveInterval(1200);

                    // ⭐ LOGIC CHUYỂN HƯỚNG MỚI THEO VAI TRÒ (ROLE)
                    String destination;

                    if (u.getRole() == User.Role.admin) { // Kiểm tra nếu là admin
                        destination = "admin"; // Chuyển đến trang quản trị chung
                    } else if (u.getRole() == User.Role.EMPLOYEE) { // Kiểm tra nếu là nhân viên
                        // ⭐ CHUYỂN HƯỚNG TỚI CONTROLLER CỦA HỒ SƠ CÁ NHÂN
                        destination = "employee/profile"; 
                    } else { // Mặc định là customer
                        destination = "home"; // Chuyển đến trang chủ
                    }

                    response.sendRedirect(destination);
                    return;

                } else {
                    // ĐĂNG NHẬP THẤT BẠI (Sai mật khẩu)

                    // Nếu tài khoản vừa hết hạn khóa, reset attempts trước khi tăng
                    if (u.getLockoutUntil() != null && u.getLockoutUntil().before(new Date())) {
                        usDao.resetLoginAttemptsAndUnlock(email);
                        u.setLoginAttempts(0); // Cập nhật tạm thời trên đối tượng
                    }

                    usDao.increaseLoginAttempts(email); // Tăng số lần thử
                    int attempts = u.getLoginAttempts() + 1; // Số lần thử mới

                    // BƯỚC 6: Tính toán thời gian khóa (Exponential Backoff)
                    long lockDuration = 0; // Thời gian khóa (tính bằng phút)
                    if (attempts == 3) {
                        lockDuration = 1; // Khóa 1 phút sau lần sai thứ 3
                    } else if (attempts == 4) {
                        lockDuration = 5; // Khóa 5 phút sau lần sai thứ 4
                    } else if (attempts >= 5) {
                        lockDuration = 15; // Khóa 15 phút (hoặc khóa lâu hơn tùy policy) sau lần sai thứ 5
                    }

                    if (lockDuration > 0) {
                        Calendar cal = Calendar.getInstance();
                        cal.add(Calendar.MINUTE, (int) lockDuration);
                        Timestamp unlockTime = new Timestamp(cal.getTimeInMillis());

                        usDao.lockUserUntil(email, unlockTime); // Khóa tài khoản
                        request.setAttribute("errorMessage", "Sai mật khẩu! Tài khoản đã bị khóa trong " + lockDuration + " phút.");
                    } else {
                        // THAY ĐỔI: Chỉ hiển thị lỗi chung, không tiết lộ số lần thử
                        request.setAttribute("errorMessage", "Sai email hoặc mật khẩu! Vui lòng kiểm tra lại thông tin.");

                        // (Nếu muốn giữ lại số lần thử, hãy giữ lại thông báo cũ: 
                        // request.setAttribute("errorMessage", "Sai email hoặc mật khẩu! (Lần thứ " + attempts + ")");)
                    }
                }
            } else {
                // BƯỚC 7: Tài khoản không tồn tại trong DB
                request.setAttribute("errorMessage", "Sai email hoặc mật khẩu!");
            }

            // --- Load lại Category và forward về login.jsp ---
            CategoryDao ctDao = new CategoryDao();
            List<Category> listCt = ctDao.getAllCategory();
            request.setAttribute("listCt", listCt);
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
