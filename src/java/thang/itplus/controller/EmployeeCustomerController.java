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

@WebServlet(name = "EmployeeCustomerController", urlPatterns = {"/employee/customers", "/employee/customer-history", "/customer-list", "/admin/customer-history"})
public class EmployeeCustomerController extends HttpServlet {

    private final UserDao userDao = new UserDao();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String servletPath = request.getServletPath();

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if ("/customer-list".equals(servletPath)) {
                handleAdminSearch(request, response);
            } 
            else if ("/admin/customer-history".equals(servletPath)) {
                String userIdStr = request.getParameter("userId");
                if (userIdStr != null) {
                    int userId = Integer.parseInt(userIdStr);
                    request.setAttribute("customer", userDao.selectUserById(userId));
                    request.setAttribute("orderHistory", orderDao.getOrdersByUserId(userId));
                    request.setAttribute("isHistoryView", true);
                }
                request.getRequestDispatcher("/customer.jsp").forward(request, response);
            }
            else if ("/employee/customers".equals(servletPath)) {
                handleEmployeeSearchLogic(request, response, session);
            } 
            else if ("/employee/customer-history".equals(servletPath)) {
                handleViewHistory(request, response, "/employee_layout.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer-list");
        }
    }

    private void handleAdminSearch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchType = request.getParameter("searchType");
        String keyword = request.getParameter("keyword");
        List<User> listCustomers;

        if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();
            if ("phone".equals(searchType)) {
                String cleanedKeyword = keyword.replaceAll("\\s+", ""); 
                User customer = userDao.getUserByPhoneAndRole(cleanedKeyword, Role.customer);
                listCustomers = (customer != null) ? List.of(customer) : List.of();
            } else {
                listCustomers = userDao.getCustomersByName(keyword);
            }
            
            // Thông báo nếu không tìm thấy kết quả
            if (listCustomers.isEmpty()) {
                request.setAttribute("warningMessage", "Không tìm thấy khách hàng nào phù hợp với từ khóa: " + keyword);
                // Nạp lại toàn bộ danh sách để người dùng không thấy bảng trống
                listCustomers = userDao.selectAllUsersByRole(Role.customer);
            }
        } else {
            listCustomers = userDao.selectAllUsersByRole(Role.customer);
        }

        request.setAttribute("listCustomers", listCustomers);
        request.setAttribute("isHistoryView", false);
        request.getRequestDispatcher("/customer.jsp").forward(request, response);
    }

    private void handleEmployeeSearchLogic(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
        String searchType = request.getParameter("searchType");
        String keyword = request.getParameter("keyword");
        List<User> customerList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();
            if ("phone".equals(searchType)) {
                User c = userDao.getUserByPhoneAndRole(keyword, Role.customer);
                customerList = (c != null) ? List.of(c) : List.of();
            } else {
                customerList = userDao.getCustomersByName(keyword);
            }
            if (customerList == null || customerList.isEmpty()) {
                request.setAttribute("warningMessage", "Không tìm thấy khách hàng.");
                customerList = userDao.selectAllUsersByRole(Role.customer);
            }
        } else {
            customerList = userDao.selectAllUsersByRole(Role.customer);
        }
        request.setAttribute("customerList", customerList);
        request.setAttribute("contentPage", "customer_management_emp.jsp");
        request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);
    }

    private void handleViewHistory(HttpServletRequest request, HttpServletResponse response, String target) 
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null) {
            int userId = Integer.parseInt(userIdStr);
            request.setAttribute("customer", userDao.selectUserById(userId));
            request.setAttribute("orderHistory", orderDao.getOrdersByUserId(userId));
        }
        if (target.contains("layout")) {
            request.setAttribute("contentPage", "customer_history_emp.jsp");
        }
        request.getRequestDispatcher(target).forward(request, response);
    }
}