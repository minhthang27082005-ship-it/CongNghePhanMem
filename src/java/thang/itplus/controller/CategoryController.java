package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import thang.itplus.dao.CarouselItemDao;
import thang.itplus.dao.CategoryDao;
import thang.itplus.dao.ProductDao;
import thang.itplus.models.CarouselItem;
import thang.itplus.models.Category;
import thang.itplus.models.Product;

public class CategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        ProductDao pdDao = new ProductDao();
        CategoryDao ctDao = new CategoryDao();
        
        try {
            // 1. Tải danh mục menu (cần thiết cho cả 2 trường hợp)
            List<Category> listCt = ctDao.getAllCategory();
            String categoryIdStr = request.getParameter("categoryId");
            // === DEBUG LOG ===
            System.out.println("DEBUG: Giá trị của categoryIdStr là: [" + categoryIdStr + "]");
            // =================
            request.setAttribute("listCt", listCt); 
            // 2. Kiểm tra điều kiện chính
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                // TRƯỜNG HỢP 1: LỌC SẢN PHẨM
                try {
                    int categoryId = Integer.parseInt(categoryIdStr);
                    Category selectedCategory = ctDao.getCategoryById(categoryId);
                    List<Product> products = pdDao.getProductsByCategory(categoryId);
                    String pageTitle = (selectedCategory != null) ? selectedCategory.getName() : "Sản phẩm theo danh mục";
                    request.setAttribute("products", products);
                    request.setAttribute("pageTitle", pageTitle);
                    if (selectedCategory == null) {
                        request.setAttribute("error_message", "Không tìm thấy danh mục bạn yêu cầu.");
                    }
                    // Chuyển hướng đến trang lọc
                    request.getRequestDispatcher("productlist.jsp").forward(request, response);
                    return; // *** LUÔN RETURN ĐỂ DỪNG XỬ LÝ ***  
                } catch (NumberFormatException e) {
                    // Xử lý lỗi: ID không phải số
                    request.setAttribute("pageTitle", "Lỗi Danh mục");
                    request.setAttribute("products", new java.util.ArrayList<Product>()); 
                    request.setAttribute("error_message", "ID danh mục không hợp lệ.");
                    System.out.println("❌ LỖI FORMAT ID CategoryController: " + e.toString());
                    request.getRequestDispatcher("productlist.jsp").forward(request, response);
                    return;
                } catch (Exception e) {
                    // Xử lý lỗi: Lỗi DAO/SQL trong quá trình lọc
                    request.setAttribute("pageTitle", "Lỗi Danh mục");
                    request.setAttribute("products", new java.util.ArrayList<Product>()); 
                    request.setAttribute("error_message", "Không thể tải danh mục sản phẩm. Vui lòng thử lại.");
                    System.out.println("❌ LỖI LỌC SẢN PHẨM CategoryController: " + e.toString());
                    request.getRequestDispatcher("productlist.jsp").forward(request, response);
                    return;
                }
            } else {
                // TRƯỜNG HỢP 2: Tải Trang Chủ (categoryIdStr là null hoặc rỗng)
                // Logic tải dữ liệu cho trang HOME
                List<Product> listP = pdDao.getAllProduct();
                List<Product> lastFourProducts = pdDao.getLastFourProducts();
                CarouselItemDao carouselDao = new CarouselItemDao();
                List<CarouselItem> carouselItems = carouselDao.getAllItems();
                request.setAttribute("listP", listP);
                request.setAttribute("lastFour", lastFourProducts);
                request.setAttribute("carouselItems", carouselItems);
                // CHUYỂN TIẾP ĐẾN TRANG HOME
                request.getRequestDispatcher("home.jsp").forward(request, response);
            }
        } catch (Exception e) { 
            // Lỗi nghiêm trọng (ví dụ: Không thể tải danh mục menu)
            System.out.println("LỖI CHUNG KHI TẢI DỮ LIỆU CHÍNH: " + e.toString());
            request.getRequestDispatcher("home.jsp").forward(request, response); 
        }
    }
    // ...
}