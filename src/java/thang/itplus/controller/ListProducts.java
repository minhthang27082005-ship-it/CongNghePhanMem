package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Quan trọng: Thêm annotation WebServlet
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Đảm bảo import HttpSession
import java.io.IOException;
import java.util.List;
import thang.itplus.dao.ProductDao;
import thang.itplus.models.Product;
import thang.itplus.models.User; // Đảm bảo User class được import

@WebServlet(name = "ListProducts", urlPatterns = {"/listproducts"}) // Thêm annotation để servlet tự động map
public class ListProducts extends HttpServlet {

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
        
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("user");

        if (u != null) {
            try {
                ProductDao pdDao = new ProductDao();
                List<Product> listP = pdDao.getAllProduct(); // Lấy sản phẩm

                if (listP == null) { // Đảm bảo listP không bao giờ là null
                    listP = new java.util.ArrayList<>();
                }

                request.setAttribute("listP", listP); // Luôn đặt listP vào request scope

                // Lấy thông báo từ session (nếu có) và đặt vào request scope
                String successMessage = (String) session.getAttribute("successMessage");
                String errorMessage = (String) session.getAttribute("errorMessage");

                if (successMessage != null) {
                    request.setAttribute("successMessage", successMessage);
                    session.removeAttribute("successMessage"); // Xóa khỏi session sau khi lấy
                }
                if (errorMessage != null) {
                    request.setAttribute("errorMessage", errorMessage);
                    session.removeAttribute("errorMessage"); // Xóa khỏi session sau khi lấy
                }

                if (listP.isEmpty()) {
                    System.out.println("Không có sản phẩm nào trong cơ sở dữ liệu.");
                } else {
                    System.out.println("Lấy được sản phẩm thành công! Số sản phẩm: " + listP.size());
                }

                 // In username để debug
                request.getRequestDispatcher("qlsp.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println("Exception rồi: " + e.getMessage()); // In lỗi cụ thể
                e.printStackTrace(); // In stack trace để debug
                request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu sản phẩm: " + e.getMessage());
                request.getRequestDispatcher("qlsp.jsp").forward(request, response);
            }
        } else {
            System.out.println("User null. Chuyển hướng về trang chủ.");
            response.sendRedirect("home"); // Redirect nếu user null
        }
    }

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
        processRequest(request, response);
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
        return "Servlet for listing products and handling messages.";
    }
}