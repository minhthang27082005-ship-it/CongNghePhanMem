package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import thang.itplus.dao.VoucherDao;
import thang.itplus.models.Cart;
import thang.itplus.models.CartItem;
import thang.itplus.models.Voucher;
import thang.itplus.models.Voucher.DiscountType;

/**
 * Servlet xử lý việc áp dụng mã giảm giá (Voucher) URL Pattern: /applyvoucher
 */
@WebServlet(name = "ApplyVoucherController", urlPatterns = {"/applyvoucher"})
public class ApplyVoucherController extends HttpServlet {

    private final VoucherDao voucherDao = new VoucherDao();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        String voucherCode = request.getParameter("voucherCode");

        // --- Xóa thông tin voucher cũ khỏi session ---
        session.removeAttribute("appliedVoucher");
        session.removeAttribute("discountAmount");
        session.removeAttribute("voucherMessage");
        session.removeAttribute("voucherMessageStatus");

        if (cart == null || cart.getListItems() == null || cart.getListItems().isEmpty()) {
            session.setAttribute("voucherMessage", "Giỏ hàng trống, không thể áp dụng mã giảm giá.");
            session.setAttribute("voucherMessageStatus", "error");
            response.sendRedirect("cartdetail");
            return;
        }

        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            session.setAttribute("voucherMessage", "Vui lòng nhập mã giảm giá.");
            session.setAttribute("voucherMessageStatus", "info");
            response.sendRedirect("cartdetail");
            return;
        }

        double currentTotal = cart.getTotalPrice();
        Voucher voucher = voucherDao.getValidVoucherByCode(voucherCode.trim(), currentTotal);

        if (voucher != null) {
            // Tính toán số tiền giảm giá thực tế
            double discountAmount = calculateDiscount(voucher, cart);

            // Lưu kết quả thành công vào Session
            session.setAttribute("appliedVoucher", voucher);
            session.setAttribute("discountAmount", discountAmount);
            session.setAttribute("voucherMessage", "Áp dụng mã **" + voucher.getCode() + "** thành công! Giảm: " + String.format("%,.0f", discountAmount) + " VNĐ.");
            session.setAttribute("voucherMessageStatus", "success");

        } else {
            session.setAttribute("voucherMessage", "Mã giảm giá không hợp lệ hoặc không đủ điều kiện áp dụng.");
            session.setAttribute("voucherMessageStatus", "error");
        }

        response.sendRedirect("cartdetail");
    }

    /**
     * Phương thức tính toán số tiền giảm giá dựa trên loại giảm giá và Cart. ĐÃ
     * SỬA LỖI TÍNH TOÁN PERCENTAGE.
     */
    private double calculateDiscount(Voucher voucher, Cart cart) {
        DiscountType type = voucher.getDiscountType();
        double value = voucher.getDiscountValue();
        double totalDiscount = 0.0;
        double cartTotal = cart.getTotalPrice();

        // ⭐ SỬA LỖI TÍNH %: Chuyển đổi giá trị CSDL (12000.0) về tỷ lệ thực (12.0)
        double percentageRate = value / 1000.0;

        switch (type) {
            case percentage_order:
                totalDiscount = cartTotal * (percentageRate / 100.0);
                break;

            case fixed_amount:
                totalDiscount = value;
                break;

            case percentage_product:
                int voucherId = voucher.getVoucher_id();
                for (CartItem item : cart.getListItems().values()) {
                    // Kiểm tra sản phẩm có được áp dụng mã không
                    if (voucherDao.isProductApplicable(voucherId, item.getProduct().getProduct_id())) {
                        totalDiscount += item.getTotalPrice() * (percentageRate / 100.0);
                    }
                }
                break;

            case free_shipping:
                // Miễn phí vận chuyển (bằng 20% đơn hàng)
                totalDiscount = cartTotal * 0.1;
                break;

            default:
                totalDiscount = 0.0;
                break;
        }
        return Math.min(totalDiscount, cartTotal);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("cartdetail");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to apply discount voucher to the shopping cart.";
    }
}
