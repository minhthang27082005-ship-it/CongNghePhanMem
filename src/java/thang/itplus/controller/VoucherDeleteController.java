package thang.itplus.controller;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import thang.itplus.dao.VoucherDao;
import thang.itplus.models.User.Role;

@WebServlet(name = "VoucherDeleteController", urlPatterns = {"/vouchersdelete"})
public class VoucherDeleteController extends HttpServlet {

    private VoucherDao voucherDao;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.voucherDao = new VoucherDao();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo VoucherDao.", e);
        }
    }

    // ⭐ ĐÃ SỬA: Đổi tên thành checkAdminRole và CHỈ cấp quyền cho Admin
    private boolean checkAdminRole(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        Object userObj = request.getSession().getAttribute("user");
        if (userObj == null) { response.sendRedirect(request.getContextPath() + "/login"); return false; }
        Role role = ((thang.itplus.models.User) userObj).getRole();
        
        // ⭐ LOGIC MỚI: CHỈ Cho phép nếu là admin
        if (role != Role.admin) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Quyền truy cập chỉ dành cho Admin.");
            return false;
        }
        return true;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdminRole(request, response)) { // Cập nhật tên hàm gọi
            return;
        }
        
        HttpSession session = request.getSession();
        String redirectUrl = request.getContextPath() + "/voucherslist";

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = voucherDao.deleteVoucher(id);
            if (success) {
                session.setAttribute("successMessage", "Xóa mã giảm giá thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể xóa mã giảm giá. (Có thể mã đang được sử dụng).");
            }
        } catch (NumberFormatException e) {
             session.setAttribute("errorMessage", "ID mã giảm giá không hợp lệ.");
        } catch (Exception e) {
             e.printStackTrace();
             session.setAttribute("errorMessage", "Lỗi không xác định: " + e.getMessage());
        }
        
        response.sendRedirect(redirectUrl); 
    }
}