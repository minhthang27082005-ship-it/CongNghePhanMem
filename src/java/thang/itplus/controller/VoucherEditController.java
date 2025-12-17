package thang.itplus.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import thang.itplus.dao.VoucherDao;
import thang.itplus.models.Voucher;
import thang.itplus.models.Voucher.DiscountType;
import thang.itplus.models.User.Role;

@WebServlet(name = "VoucherEditController", urlPatterns = {"/vouchersedit"})
public class VoucherEditController extends HttpServlet {

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

    // ⭐ ĐÃ SỬA: Đổi tên thành checkAdminRole và CHỈ cấp quyền cho Admin
    private boolean checkAdminRole(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        Object userObj = request.getSession().getAttribute("user");
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        Role role = ((thang.itplus.models.User) userObj).getRole();
        
        // ⭐ LOGIC MỚI: CHỈ Cho phép nếu là admin
        if (role != Role.admin) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Quyền truy cập chỉ dành cho Admin.");
            return false;
        }
        return true;
    }

    // GET: Hiển thị form Chỉnh sửa (với dữ liệu có sẵn)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminRole(request, response)) { // Cập nhật tên hàm gọi
            return;
        }

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Thiếu ID mã giảm giá để chỉnh sửa.");
                response.sendRedirect(request.getContextPath() + "/voucherslist");
                return;
            }

            int id = Integer.parseInt(idParam);
            Voucher existingVoucher = voucherDao.getVoucherById(id);

            if (existingVoucher != null) {
                request.setAttribute("voucher", existingVoucher);
                request.getRequestDispatcher("QLVoucher.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("errorMessage", "Mã giảm giá không tồn tại.");
                response.sendRedirect(request.getContextPath() + "/voucherslist");
            }
// BẮT LỖI SỐ (Vẫn cần giữ lại vì nó là lỗi Runtime)
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID mã giảm giá không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/voucherslist");
// LOẠI BỎ KHỐI CATCH SQLException (hoặc thay bằng catch(Exception))
        } catch (Exception e) {
            // Bắt lỗi DB, lỗi IO, hoặc các lỗi không lường trước
            request.getSession().setAttribute("errorMessage", "Lỗi không xác định khi lấy dữ liệu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/voucherslist");
        }
    }

    // POST: Xử lý Cập nhật (update)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkAdminRole(request, response)) { // Cập nhật tên hàm gọi
            return;
        }

        HttpSession session = request.getSession();

        try {
            // Lấy dữ liệu và tạo Voucher (cần ID)
            Voucher voucherToUpdate = getVoucherFromRequest(request);

            if (voucherDao.updateVoucher(voucherToUpdate)) {
                session.setAttribute("successMessage", "Cập nhật mã giảm giá thành công!");
            } else {
                session.setAttribute("errorMessage", "Cập nhật mã giảm giá thất bại.");
            }

            // ⭐ SỬA LỖI CATCH BLOCK
        } catch (IllegalArgumentException e) {
            // Bắt lỗi NumberFormatException, Enum.valueOf(), Date/Time parsing
            session.setAttribute("errorMessage", "Dữ liệu nhập vào không hợp lệ: Vui lòng kiểm tra lại các trường số, ngày/giờ hoặc loại giảm giá.");
            e.printStackTrace();
        } catch (Exception e) {
            // Bắt tất cả các lỗi còn lại, bao gồm cả lỗi DB nếu DAO có vấn đề
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi không xác định: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/voucherslist");
    }

    private Voucher getVoucherFromRequest(HttpServletRequest request)
            throws NumberFormatException, IllegalArgumentException {

        // Bắt buộc phải có ID khi UPDATE
        String idStr = request.getParameter("voucherId");
        if (idStr == null || idStr.isEmpty()) {
            throw new IllegalArgumentException("Thiếu ID Voucher để cập nhật.");
        }
        int voucherId = Integer.parseInt(idStr);

        String code = request.getParameter("code");
        String discountTypeStr = request.getParameter("discountType");

        double discountValue = Double.parseDouble(request.getParameter("discountValue"));
        double minOrderAmount = Double.parseDouble(request.getParameter("minOrderAmount"));
        int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));

        LocalDateTime startDateTime = LocalDateTime.parse(request.getParameter("startDate"), DATETIME_FORMATTER);
        LocalDateTime endDateTime = LocalDateTime.parse(request.getParameter("endDate"), DATETIME_FORMATTER);
        Timestamp startDate = Timestamp.valueOf(startDateTime);
        Timestamp endDate = Timestamp.valueOf(endDateTime);

        DiscountType type = DiscountType.valueOf(discountTypeStr);
        boolean isActive = "true".equalsIgnoreCase(request.getParameter("isActive"));

        Voucher voucher = new Voucher();
        voucher.setVoucher_id(voucherId); // Gán ID
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