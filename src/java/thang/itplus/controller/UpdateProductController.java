package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.ProductDao;
import thang.itplus.dao.InventoryDao; // Import thêm InventoryDao
import thang.itplus.models.Product;
import thang.itplus.models.User;

@WebServlet(name = "UpdateProductController", urlPatterns = {"/updateproduct"})
public class UpdateProductController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        ProductDao productDao = new ProductDao();
        InventoryDao inventoryDao = new InventoryDao();
        User currentUser = (User) request.getSession().getAttribute("user");

        try {
            String productIdStr = request.getParameter("productId");
            if (productIdStr != null && !productIdStr.isEmpty()) {
                int productId = Integer.parseInt(productIdStr);
                Product existingProduct = productDao.getProductById(productId);

                if (existingProduct != null) {
                    int oldStock = existingProduct.getStock(); // Lưu lại số lượng cũ trước khi sửa
                    
                    // Lấy dữ liệu từ Form
                    existingProduct.setName(request.getParameter("name").trim());
                    existingProduct.setPrice(Double.parseDouble(request.getParameter("price")));
                    int newStock = Integer.parseInt(request.getParameter("stock"));
                    existingProduct.setStock(newStock);
                    existingProduct.setImage(request.getParameter("image").trim());
                    existingProduct.setDescription(request.getParameter("description").trim());

                    boolean updateSuccess = productDao.updateProductById(existingProduct);

                    if (updateSuccess) {
                        // Tự động ghi lịch sử nếu số lượng có sự thay đổi
                        if (newStock != oldStock) {
                            int diff = newStock - oldStock;
                            String type = (diff > 0) ? "NHAP" : "XUAT";
                            // Ghi nhận giao dịch kho với trị tuyệt đối của hiệu số
                            inventoryDao.recordTransaction(productId, Math.abs(diff), type, currentUser.getUser_id());
                        }
                        request.getSession().setAttribute("successMessage", "Cập nhật sản phẩm và ghi nhận lịch sử kho thành công!");
                    }
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Lỗi cập nhật: " + e.getMessage());
        }
        response.sendRedirect("listproducts");
    }
}