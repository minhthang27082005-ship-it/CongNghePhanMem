package thang.itplus.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import thang.itplus.context.DBContext;
import thang.itplus.models.Supplier;

public class SupplierDao {

    // Helper method to map ResultSet to Supplier object
    private Supplier mapResultSetToSupplier(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setSupplier_id(rs.getInt("supplier_id"));
        supplier.setSupplier_name(rs.getString("supplier_name"));
        supplier.setContact_name(rs.getString("contact_name"));
        supplier.setPhone_number(rs.getString("phone_number"));
        supplier.setEmail(rs.getString("email"));
        supplier.setAddress(rs.getString("address"));
        supplier.setCity(rs.getString("city"));
        supplier.setCountry(rs.getString("country"));

        // Chuyển đổi Timestamp sang LocalDateTime
        Timestamp createdTimestamp = rs.getTimestamp("created_at");
        if (createdTimestamp != null) {
            supplier.setCreated_at(createdTimestamp.toLocalDateTime());
        }
        
        return supplier;
    }

    // --- 1. READ (SELECT) ---

    /**
     * Lấy danh sách tất cả Supplier.
     * @return Danh sách các Supplier.
     */
    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM suppliers ORDER BY supplier_id DESC";
        DBContext db = new DBContext();
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                suppliers.add(mapResultSetToSupplier(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suppliers;
    }
    
    /**
     * Lấy một Supplier theo ID.
     * @param supplierId ID của Supplier.
     * @return Đối tượng Supplier hoặc null nếu không tìm thấy.
     */
    public Supplier getSupplierById(int supplierId) {
        String sql = "SELECT * FROM suppliers WHERE supplier_id = ?";
        DBContext db = new DBContext();
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, supplierId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSupplier(rs);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- 2. CREATE (INSERT) ---

    /**
     * Thêm một Supplier mới vào DB.
     * @param supplier Đối tượng Supplier cần thêm (supplier_id sẽ được tự động tạo).
     * @return true nếu thêm thành công.
     */
    public boolean insertSupplier(Supplier supplier) {
        // Loại bỏ supplier_id và created_at khỏi danh sách cột INSERT vì chúng là AUTO_INCREMENT và DEFAULT
        String sql = "INSERT INTO suppliers (supplier_name, contact_name, phone_number, email, address, city, country) VALUES (?, ?, ?, ?, ?, ?, ?)";
        DBContext db = new DBContext();
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
             
            ps.setString(1, supplier.getSupplier_name());
            ps.setString(2, supplier.getContact_name());
            ps.setString(3, supplier.getPhone_number());
            ps.setString(4, supplier.getEmail());
            ps.setString(5, supplier.getAddress());
            ps.setString(6, supplier.getCity());
            ps.setString(7, supplier.getCountry());

            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // Lấy ID tự động tăng để cập nhật lại đối tượng Supplier
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        supplier.setSupplier_id(generatedKeys.getInt(1));
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

    // --- 3. UPDATE ---

    /**
     * Cập nhật thông tin Supplier.
     * @param supplier Đối tượng Supplier chứa thông tin cần cập nhật và supplier_id.
     * @return true nếu cập nhật thành công.
     */
    public boolean updateSupplier(Supplier supplier) {
        String sql = "UPDATE suppliers SET supplier_name = ?, contact_name = ?, phone_number = ?, email = ?, address = ?, city = ?, country = ? WHERE supplier_id = ?";
        DBContext db = new DBContext();
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, supplier.getSupplier_name());
            ps.setString(2, supplier.getContact_name());
            ps.setString(3, supplier.getPhone_number());
            ps.setString(4, supplier.getEmail());
            ps.setString(5, supplier.getAddress());
            ps.setString(6, supplier.getCity());
            ps.setString(7, supplier.getCountry());
            
            ps.setInt(8, supplier.getSupplier_id()); // WHERE clause

            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- 4. DELETE ---

    /**
     * Xóa một Supplier dựa trên ID.
     * LƯU Ý: Cần đảm bảo không có sản phẩm nào đang liên kết đến supplier này.
     * @param supplierId ID của Supplier cần xóa.
     * @return true nếu xóa thành công.
     */
    public boolean deleteSupplier(int supplierId) {
        String sql = "DELETE FROM suppliers WHERE supplier_id = ?";
        DBContext db = new DBContext();
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, supplierId);
            
            int rowsAffected = ps.executeUpdate();
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            // LỖI: Nếu có sản phẩm (products) đang dùng supplier_id này, 
            // MySQL sẽ báo lỗi Foreign Key Constraint. 
            // Bạn cần xử lý việc này (ví dụ: xóa sản phẩm liên quan trước hoặc báo lỗi).
            System.err.println("LỖI XÓA SUPPLIER. Có thể do ràng buộc Khóa ngoại (Foreign Key).");
            e.printStackTrace();
            return false;
        }
    }


    // --- PHƯƠNG THỨC CHẠY THỬ (MAIN METHOD) ---

    public static void main(String[] args) {
        SupplierDao dao = new SupplierDao();
        System.out.println("--- BẮT ĐẦU KIỂM TRA getAllSuppliers() ---");

        try {
            List<Supplier> suppliers = dao.getAllSuppliers();

            if (suppliers.isEmpty()) {
                System.out.println("Danh sách nhà cung cấp rỗng. (Kiểm tra lại dữ liệu trong bảng 'suppliers').");
            } else {
                System.out.println("Lấy thành công " + suppliers.size() + " nhà cung cấp:");
                System.out.println("--------------------------------------------------------------------------------");
                System.out.printf("%-5s | %-30s | %-15s | %s%n", 
                                  "ID", "Tên Nhà Cung Cấp", "Người Liên Hệ", "Email");
                System.out.println("--------------------------------------------------------------------------------");
                
                for (Supplier supplier : suppliers) {
                    System.out.printf("%-5d | %-30s | %-15s | %s%n",
                            supplier.getSupplier_id(),
                            supplier.getSupplier_name(),
                            supplier.getContact_name() != null ? supplier.getContact_name() : "N/A",
                            supplier.getEmail());
                }
                System.out.println("--------------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.err.println("Kiểm tra thất bại. Lỗi: " + e.getMessage());
            e.printStackTrace(); 
        } finally {
            System.out.println("--- KẾT THÚC KIỂM TRA ---");
        }
    }
}