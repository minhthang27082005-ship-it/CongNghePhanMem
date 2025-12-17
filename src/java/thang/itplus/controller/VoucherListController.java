package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; 
import java.util.List;
import thang.itplus.dao.VoucherDao;
import thang.itplus.models.Voucher;
import thang.itplus.models.User;
import thang.itplus.models.User.Role; // Cần import Role để tạo mock user

@WebServlet(name = "VoucherListController", urlPatterns = {"/voucherslist"})
public class VoucherListController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("user");

        // ⭐ KHỐI MOCK USER ĐỂ DEBUG (CHỈ SỬ DỤNG KHI DEBUG)
        // Khi bạn muốn chạy trực tiếp Controller mà không cần login qua form:
        if (u == null) {
            System.out.println("DEBUG MODE: MOCKING ADMIN USER.");
            // Tạo một đối tượng User giả
            u = new User();
            u.setName("debug_admin");
            // Gán vai trò admin để nếu có logic kiểm tra role sau này, nó vẫn chạy qua
            u.setRole(Role.admin); 
            session.setAttribute("user", u);
        }
        // ⭐ KẾT THÚC KHỐI MOCK USER ⭐


        // 1. KIỂM TRA ĐĂNG NHẬP (Lúc này u sẽ khác null)
        if (u != null) {
            
            try {
                // Đặt breakpoint ở dòng này: ⬇️
                VoucherDao voucherDao = new VoucherDao(); 
                
                // LẤY DỮ LIỆU TỪ DAO
                List<Voucher> lsV = voucherDao.getAllVouchers();

                if (lsV == null) { 
                    lsV = new java.util.ArrayList<>();
                }
                
                // XỬ LÝ THÔNG BÁO TỪ SESSION
                String successMessage = (String) session.getAttribute("successMessage");
                String errorMessage = (String) session.getAttribute("errorMessage");

                if (successMessage != null) {
                    request.setAttribute("successMessage", successMessage);
                    session.removeAttribute("successMessage");
                }
                if (errorMessage != null) {
                    request.setAttribute("errorMessage", errorMessage);
                    session.removeAttribute("errorMessage");
                }

                // ĐẶT DỮ LIỆU VÀ LOGGING
                request.setAttribute("listVouchers", lsV);
                
                if (lsV.isEmpty()) {
                    System.out.println("Không có mã giảm giá nào trong cơ sở dữ liệu.");
                } else {
                    System.out.println("Lấy được mã giảm giá thành công! Số mã: " + lsV.size());
                }

                // CHUYỂN TIẾP ĐẾN JSP
                request.getRequestDispatcher("QLVoucher.jsp").forward(request, response);
                
            } catch (Exception e) { 
                System.out.println("Exception rồi: " + e.getMessage());
                e.printStackTrace();
                
                // Xử lý lỗi hệ thống khi tải dữ liệu
                request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu Voucher: " + e.getMessage());
                request.getRequestDispatcher("QLVoucher.jsp").forward(request, response);
            }
            
        } else {
            // Dòng này chỉ chạy nếu mock user thất bại
            System.out.println("User null. Chuyển hướng về trang chủ.");
            response.sendRedirect(request.getContextPath() + "/home"); 
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet for listing vouchers and handling messages.";
    }
}