// EmployeeCustomerController.java (PHIÊN BẢN HOÀN CHỈNH)

package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import thang.itplus.dao.OrderDao;
import thang.itplus.dao.UserDao;
import thang.itplus.models.Order;
import thang.itplus.models.User;
import thang.itplus.models.User.Role;

@WebServlet(name = "EmployeeCustomerController", urlPatterns = {"/employee/customers", "/employee/customer-history"})
public class EmployeeCustomerController extends HttpServlet {

    private final UserDao userDao = new UserDao();
    private final OrderDao orderDao = new OrderDao(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String servletPath = request.getServletPath();

        // Kiểm tra phân quyền
        if (currentUser == null || currentUser.getRole() != Role.EMPLOYEE) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Truy cập bị từ chối.");
            return;
        }

        try {
            if ("/employee/customers".equals(servletPath)) {
                
                String searchType = request.getParameter("searchType");
                String keyword = request.getParameter("keyword");
                List<User> customerList = null;
                
                // ⭐ BIẾN LƯU TRỮ TRẠNG THÁI CUỐI CÙNG
                String lastKeyword = (String) session.getAttribute("lastKeyword");
                String lastSearchType = (String) session.getAttribute("lastSearchType");
                
                if (keyword != null && !keyword.trim().isEmpty()) {
                    // ⭐ TRƯỜNG HỢP 1: THỰC HIỆN TÌM KIẾM MỚI HỢP LỆ
                    keyword = keyword.trim();
                    searchType = searchType != null ? searchType : "phone"; 
                    
                    // Thực hiện tìm kiếm
                    if ("phone".equals(searchType)) {
                        String cleanedKeyword = keyword.replaceAll("\\s+", ""); 
                        User customer = userDao.getUserByPhoneAndRole(cleanedKeyword, Role.customer);
                        if (customer != null) {
                            customerList = List.of(customer);
                        }
                    } else if ("name".equals(searchType)) {
                        customerList = userDao.getCustomersByName(keyword);
                    }
                    
                    // Lưu kết quả vào Session (Flash Attributes)
                    session.setAttribute("savedCustomerList", customerList);
                    session.setAttribute("lastSearchType", searchType);
                    session.setAttribute("lastKeyword", keyword);
                    
                    if (customerList == null || customerList.isEmpty()) {
                        session.setAttribute("warningMessage", "Không tìm thấy khách hàng nào với từ khóa: " + keyword);
                    } else {
                        session.removeAttribute("warningMessage");
                    }
                    
                    // CHUYỂN HƯỚNG để làm sạch request parameters
                    response.sendRedirect(request.getContextPath() + "/employee/customers");
                    return;
                    
                } else {
                    // ⭐ TRƯỜNG HỢP 2/3: TẢI LẠI TRANG (Sau Redirect, Sidebar, History)
                    
                    // Tải lại kết quả tìm kiếm (customerList)
                    if (session.getAttribute("savedCustomerList") != null) {
                         customerList = (List<User>) session.getAttribute("savedCustomerList");
                    }
                    
                    // ⭐ Đảm bảo Form luôn hiển thị giá trị cuối cùng đã nhập
                    if (lastKeyword != null) {
                        request.setAttribute("currentKeyword", lastKeyword);
                    }
                    if (lastSearchType != null) {
                        request.setAttribute("currentSearchType", lastSearchType);
                    }
                    
                    // Chuyển Warning Message từ Session sang Request (Flash)
                    if (session.getAttribute("warningMessage") != null) {
                        request.setAttribute("warningMessage", session.getAttribute("warningMessage"));
                        session.removeAttribute("warningMessage"); 
                    }
                    
                    // Trường hợp người dùng xóa keyword và tìm kiếm rỗng/Lần đầu vào
                    if (keyword != null && keyword.trim().isEmpty()) {
                        session.removeAttribute("savedCustomerList");
                        session.removeAttribute("lastKeyword");
                        session.removeAttribute("lastSearchType");
                        request.setAttribute("warningMessage", "Vui lòng nhập từ khóa tìm kiếm.");
                    }
                }
                
                request.setAttribute("customerList", customerList);
                request.setAttribute("pageTitle", "Quản lý Khách hàng");
                request.setAttribute("contentPage", "customer_management_emp.jsp");
                
            } else if ("/employee/customer-history".equals(servletPath)) {
                // ... (Logic xử lý history giữ nguyên) ...
                
                String userIdStr = request.getParameter("userId");
                if (userIdStr != null) {
                    int userId = Integer.parseInt(userIdStr);
                    User customer = userDao.selectUserById(userId); 
                    // Cần đảm bảo OrderDao.getOrdersByUserId không gây lỗi SQL.
                    List<Order> orderHistory = orderDao.getOrdersByUserId(userId); 

                    request.setAttribute("customer", customer);
                    request.setAttribute("orderHistory", orderHistory);
                }
                
                request.setAttribute("pageTitle", "Lịch sử mua hàng");
                request.setAttribute("contentPage", "customer_history_emp.jsp");
            }
            
            // LUÔN FORWARD KHI XỬ LÝ THÀNH CÔNG
            request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // ⭐ XỬ LÝ LỖI VÀ REDIRECT + RETURN
            session.setAttribute("errorMessage", "ID Khách hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/employee/customers"); 
            return; 
        } catch (Exception e) {
            // ⭐ XỬ LÝ LỖI CHUNG VÀ REDIRECT + RETURN
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi CSDL hoặc lỗi không xác định. Chi tiết lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/employee/customers");
            return; 
        }
    }
}