package thang.itplus.dao;

import java.util.ArrayList;
import java.util.List;
import thang.itplus.context.DBContext;
import thang.itplus.models.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CategoryDao extends DBContext {

    List<Category> listCa = new ArrayList<>();

    public List<Category> getAllCategory() {
        // ⭐ ĐÃ SỬA: Sử dụng try-with-resources cho Connection, PreparedStatement, ResultSet
        String sql = "SELECT * FROM categorys WHERE 1"; 
        
        try (Connection conn = getConnection();
             PreparedStatement statement = conn.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                int cate_id = rs.getInt("category_id");
                String category_name = rs.getString("category_name");
                Category ct = new Category(cate_id, category_name);
                listCa.add(ct);
            }
            return listCa;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public Category getCategoryById(int categoryId) {
        // Tên bảng: categorys
        // Cột ID: category_id
        String sql = "SELECT category_id, category_name FROM categorys WHERE category_id = ?";
        
        // ⭐ ĐÃ SỬA: Sử dụng try-with-resources cho Connection, PreparedStatement, ResultSet
        try (Connection conn = getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            
            // Thiết lập tham số
            statement.setInt(1, categoryId);
            
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    int cate_id = rs.getInt("category_id");
                    String category_name = rs.getString("category_name");
                    return new Category(cate_id, category_name);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
        
        return null;
    }
}