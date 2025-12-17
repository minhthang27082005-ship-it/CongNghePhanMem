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
import thang.itplus.models.Cart;
import thang.itplus.models.Product;

/**
 *
 * @author a4698
 */
public class DeleteCartController extends HttpServlet {

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
            out.println("<title>Servlet DeleteCartController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteCartController at " + request.getContextPath() + "</h1>");
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
            int productId = Integer.parseInt(request.getParameter("productId"));
            HttpSession session = request.getSession();

            // Lấy giỏ hàng từ session
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null) {
                // Tạo sản phẩm mới dựa trên ID
                Product product = new Product();
                product.setProduct_id(productId); // Set ID sản phẩm

                // Xóa sản phẩm khỏi giỏ hàng
                cart.removeItem(product);

                // Cập nhật lại giỏ hàng trong session
                session.setAttribute("cart", cart);

                // Tính lại tổng tiền sau khi xóa sản phẩm
                double totalPrice = cart.calculateTotalPrice();
                session.setAttribute("totalPrice", totalPrice); // Lưu totalPrice vào session
            }

            // Sau khi xóa sản phẩm, chuyển hướng lại đến trang giỏ hàng
            response.sendRedirect("cart.jsp");

        } catch (NumberFormatException e) {
            e.printStackTrace(); // In ra lỗi nếu ID không hợp lệ
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
        processRequest(request, response);
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
