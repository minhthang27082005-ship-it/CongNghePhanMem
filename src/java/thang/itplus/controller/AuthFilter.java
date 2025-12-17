package thang.itplus.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import thang.itplus.models.User;
import thang.itplus.models.User.Role;

// ⭐ Filter này sẽ áp dụng cho tất cả các URL quản trị
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin", "/orderlist", "/listproducts", "/employeelist", "/supplierlist", "/voucherslist"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false); // Không tạo session mới nếu chưa có

        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        // Kiểm tra xem URL yêu cầu có phải là khu vực quản trị không
        String path = req.getRequestURI().substring(req.getContextPath().length());

        // 1. Kiểm tra Đăng nhập
        if (user == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang Login
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để truy cập trang quản trị.");
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Kiểm tra Vai trò (Role)
        // Nếu người dùng không phải là ADMIN:
        if (user.getRole() != Role.admin) {
            
            // Xử lý quyền hạn cụ thể cho EMPLOYEE:
            if (user.getRole() == Role.EMPLOYEE) {
                // Cho phép EMPLOYEE truy cập trang riêng của họ (ví dụ: employeelist và dashboard)
                if (path.startsWith("/employee") || path.startsWith("/employeelist")) {
                    chain.doFilter(request, response); // Cho phép đi tiếp
                    return;
                }
            }
            
            // Chặn tất cả các trang quản trị còn lại (admin, orderlist, listproducts, v.v.)
            session.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này.");
            
            // Chuyển hướng người dùng về trang mặc định của họ
            if (user.getRole() == Role.EMPLOYEE) {
                 res.sendRedirect(req.getContextPath() + "/employee_dashboard.jsp"); 
            } else {
                 res.sendRedirect(req.getContextPath() + "/home");
            }
            return;
        }

        // 3. Nếu là Admin, cho phép truy cập
        chain.doFilter(request, response);
    }
    
    // Khởi tạo/Hủy filter (Không cần code)
    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }
    @Override
    public void destroy() { }
}