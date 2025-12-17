package thang.itplus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

import thang.itplus.dao.ProductDao;
import thang.itplus.dao.InventoryDao;
import thang.itplus.models.User;
import thang.itplus.models.User.Role;

@WebServlet(name = "InventoryController", urlPatterns = {"/nhapkho", "/xuatkho"})
public class InventoryController extends HttpServlet {

    private final ProductDao productDao = new ProductDao();
    private final InventoryDao inventoryDao = new InventoryDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String action = request.getServletPath();

        // Kiểm tra phân quyền
        if (currentUser == null || (currentUser.getRole() != Role.EMPLOYEE && currentUser.getRole() != Role.admin)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Truy cập bị từ chối.");
            return;
        }

        // QLK_05: Kiểm tra dữ liệu rỗng
        if (request.getParameter("productId") == null || request.getParameter("quantity") == null
                || request.getParameter("productId").isEmpty() || request.getParameter("quantity").isEmpty()) {
            session.setAttribute("errorMessage", "QLK_05: Vui lòng nhập đầy đủ ID và Số lượng.");
            response.sendRedirect(request.getContextPath() + "/employee/products");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int quantityChange;
            String operationName;
            String transactionType;

            // QLK_06: Kiểm tra Sản phẩm tồn tại
            if (!productDao.isProductExist(productId)) {
                session.setAttribute("errorMessage", "QLK_06: Sản phẩm ID " + productId + " không tồn tại. Vui lòng kiểm tra lại.");
                response.sendRedirect(request.getContextPath() + action);
                return;
            }

            if (action.equals("/nhapkho")) {
                quantityChange = quantity;
                operationName = "Nhập kho";
                transactionType = "NHAP";
            } else if (action.equals("/xuatkho")) {
                quantityChange = -quantity;
                operationName = "Xuất kho";
                transactionType = "XUAT";
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ.");
                return;
            }

            // QLK_04: Kiểm tra số âm
            if (quantity <= 0) {
                session.setAttribute("errorMessage", "QLK_04: " + operationName + " thất bại: Số lượng phải là số dương.");
            } else {
                // Thực hiện QLK_01, QLK_02, và kiểm tra QLK_03 (bên trong DAO)
                boolean success = productDao.updateProductStock(productId, quantityChange);

                if (success) {
                    // QLK_07: Ghi nhận giao dịch
                    inventoryDao.recordTransaction(productId, quantity, transactionType, currentUser.getUser_id());
                    session.setAttribute("successMessage", operationName + " sản phẩm ID " + productId + " thành công.");
                } else {
                    session.setAttribute("errorMessage", operationName + " thất bại do lỗi không xác định.");
                }
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Lỗi dữ liệu: ID sản phẩm hoặc Số lượng không hợp lệ.");
        } catch (IllegalArgumentException e) {
            // Bắt lỗi QLK_03 (Xuất quá tồn kho)
            session.setAttribute("errorMessage", "Lỗi nghiệp vụ: " + e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi CSDL khi thực hiện giao dịch kho.");
        }

        // Chuyển hướng về trang danh sách sản phẩm
        response.sendRedirect(request.getContextPath() + "/employee/products");
    }

    // Logic doGet (hiển thị form nhập/xuất kho)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String action = request.getServletPath();

        // Kiểm tra phân quyền
        if (currentUser == null || (currentUser.getRole() != Role.EMPLOYEE && currentUser.getRole() != Role.admin)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Truy cập bị từ chối.");
            return;
        }

        String targetPage = null;

        if (action.equals("/nhapkho")) {
            targetPage = "inventory_import.jsp";
        } else if (action.equals("/xuatkho")) {
            targetPage = "inventory_export.jsp";
        }

        if (targetPage != null) {
            // ⭐ Sử dụng Layout
            request.setAttribute("pageTitle", action.contains("nhap") ? "Nhập Kho" : "Xuất Kho");
            request.setAttribute("contentPage", targetPage);

            request.getRequestDispatcher("/employee_layout.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/employee/profile");
        }
    }
}