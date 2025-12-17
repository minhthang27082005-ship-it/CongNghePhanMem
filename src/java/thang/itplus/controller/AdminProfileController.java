package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import thang.itplus.dao.UserDao;
import thang.itplus.models.User;

public class AdminProfileController extends HttpServlet {

    private final UserDao userDao = new UserDao();

    private void loadProfileAndForward(HttpServletRequest request, HttpServletResponse response, User currentUser) throws ServletException, IOException {
        // Đặt đối tượng User hiện tại vào request để JSP hiển thị
        request.setAttribute("adminProfile", currentUser);
        request.getRequestDispatcher("/admin-profile.jsp").forward(request, response);
    }

    // --- Xử lý GET: Hiển thị form chỉnh sửa ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        // 1. Kiểm tra quyền truy cập (Quan trọng)
        if (currentUser == null || currentUser.getRole() != User.Role.admin) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Tải lại dữ liệu mới nhất từ DB (Nếu cần)
        // Dùng selectUserById để đảm bảo thông tin user trong session không bị cũ
        User latestUser = userDao.selectUserById(currentUser.getUser_id());
        
        if (latestUser != null) {
            // Cập nhật lại session nếu thông tin mới nhất khác
            session.setAttribute("user", latestUser);
        } else {
             // Lỗi nghiêm trọng: Admin tồn tại trong session nhưng không có trong DB
             session.invalidate();
             response.sendRedirect(request.getContextPath() + "/login");
             return;
        }

        loadProfileAndForward(request, response, latestUser);
    }

    // --- Xử lý POST: Cập nhật thông tin ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRole() != User.Role.admin) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 1. Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // 2. Chuẩn bị đối tượng cập nhật
            User userToUpdate = userDao.selectUserById(currentUser.getUser_id()); 
            
            if (userToUpdate == null) {
                request.setAttribute("errorMessage", "Lỗi hệ thống: Không tìm thấy hồ sơ Admin trong CSDL.");
                loadProfileAndForward(request, response, currentUser);
                return;
            }
            
            // 3. Cập nhật các trường
            userToUpdate.setName(name != null ? name.trim() : userToUpdate.getName());
            userToUpdate.setEmail(email != null ? email.trim() : userToUpdate.getEmail());
            userToUpdate.setPhone(phone != null ? phone.trim() : userToUpdate.getPhone());
            userToUpdate.setAddress(address != null ? address.trim() : userToUpdate.getAddress());
            
            // 4. Xử lý mật khẩu (Chỉ cập nhật nếu người dùng nhập)
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
                    loadProfileAndForward(request, response, userToUpdate);
                    return;
                }
                // Thêm logic mã hóa mật khẩu ở đây nếu cần (ví dụ: BCrypt)
                userToUpdate.setPassword(newPassword.trim());
            }
            
            // 5. Gọi DAO để cập nhật
            boolean success = userDao.updateUser(userToUpdate);

            if (success) {
                // Cập nhật lại Session để dashboard hiển thị thông tin mới
                session.setAttribute("user", userToUpdate); 
                request.setAttribute("successMessage", "Cập nhật hồ sơ thành công!");
            } else {
                request.setAttribute("errorMessage", "Cập nhật hồ sơ thất bại. Vui lòng kiểm tra email đã tồn tại.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi CSDL: Không thể cập nhật thông tin.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống không xác định.");
        }
        
        // Luôn forward lại trang profile sau khi xử lý POST
        loadProfileAndForward(request, response, currentUser);
    }
}