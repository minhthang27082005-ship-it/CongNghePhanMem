package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.SupplierDao;

import java.io.IOException;

@WebServlet(name = "SupplierDeleteController", urlPatterns = {"/delete-supplier"})
public class SupplierDeleteController extends HttpServlet {

    private SupplierDao supplierDao = new SupplierDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy ID nhà cung cấp từ hidden input trong form xóa
            int supplierId = Integer.parseInt(request.getParameter("id")); 
            
            boolean success = supplierDao.deleteSupplier(supplierId); 

            if (success) {
                request.getSession().setAttribute("successMessage", "Xóa nhà cung cấp ID " + supplierId + " thành công!");
            } else {
                // Thất bại thường xảy ra do ràng buộc Khóa ngoại (Foreign Key Constraint)
                request.getSession().setAttribute("errorMessage", "Xóa nhà cung cấp ID " + supplierId + " thất bại. (Có thể do còn sản phẩm liên kết)");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Lỗi: ID nhà cung cấp không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi khi xóa nhà cung cấp: " + e.getMessage());
        }
        
        // Chuyển hướng về trang danh sách
        response.sendRedirect(request.getContextPath() + "/supplierlist"); 
    }
}