package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import thang.itplus.dao.ProductDao;
import thang.itplus.dao.InventoryDao;
import thang.itplus.models.Product;
import thang.itplus.models.InventoryTransaction;
import thang.itplus.models.User;

@WebServlet(name = "ListProducts", urlPatterns = {"/listproducts"})
public class ListProducts extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("user");

        if (u != null) {
            try {
                ProductDao pdDao = new ProductDao();
                InventoryDao invDao = new InventoryDao();

                // Lấy tham số xác định chế độ xem
                String mode = request.getParameter("mode");
                
                if ("history".equals(mode)) {
                    // Chế độ xem lịch sử kho
                    List<InventoryTransaction> historyList = invDao.getHistory(null, null);
                    request.setAttribute("historyList", historyList);
                    request.setAttribute("isInventoryHistoryView", true);
                } else {
                    // Chế độ xem danh sách sản phẩm mặc định
                    List<Product> listP = pdDao.getAllProduct();
                    request.setAttribute("listP", listP != null ? listP : new java.util.ArrayList<>());
                    request.setAttribute("isInventoryHistoryView", false);
                }

                // Xử lý thông báo [cite: 68, 69, 146]
                String successMessage = (String) session.getAttribute("successMessage");
                String errorMessage = (String) session.getAttribute("errorMessage");
                if (successMessage != null) { request.setAttribute("successMessage", successMessage); session.removeAttribute("successMessage"); }
                if (errorMessage != null) { request.setAttribute("errorMessage", errorMessage); session.removeAttribute("errorMessage"); }

                request.getRequestDispatcher("qlsp.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi tải dữ liệu: " + e.getMessage());
                request.getRequestDispatcher("qlsp.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
}