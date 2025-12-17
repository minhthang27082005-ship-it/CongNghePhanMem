package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.ProductDao; // Đảm bảo ProductDao được import
import thang.itplus.models.Product; // Đảm bảo Product model được import

@WebServlet(name = "UpdateProductController", urlPatterns = {"/updateproduct"})
public class UpdateProductController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String errorMessage = null;
        String successMessage = null;
        ProductDao productDao = new ProductDao();

        try {
            // Lấy productId từ form (Đây là trường bắt buộc để biết sản phẩm nào cần sửa)
            String productIdStr = request.getParameter("productId");

            if (productIdStr == null || productIdStr.isEmpty()) {
                errorMessage = "Không tìm thấy ID sản phẩm để cập nhật.";
            } else {
                int productId = Integer.parseInt(productIdStr);

                // 1. Lấy thông tin sản phẩm hiện tại từ database
                Product existingProduct = productDao.getProductById(productId); // Giả định bạn có phương thức này

                if (existingProduct == null) {
                    errorMessage = "Sản phẩm với ID " + productId + " không tồn tại.";
                } else {
                    // 2. Cập nhật các trường nếu chúng được gửi từ form
                    // Tên
                    String name = request.getParameter("name");
                    if (name != null && !name.trim().isEmpty()) {
                        existingProduct.setName(name.trim());
                    }

                    // Giá
                    String priceStr = request.getParameter("price"); // Đã sửa từ "Parameter" thành "price"
                    if (priceStr != null && !priceStr.trim().isEmpty()) {
                        try {
                            existingProduct.setPrice(Double.parseDouble(priceStr.trim()));
                        } catch (NumberFormatException e) {
                            errorMessage = "Giá không hợp lệ. Vui lòng nhập số.";
                        }
                    }

                    // Số lượng tồn kho
                    String stockStr = request.getParameter("stock");
                    if (stockStr != null && !stockStr.trim().isEmpty()) {
                        try {
                            existingProduct.setStock(Integer.parseInt(stockStr.trim()));
                        } catch (NumberFormatException e) {
                            errorMessage = "Số lượng tồn không hợp lệ. Vui lòng nhập số nguyên.";
                        }
                    }

                    // Mô tả
                    String description = request.getParameter("description");
                    if (description != null) { // Mô tả có thể là chuỗi rỗng
                        existingProduct.setDescription(description.trim());
                    }

                    // Hình ảnh
                    String image = request.getParameter("image");
                    if (image != null) { // Image có thể là chuỗi rỗng
                        existingProduct.setImage(image.trim());
                    }

                    // Category ID (ít khi sửa qua modal, nhưng vẫn xử lý nếu có)
                    // Nếu bạn có dropdown Category trên modal, bạn có thể gửi CategoryId lên
                    String categoryIdStr = request.getParameter("categoryId");
                    if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                        try {
                            existingProduct.setCategory_id(Integer.parseInt(categoryIdStr.trim()));
                        } catch (NumberFormatException e) {
                            // Không bắt buộc phải báo lỗi nghiêm trọng nếu không có categoryId mới,
                            // hoặc bạn có thể đặt mặc định
                        }
                    }

                    // Nếu không có lỗi nào từ việc parse các trường số
                    if (errorMessage == null) {
                        // 3. Cập nhật sản phẩm vào cơ sở dữ liệu
                        boolean updateSuccess = productDao.updateProductById(existingProduct);

                        if (updateSuccess) {
                            successMessage = "Cập nhật sản phẩm " + existingProduct.getName() + " thành công!";
                        } else {
                            errorMessage = "Cập nhật sản phẩm " + existingProduct.getName() + " không thành công! Có thể lỗi CSDL.";
                        }
                    }
                }
            }
        } catch (NumberFormatException e) {
            errorMessage = "Lỗi định dạng số: ID sản phẩm không hợp lệ.";
            System.err.println("NumberFormatException in UpdateProductController: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "Lỗi không mong muốn đã xảy ra: " + e.getMessage();
            System.err.println("General Exception in UpdateProductController: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Đặt thông báo vào session và redirect về listproducts
            if (successMessage != null) {
                request.getSession().setAttribute("successMessage", successMessage);
            } else if (errorMessage != null) {
                request.getSession().setAttribute("errorMessage", errorMessage);
            }
            response.sendRedirect("listproducts");
        }
    }

    // doGet có thể giữ nguyên hoặc chỉ chuyển hướng về listproducts
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("listproducts");
    }

    @Override
    public String getServletInfo() {
        return "Servlet for updating product information.";
    }
}
