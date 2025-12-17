package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.SupplierDao;
import thang.itplus.models.Supplier;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupplierListController", urlPatterns = {"/supplierlist"})
public class SupplierListController extends HttpServlet {

    private SupplierDao supplierDao = new SupplierDao(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy danh sách nhà cung cấp từ DAO
            List<Supplier> suppliers = supplierDao.getAllSuppliers(); 
            
            // Đặt danh sách vào request attribute và chuyển tiếp đến JSP
            request.setAttribute("suppliers", suppliers);
            request.getRequestDispatcher("/suppliers.jsp").forward(request, response); 
            
        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi
            request.getSession().setAttribute("errorMessage", "Lỗi khi tải danh sách nhà cung cấp: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin"); // Chuyển hướng đến trang admin mặc định
        }
    }
}