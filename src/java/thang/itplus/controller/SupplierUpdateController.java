package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.SupplierDao;
import thang.itplus.models.Supplier;

import java.io.IOException;

@WebServlet(name = "SupplierUpdateController", urlPatterns = {"/update-supplier"})
public class SupplierUpdateController extends HttpServlet {

    private SupplierDao supplierDao = new SupplierDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); 

        try {
            // Lấy tất cả thông tin từ form, bao gồm cả ID
            int supplierId = Integer.parseInt(request.getParameter("supplier_id")); 
            String supplierName = request.getParameter("supplier_name"); 
            String contactName = request.getParameter("contact_name");
            String phoneNumber = request.getParameter("phone_number");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String country = request.getParameter("country");
            
            // Tạo đối tượng Supplier
            Supplier updatedSupplier = new Supplier();
            updatedSupplier.setSupplier_id(supplierId);
            updatedSupplier.setSupplier_name(supplierName);
            updatedSupplier.setContact_name(contactName);
            updatedSupplier.setPhone_number(phoneNumber);
            updatedSupplier.setEmail(email);
            updatedSupplier.setAddress(address);
            updatedSupplier.setCity(city);
            updatedSupplier.setCountry(country);
            
            // Lưu ý: Các trường như created_at sẽ được giữ nguyên trong DB

            boolean success = supplierDao.updateSupplier(updatedSupplier); 

            if (success) {
                request.getSession().setAttribute("successMessage", "Cập nhật nhà cung cấp ID " + supplierId + " thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Cập nhật nhà cung cấp ID " + supplierId + " thất bại.");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi dữ liệu đầu vào. Vui lòng kiểm tra ID.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/supplierlist");
    }
}