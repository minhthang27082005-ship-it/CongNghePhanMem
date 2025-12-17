package thang.itplus.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import thang.itplus.context.DBContext;
import thang.itplus.models.Voucher;
import thang.itplus.models.Voucher.DiscountType;
import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.Statement; // Cần import Statement để lấy khóa tự động tăng
import java.util.Date; // Cần dùng java.util.Date cho test main

/**
 * Data Access Object cho Voucher (Mã giảm giá)
 */
public class VoucherDao extends DBContext {

    // --- Phương thức ánh xạ ResultSet sang đối tượng Voucher ---
    private Voucher mapResultSetToVoucher(ResultSet rs) throws SQLException {
        int id = rs.getInt("voucher_id");
        String code = rs.getString("code");
        DiscountType type = DiscountType.valueOf(rs.getString("discount_type"));
        double value = rs.getDouble("discount_value");
        double minAmount = rs.getDouble("min_order_amount");
        int limit = rs.getInt("usage_limit");
        int used = rs.getInt("times_used");
        Timestamp start = rs.getTimestamp("start_date");
        Timestamp end = rs.getTimestamp("end_date");
        boolean active = rs.getBoolean("is_active");

        return new Voucher(id, code, type, value, minAmount, limit, used, start, end, active);
    }

    // --- 1. Lấy danh sách tất cả các Voucher ---
    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM vouchers ORDER BY end_date DESC";
        try (PreparedStatement ps = getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToVoucher(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- 2. Thêm Voucher mới (FIX: Lấy ID tự động tăng) ---
    public boolean addVoucher(Voucher voucher) {
        String sql = "INSERT INTO vouchers (code, discount_type, discount_value, min_order_amount, usage_limit, start_date, end_date, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        // Sử dụng Statement.RETURN_GENERATED_KEYS
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, voucher.getCode());
            ps.setString(2, voucher.getDiscountType().toString());
            ps.setDouble(3, voucher.getDiscountValue());
            ps.setDouble(4, voucher.getMinOrderAmount());
            ps.setInt(5, voucher.getUsageLimit());
            ps.setTimestamp(6, voucher.getStartDate());
            ps.setTimestamp(7, voucher.getEndDate());
            ps.setBoolean(8, voucher.isActive());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // Lấy ID tự động tăng và cập nhật vào đối tượng Voucher
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        voucher.setVoucher_id(generatedKeys.getInt(1)); // ⭐ ĐÃ SỬA: Cập nhật ID
                    }
                }
                return true;
            }
            return false;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- 3. Lấy Voucher theo ID ---
    public Voucher getVoucherById(int voucherId) {
        String sql = "SELECT * FROM vouchers WHERE voucher_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVoucher(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- 4. Cập nhật Voucher ---
    public boolean updateVoucher(Voucher voucher) {
        String sql = "UPDATE vouchers SET code=?, discount_type=?, discount_value=?, min_order_amount=?, usage_limit=?, start_date=?, end_date=?, is_active=? WHERE voucher_id=?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, voucher.getCode());
            ps.setString(2, voucher.getDiscountType().toString());
            ps.setDouble(3, voucher.getDiscountValue());
            ps.setDouble(4, voucher.getMinOrderAmount());
            ps.setInt(5, voucher.getUsageLimit());
            ps.setTimestamp(6, voucher.getStartDate());
            ps.setTimestamp(7, voucher.getEndDate());
            ps.setBoolean(8, voucher.isActive());
            ps.setInt(9, voucher.getVoucher_id());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- 5. Kiểm tra Mã Giảm Giá Hợp lệ (Logic cốt lõi) ---
    public Voucher getValidVoucherByCode(String code, double currentTotal) {
        Timestamp now = new Timestamp(System.currentTimeMillis());

        String sql = "SELECT * FROM vouchers "
                + "WHERE code = ? "
                + "AND is_active = 1 "
                + "AND start_date <= ? " 
                + "AND end_date >= ? " 
                + "AND min_order_amount <= ? " 
                + "AND times_used < usage_limit";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setTimestamp(2, now);
            ps.setTimestamp(3, now);
            ps.setDouble(4, currentTotal);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVoucher(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- 6. Tăng số lần sử dụng và tự động vô hiệu hóa ---
    public boolean incrementTimesUsed(int voucherId) {
        String sqlUpdateTimesUsed = "UPDATE vouchers SET times_used = times_used + 1 WHERE voucher_id = ?";
        String sqlCheckAndDisable = "UPDATE vouchers SET is_active = 0 WHERE voucher_id = ? AND times_used >= usage_limit";

        Connection conn = null;
        boolean success = false;

        try {
            conn = getConnection(); 
            conn.setAutoCommit(false); 

            try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdateTimesUsed)) {
                ps1.setInt(1, voucherId);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(sqlCheckAndDisable)) {
                ps2.setInt(1, voucherId);
                ps2.executeUpdate();
            }

            conn.commit(); 
            success = true;

        } catch (SQLException e) {
            System.err.println("LỖI CẬP NHẬT TIMES_USED/DISABLE VOUCHER.");
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); 
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return success;
    }

    // --- 7. Xóa Voucher theo ID ---
    public boolean deleteVoucher(int voucherId) {
        String sql = "DELETE FROM vouchers WHERE voucher_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, voucherId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

    }

    // --- 8. Kiểm tra Voucher áp dụng cho sản phẩm ---
    public boolean isProductApplicable(int voucherId, int productId) {
        String sql = "SELECT 1 FROM voucher_products WHERE voucher_id = ? AND product_id = ?";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); 
            }
        } catch (SQLException e) {
            System.err.println("Lỗi DAO khi kiểm tra Voucher áp dụng cho Sản phẩm: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // --- 9. Chèn hàng loạt Voucher Products (Bulk Insert) ---
    public boolean bulkInsertVoucherProducts(int voucherId, List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return true;
        }

        String sqlDeleteOld = "DELETE FROM voucher_products WHERE voucher_id = ?";
        String sqlInsert = "INSERT INTO voucher_products (voucher_id, product_id) VALUES (?, ?)";

        Connection conn = null;
        boolean success = false;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // --- Bước 1: Xóa các liên kết cũ ---
            try (PreparedStatement psDelete = conn.prepareStatement(sqlDeleteOld)) {
                psDelete.setInt(1, voucherId);
                psDelete.executeUpdate();
            }

            // --- Bước 2: Chèn các liên kết mới (BULK INSERT) ---
            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {
                for (int productId : productIds) {
                    psInsert.setInt(1, voucherId);
                    psInsert.setInt(2, productId);
                    psInsert.addBatch();
                }
                psInsert.executeBatch();
            }

            conn.commit();
            success = true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return success;
    }
    
    // --- 10. Phương thức main để chạy thử nghiệm ---
    public static void main(String[] args) {
        VoucherDao dao = new VoucherDao();

        System.out.println("--- Bắt đầu kiểm tra đồng bộ hóa ENUM ---");
        try {
            for (DiscountType type : DiscountType.values()) {
                System.out.println("  => " + type.toString());
            }
            DiscountType testType = DiscountType.valueOf("percentage_product");
            System.out.println("Test ánh xạ thành công: " + testType);
        } catch (Exception e) {
            System.err.println("LỖI CẤU HÌNH: Lỗi trong định nghĩa DiscountType Enum hoặc tên không khớp!");
            e.printStackTrace();
            return; 
        }
        System.out.println("--- Kết thúc kiểm tra ENUM, chuyển sang kiểm tra CSDL ---");

        try {
            List<Voucher> vouchers = dao.getAllVouchers();

            if (vouchers.isEmpty()) {
                System.out.println("CSDL: Danh sách trả về RỖNG.");
            } else {
                System.out.println("CSDL: Danh sách trả về CÓ DỮ LIỆU. Tổng số: " + vouchers.size());
            }
        } catch (Exception e) {
            System.err.println("LỖI HỆ THỐNG: Lỗi xảy ra khi truy vấn CSDL!");
            e.printStackTrace();
        } finally {
            System.out.println("--- KẾT THÚC KIỂM TRA ---");
        }
    }
}
