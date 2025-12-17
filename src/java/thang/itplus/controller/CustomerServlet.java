package thang.itplus.controller;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Import HttpSession
import java.sql.SQLException;
import java.util.List;
import thang.itplus.dao.CustomerDAO;
import thang.itplus.models.User;
import com.google.gson.Gson; 


public class CustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;

    public void init() {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            listCustomer(request, response);
        } catch (SQLException ex) {
            System.err.println("Lỗi CSDL khi lấy danh sách khách hàng trong CustomerServlet: " + ex.getMessage());
            ex.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải danh sách khách hàng từ CSDL. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/customer-list");
        } catch (Exception ex) {
            System.err.println("Lỗi không mong muốn trong doGet của CustomerServlet: " + ex.getMessage());
            ex.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi không mong muốn khi tải danh sách khách hàng. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/customer-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer-list");
    }

    private void listCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<User> listCustomers = customerDAO.selectAllCustomers();
        request.setAttribute("listCustomers", listCustomers);
        RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
        dispatcher.forward(request, response);
    }
}