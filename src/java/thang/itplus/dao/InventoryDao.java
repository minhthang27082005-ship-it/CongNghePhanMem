package thang.itplus.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import thang.itplus.context.DBContext;
import thang.itplus.models.InventoryTransaction;

public class InventoryDao {

    /**
     * QLK_07: Ghi nhận giao dịch nhập/xuất kho.
     */
    public boolean recordTransaction(int productId, int quantity, String type, int employeeId) throws SQLException {
        String sql = "INSERT INTO inventory_transactions (product_id, transaction_date, transaction_type, quantity, employee_id) VALUES (?, NOW(), ?, ?, ?)";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, productId);
            statement.setString(2, type); 
            statement.setInt(3, quantity);
            statement.setInt(4, employeeId);
            return statement.executeUpdate() > 0;
        }
    }
    
    /**
     * QLK_08: Lấy lịch sử giao dịch, hỗ trợ lọc theo ngày.
     */
    public List<InventoryTransaction> getHistory(String startDate, String endDate) throws SQLException {
        List<InventoryTransaction> historyList = new ArrayList<>();
        
        // Join với bảng users để lấy tên nhân viên
        // Lưu ý: Tên cột người dùng trong bảng 'users' là 'user_name' theo lược đồ CSDL
        String sql = "SELECT t.*, u.name AS employee_name FROM inventory_transactions t " +
                     "JOIN users u ON t.employee_id = u.user_id WHERE 1=1"; 
        
        // Thêm điều kiện lọc ngày (QLK_08)
        if (startDate != null && !startDate.isEmpty()) {
            sql += " AND DATE(t.transaction_date) >= ?";
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql += " AND DATE(t.transaction_date) <= ?";
        }
        sql += " ORDER BY t.transaction_date DESC";

        DBContext db = new DBContext();
        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (startDate != null && !startDate.isEmpty()) {
                statement.setString(paramIndex++, startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                statement.setString(paramIndex++, endDate);
            }
            
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    InventoryTransaction item = new InventoryTransaction();
                    item.setTransactionId(rs.getInt("transaction_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setTransactionDate(rs.getTimestamp("transaction_date").toLocalDateTime()); 
                    item.setType(rs.getString("transaction_type"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setEmployeeId(rs.getInt("employee_id"));
                    item.setEmployeeName(rs.getString("employee_name")); 
                    
                    historyList.add(item);
                }
            }
        }
        return historyList;
    }
}