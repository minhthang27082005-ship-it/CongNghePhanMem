// AddProductController.java
package thang.itplus.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import thang.itplus.dao.ProductDao;
import thang.itplus.models.Product;

public class AddProductController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Add Product</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>This page is for adding products via POST request.</h1>");
            out.println("<p>Please use the product management interface to add new products.</p>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu ai đó truy cập bằng GET, chúng ta có thể chuyển hướng họ về trang quản lý
        response.sendRedirect("admin"); // Chuyển hướng về AdminController để hiển thị trang chính
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String errorMessage = null;
        try {
            // Kiểm tra và in các giá trị tham số để debug
            System.out.println("AddProductController - Receiving parameters:");
            System.out.println("productId: " + request.getParameter("productId"));
            System.out.println("categoryId: " + request.getParameter("categoryId"));
            System.out.println("name: " + request.getParameter("name"));
            System.out.println("price: " + request.getParameter("price"));
            System.out.println("stock: " + request.getParameter("stock"));
            System.out.println("image: " + request.getParameter("image"));
            System.out.println("description: " + request.getParameter("description"));

            int product_id = Integer.parseInt(request.getParameter("productId"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String image = request.getParameter("image");
            String description = request.getParameter("description");

            Product p = new Product(product_id, name, description, price, stock, categoryId, image);
            ProductDao productD = new ProductDao();

            boolean addSuccess = productD.addProduct(p); // Lưu kết quả để debug
            System.out.println("Product add success in DAO: " + addSuccess);

            if (addSuccess) {
                request.getSession().setAttribute("successMessage", "Thêm sản phẩm mới thành công!"); // Thêm dòng này
                response.sendRedirect("listproducts");
            } else {
                request.getSession().setAttribute("errorMessage", "Lỗi: ID sản phẩm đã tồn tại."); // Thêm dòng này
                response.sendRedirect("listproducts");
            }
        } catch (NumberFormatException e) {
            errorMessage = "Invalid input format for Product ID, Category ID, Price, or Stock. Please enter numeric values.";
            System.err.println("NumberFormatException: " + e.getMessage()); // In lỗi ra console
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "An unexpected error occurred: " + e.getMessage();
            System.err.println("General Exception in AddProductController: " + e.getMessage()); // In lỗi ra console
            e.printStackTrace();
        }

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            ProductDao productD = new ProductDao();
            // Lấy lại danh sách sản phẩm TẠI ĐÂY để gửi kèm khi forward
            List<Product> listP = productD.getAllProduct();
            request.setAttribute("listP", listP); // Đặt danh sách vào request scope

            request.getRequestDispatcher("qlsp.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for adding new products";
    }
}
