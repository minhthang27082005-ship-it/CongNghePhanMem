package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.SupplierDao;
import thang.itplus.models.Supplier;

import java.io.IOException;

@WebServlet(name = "SupplierAddController", urlPatterns = {"/add-supplier"})
public class SupplierAddController extends HttpServlet {

    private SupplierDao supplierDao = new SupplierDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); 

        try {
            // Lấy thông tin từ form
            String supplierName = request.getParameter("supplier_name"); 
            String contactName = request.getParameter("contact_name");
            String phoneNumber = request.getParameter("phone_number");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String country = request.getParameter("country");
            
            // Tạo đối tượng Supplier mới
            Supplier newSupplier = new Supplier();
            newSupplier.setSupplier_name(supplierName);
            newSupplier.setContact_name(contactName);
            newSupplier.setPhone_number(phoneNumber);
            newSupplier.setEmail(email);
            newSupplier.setAddress(address);
            newSupplier.setCity(city);
            newSupplier.setCountry(country);
            
            boolean success = supplierDao.insertSupplier(newSupplier); 

            if (success) {
                request.getSession().setAttribute("successMessage", "Thêm nhà cung cấp thành công! ID: " + newSupplier.getSupplier_id());
            } else {
                request.getSession().setAttribute("errorMessage", "Thêm nhà cung cấp thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        
        // Chuyển hướng về trang danh sách
        response.sendRedirect(request.getContextPath() + "/supplierlist"); 
    }
}