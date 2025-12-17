package thang.itplus.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import thang.itplus.dao.VoucherDao;
import thang.itplus.dao.ProductDao;
import thang.itplus.models.Voucher;
import thang.itplus.models.Voucher.DiscountType;
import thang.itplus.models.User.Role;

@WebServlet(name = "VoucherAddController", urlPatterns = {"/vouchersadd"})
public class VoucherAddController extends HttpServlet {

    private VoucherDao voucherDao;
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.voucherDao = new VoucherDao();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo VoucherDao.", e);
        }
    }

    private boolean checkAdminRole(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        // (Giữ nguyên logic kiểm tra Admin Role)
        Object userObj = request.getSession().getAttribute("user");
        if (userObj == null) { response.sendRedirect(request.getContextPath() + "/login"); return false; }
        Role role = ((thang.itplus.models.User) userObj).getRole();
        
        if (role != Role.admin) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Quyền truy cập chỉ dành cho Admin.");
            return false;
        }
        return true;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdminRole(request, response)) return; 
        request.getRequestDispatcher("QLVoucher.jsp").forward(request, response);
    }
    
    // POST: Xử lý Thêm mới (insert)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdminRole(request, response)) return; 
        
        HttpSession session = request.getSession();

        try {
            Voucher newVoucher = getVoucherFromRequest(request);
            
            // ⭐ 1. Thêm Voucher vào bảng vouchers (Cần đảm bảo addVoucher CẬP NHẬT ID)
            // Gọi addVoucher. Nếu thành công, ID sẽ có trong newVoucher.
            if (voucherDao.addVoucher(newVoucher)) { 
                
                int voucherId = newVoucher.getVoucher_id(); // Lấy ID đã được cập nhật bởi DAO
                
                // ⭐ 2. Xử lý Tự động liên kết cho loại percentage_product
                if (newVoucher.getDiscountType() == DiscountType.percentage_product) {
                    
                    if (voucherId > 0) { // Đảm bảo ID hợp lệ
                        ProductDao productDao = new ProductDao();
                        List<Integer> allProductIds = productDao.getAllProductIds();
                        
                        // Tự động liên kết Voucher với TẤT CẢ sản phẩm
                        if (voucherDao.bulkInsertVoucherProducts(voucherId, allProductIds)) {
                            session.setAttribute("successMessage", "Thêm mã giảm giá thành công! (Áp dụng tự động cho " + allProductIds.size() + " sản phẩm)");
                        } else {
                            // Lỗi xảy ra ở Bulk Insert (SQL)
                            session.setAttribute("errorMessage", "Thêm Voucher thành công nhưng **LỖI KHI TỰ ĐỘNG ÁP DỤNG** cho các sản phẩm.");
                        }
                    } else {
                         session.setAttribute("errorMessage", "Thêm Voucher thất bại vì không lấy được Voucher ID vừa tạo.");
                    }
                } else {
                     session.setAttribute("successMessage", "Thêm mã giảm giá mới thành công!");
                }
                
            } else {
                session.setAttribute("errorMessage", "Thêm mã giảm giá thất bại (có thể mã đã tồn tại hoặc lỗi CSDL).");
            }

        } catch (IllegalArgumentException e) { 
            session.setAttribute("errorMessage", "Dữ liệu nhập vào không hợp lệ: Vui lòng kiểm tra lại các trường số, ngày/giờ hoặc loại giảm giá.");
            e.printStackTrace(); 
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi không xác định: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/voucherslist");
    }

    private Voucher getVoucherFromRequest(HttpServletRequest request) 
            throws NumberFormatException, IllegalArgumentException {
        
        String code = request.getParameter("code");
        String discountTypeStr = request.getParameter("discountType");
        
        double discountValue = Double.parseDouble(request.getParameter("discountValue"));
        double minOrderAmount = Double.parseDouble(request.getParameter("minOrderAmount"));
        int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
        
        // Parsing Date/Time
        LocalDateTime startDateTime = LocalDateTime.parse(request.getParameter("startDate"), DATETIME_FORMATTER);
        LocalDateTime endDateTime = LocalDateTime.parse(request.getParameter("endDate"), DATETIME_FORMATTER);
        Timestamp startDate = Timestamp.valueOf(startDateTime);
        Timestamp endDate = Timestamp.valueOf(endDateTime);
        
        DiscountType type = DiscountType.valueOf(discountTypeStr);
        
        boolean isActive = true; // Thêm mới mặc định là active
        
        Voucher voucher = new Voucher();
        voucher.setCode(code);
        voucher.setDiscountType(type);
        voucher.setDiscountValue(discountValue);
        voucher.setMinOrderAmount(minOrderAmount);
        voucher.setUsageLimit(usageLimit);
        voucher.setStartDate(startDate);
        voucher.setEndDate(endDate);
        voucher.setActive(isActive);
        
        return voucher;
    }
}