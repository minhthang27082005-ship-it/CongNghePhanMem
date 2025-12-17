package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import thang.itplus.dao.CategoryDao;
import thang.itplus.dao.ProductDao;
import thang.itplus.dao.CarouselItemDao; // ⭐ IMPORT MỚI
import thang.itplus.models.Category;
import thang.itplus.models.Product;
import thang.itplus.models.CarouselItem; // ⭐ IMPORT MỚI

public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // 1. Dọn dẹp session (Giữ nguyên logic sửa lỗi full list)
        if (session != null) {
            session.removeAttribute("listHomeP");
            session.removeAttribute("listP");
            session.removeAttribute("products");
        }
        
        // ⭐⭐ BỔ SUNG LOGIC TẢI CAROUSEL TỪ DAO ⭐⭐
        try {
            CarouselItemDao carDao = new CarouselItemDao();
            List<CarouselItem> carouselItems = carDao.getAllItems();
            request.setAttribute("carouselItems", carouselItems); // Đặt biến carouselItems
        } catch (Exception e) {
            // Xử lý lỗi nếu không tải được carousel
            System.err.println("Lỗi khi tải Carousel: " + e.getMessage());
            request.setAttribute("carouselItems", new java.util.ArrayList<CarouselItem>()); // Đặt danh sách rỗng để tránh lỗi JSP
        }
        // **********************************************

        // 2. Tải 20 Sản phẩm MỚI NHẤT (Logic đã sửa)
        ProductDao pdDao = new ProductDao();
        List<Product> listTop20P = pdDao.getTopTwentyProducts();
        request.setAttribute("listP", listTop20P); 

        // 3. Tải Category và 4 sản phẩm cuối
        CategoryDao ctDao = new CategoryDao();
        List<Category> listCt = ctDao.getAllCategory();
        request.setAttribute("listCt", listCt);
        
        List<Product> listLastFour = pdDao.getLastFourProducts();
        request.setAttribute("lastFour", listLastFour);
        
        // 4. Forward đến home.jsp
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
    
    // ... (doPost nếu có) ...
}