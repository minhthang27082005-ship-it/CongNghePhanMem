package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import thang.itplus.dao.UserDao;
import thang.itplus.models.User;

/**
 * Servlet xử lý cập nhật hồ sơ cá nhân cho Khách hàng.
 * URL: /update-customer-profile
 */
@WebServlet(name = "UpdateCustomerProfileController", urlPatterns = {"/update-customer-profile"})
public class UpdateCustomerProfileController extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Thiết lập bảng mã để tránh lỗi font tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        
        // 1. Lấy thông tin User hiện tại từ Session [cite: 258, 305]
        User currentUser = (User) session.getAttribute("user");

        // Kiểm tra nếu session đã hết hạn hoặc chưa đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 2. Lấy dữ liệu từ Form (Modal trong customer_profile.jsp) [cite: 307-313]
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String newPassword = request.getParameter("newPassword");

            // 3. Cập nhật các trường thông tin cơ bản vào đối tượng User hiện tại
            if (name != null && !name.trim().isEmpty()) {
                currentUser.setName(name.trim());
            }
            currentUser.setPhone(phone != null ? phone.trim() : null);
            currentUser.setAddress(address != null ? address.trim() : null);

            // 4. Xử lý cập nhật mật khẩu (chỉ thực hiện nếu người dùng có nhập) [cite: 312]
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                // Lưu ý: Trong thực tế nên băm mật khẩu (Hash) trước khi lưu
                currentUser.setPassword(newPassword.trim());
            }

            // 5. Gọi UserDao để thực thi câu lệnh UPDATE trong Database
            // Phương thức updateUser sử dụng câu lệnh SQL: UPDATE users SET name=?, email=?, password=?, phone=?, address=?, role=? WHERE user_id=?
            boolean isUpdated = userDao.updateUser(currentUser);

            if (isUpdated) {
                // ⭐ CẬP NHẬT LẠI SESSION: Đây là bước quan trọng nhất để các trang khác (như Navbar)
                // hiển thị đúng tên và thông tin mới mà không cần đăng nhập lại.
                session.setAttribute("user", currentUser);
                session.setAttribute("successMessage", "Cập nhật hồ sơ cá nhân thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật thông tin. Vui lòng thử lại.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống (CSDL): " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi không mong muốn.");
        }

        // 6. Điều hướng quay trở lại trang Profile để người dùng xem kết quả
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    /**
     * Chặn phương thức GET: Nếu người dùng truy cập trực tiếp URL này, chuyển hướng về Profile.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}