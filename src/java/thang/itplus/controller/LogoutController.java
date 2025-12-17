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

/**
 *
 * @author a4698
 */
public class LogoutController extends HttpServlet {

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
            out.println("<title>Servlet LogoutController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LogoutController at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession(false); // Lấy session hiện tại, KHÔNG tạo session mới nếu chưa có

        if (session != null) {
            session.invalidate(); // Hủy bỏ session hiện tại. Điều này sẽ xóa 'sessionScope.user'
            System.out.println("Session invalidated successfully for logout."); // Log để kiểm tra
        }

        // Chuyển hướng người dùng về trang chủ hoặc trang đăng nhập.
        // Khi home.jsp hoặc login.jsp được tải lại, sessionScope.user sẽ là null,
        // và giao diện sẽ hiển thị nút Login/Register.
        response.sendRedirect("home"); // Chuyển về trang chủ, nơi có navbar
        // Hoặc response.sendRedirect("login"); // Chuyển về trang login
    }

    // Nếu bạn muốn logout cũng hoạt động với POST request (ít phổ biến cho logout)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Logout Servlet handles user logout by invalidating the session.";
    }

}
