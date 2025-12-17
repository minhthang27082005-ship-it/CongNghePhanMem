package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import thang.itplus.dao.ProductDao;
import thang.itplus.models.Product;
import thang.itplus.dao.CategoryDao; // Cần lấy danh mục cho Menu

@WebServlet(name = "AllProductsController", urlPatterns = {"/allproducts"})
public class AllProductsController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Lấy danh mục cho menu (giống như HomeController)
            CategoryDao ctDao = new CategoryDao();
            request.setAttribute("listCt", ctDao.getAllCategory());
            
            // Lấy TẤT CẢ SẢN PHẨM
            ProductDao pdDao = new ProductDao();
            List<Product> listAllP = pdDao.getAllProduct();

            // Đặt danh sách TẤT CẢ sản phẩm vào request scope
            request.setAttribute("listAllP", listAllP); 

            // Chuyển hướng đến trang JSP mới
            request.getRequestDispatcher("allproducts.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response); // Giả sử có trang error.jsp
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
}   