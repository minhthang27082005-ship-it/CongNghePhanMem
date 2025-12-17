/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package thang.itplus.controller;
import thang.itplus.dao.ProductDao;
import thang.itplus.models.Product;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet; // Import annotation này

/**
 *
 * @author a4698
 */
public class ProductDetailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ProductDao productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDao();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");
        int productId =0;
        Product product = null;

        if (productIdStr != null && !productIdStr.isEmpty()) {
            try {
                productId = Integer.parseInt(productIdStr);
                product = productDAO.getProductById(productId);
            } catch (NumberFormatException e) {
                System.err.println("Invalid product ID format: " + productIdStr);
                request.setAttribute("errorMessage", "Mã sản phẩm không hợp lệ.");
            }
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy mã sản phẩm.");
        }

        if (product != null) {
            request.setAttribute("product", product);
            request.getRequestDispatcher("/product_detail.jsp").forward(request, response);
        } else {
            if (request.getAttribute("errorMessage") == null) {
                 request.setAttribute("errorMessage", "Sản phẩm không tìm thấy.");
            }
            // Chuyển hướng đến trang lỗi
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}