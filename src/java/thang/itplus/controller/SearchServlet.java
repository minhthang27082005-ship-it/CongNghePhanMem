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
import java.util.List;
import thang.itplus.dao.CategoryDao;
import thang.itplus.dao.ProductDao;
import thang.itplus.models.Category;
import thang.itplus.models.Product;

/**
 *
 * @author a4698
 */
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Đảm bảo đọc tiếng Việt

        String query = request.getParameter("query"); // Lấy từ khóa tìm kiếm từ request

        ProductDao productDAO = new ProductDao(); // Khởi tạo ProductDao
        CategoryDao categoryDAO = new CategoryDao(); // Khởi tạo CategoryDao để lấy danh mục cho menu

        List<Product> searchResults = null;
        if (query != null && !query.trim().isEmpty()) {
            searchResults = productDAO.searchProducts(query); // Gọi phương thức searchProducts đã thêm vào ProductDao
        } else {
            // Nếu không có từ khóa tìm kiếm (query rỗng), bạn có thể chọn:
            // 1. Hiển thị tất cả sản phẩm:
            // searchResults = productDAO.getAllProducts();
            // 2. Hoặc không hiển thị sản phẩm nào và chỉ hiển thị thông báo
            // Ở đây, tôi để null và JSP sẽ xử lý hiển thị thông báo "Không tìm thấy"
        }

        // Lấy danh sách danh mục để hiển thị trên menu (nếu bạn có menu trong searchResults.jsp)
        List<Category> listCt = categoryDAO.getAllCategory();
        request.setAttribute("listCt", listCt); // Gửi danh sách danh mục đến JSP

        request.setAttribute("searchResults", searchResults); // Gửi kết quả tìm kiếm đến JSP
        request.setAttribute("searchQuery", query); // Để hiển thị lại từ khóa tìm kiếm trên trang kết quả

        // Chuyển hướng đến trang hiển thị kết quả tìm kiếm
        request.getRequestDispatcher("searchResults.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Với form tìm kiếm thường dùng GET để dễ chia sẻ URL kết quả.
        // Tuy nhiên, nếu form của bạn gửi bằng POST, bạn có thể gọi lại doGet ở đây.
        doGet(request, response);
    }
}
