package thang.itplus.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.util.LinkedHashMap;
import java.util.Map;
import thang.itplus.context.DBContext;
import thang.itplus.models.Product;

public class ProductDao {

    public List<Product> getAllProduct() {
        List<Product> listP = new ArrayList<>();
        String sql = "SELECT * FROM products";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Product pd = new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getInt("category_id"),
                        rs.getString("image")
                );
                listP.add(pd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listP;
    }

    public List<Product> getLastFourProducts() {
        List<Product> listP = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY product_id DESC LIMIT 4";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Product pd = new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getInt("category_id"),
                        rs.getString("image")
                );
                listP.add(pd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listP;
    }

    public List<Product> searchProducts(String query) {
        List<Product> products = new ArrayList<>();
        // Sử dụng LIKE để tìm kiếm gần đúng trong cột product_name hoặc description
        // Điều chỉnh tên cột CSDL nếu khác (ví dụ: 'name' thay vì 'product_name')
        String sql = "SELECT * FROM products WHERE product_name LIKE ? OR description LIKE ?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchTerm = "%" + query + "%"; // Thêm ký tự wildcards cho LIKE
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getString("product_name"),
                            rs.getString("description"),
                            rs.getDouble("price"),
                            rs.getInt("stock"),
                            rs.getInt("category_id"),
                            rs.getString("image")
                    );
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id = ?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getString("product_name"),
                            rs.getString("description"),
                            rs.getDouble("price"),
                            rs.getInt("stock"),
                            rs.getInt("category_id"),
                            rs.getString("image")
                    );
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    public void deleteProductById(int id) {
        String sql = "DELETE FROM products WHERE product_id=?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isProductExist(int productId) throws SQLException {
        String sql = "SELECT 1 FROM products WHERE product_id = ?";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, productId);
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean updateProductById(Product p) {
        String sql = "UPDATE products SET product_name = ?, description = ?, price = ?, stock = ?, image = ? WHERE product_id = ?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, p.getName());
            statement.setString(2, p.getDescription());
            statement.setDouble(3, p.getPrice());
            statement.setInt(4, p.getStock());
            statement.setString(5, p.getImage());
            statement.setInt(6, p.getProduct_id());

            int rowsUpdated = statement.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addProduct(Product p) {
        String sql = "INSERT INTO products (product_id, product_name, description, price, stock, category_id, image) VALUES (?, ?, ?, ?, ?, ?, ?)";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql)) {

            statement.setInt(1, p.getProduct_id());
            statement.setString(2, p.getName());
            statement.setString(3, p.getDescription());
            statement.setDouble(4, p.getPrice());
            statement.setInt(5, p.getStock());
            statement.setInt(6, p.getCategory_id());
            statement.setString(7, p.getImage());

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id=?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql)) {

            statement.setInt(1, productId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                return new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getInt("category_id"),
                        rs.getString("image")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> getTopTwentyProducts() {
        List<Product> listP = new ArrayList<>();
        // Lấy 20 sản phẩm mới nhất (giả sử product_id lớn hơn là mới hơn)
        String sql = "SELECT * FROM products ORDER BY product_id DESC LIMIT 20";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Product pd = new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getInt("category_id"),
                        rs.getString("image")
                );
                listP.add(pd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listP;
    }

    public List<Integer> getAllProductIds() {
        List<Integer> productIds = new ArrayList<>();
        // LƯU Ý: Phải đảm bảo tên cột là product_id
        String sql = "SELECT product_id FROM products";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                productIds.add(rs.getInt("product_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return productIds;
    }

    public boolean updateProductStock(int productId, int quantityChange) throws SQLException {
        // Cần truy vấn lại stock hiện tại để kiểm tra QLK_03 (Xuất quá số lượng)
        Product product = getProductById(productId);
        if (product == null) {
            throw new IllegalArgumentException("QLK_06: Sản phẩm không tồn tại.");
        }

        int currentStock = product.getStock();
        int newStock = currentStock + quantityChange;

        // ⭐ Xử lý QLK_03: Kiểm tra Xuất quá số lượng
        if (newStock < 0) {
            throw new IllegalArgumentException("QLK_03: Không đủ tồn kho để xuất. Tồn kho hiện tại: " + currentStock);
        }

        String sql = "UPDATE products SET stock = ? WHERE product_id = ?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, newStock);
            statement.setInt(2, productId);
            return statement.executeUpdate() > 0;
        }
    }
public int getTotalProducts() {
    String sql = "SELECT COUNT(*) AS total_products FROM products";
    DBContext db = new DBContext();
    int total = 0;

    try (Connection conn = db.getConnection(); 
         PreparedStatement statement = conn.prepareStatement(sql); 
         ResultSet rs = statement.executeQuery()) {

        if (rs.next()) {
            total = rs.getInt("total_products");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return total;
}
public Map<String, Integer> getProductsCountByCategory() {
        // SQL JOIN: Đếm sản phẩm, nhóm theo tên danh mục
        String sql = "SELECT c.category_name, COUNT(p.product_id) AS product_count " +
                     "FROM categorys c " +
                     "LEFT JOIN products p ON c.category_id = p.category_id " +
                     "GROUP BY c.category_name " +
                     "ORDER BY product_count DESC";
        
        DBContext db = new DBContext();
        // Sử dụng LinkedHashMap để giữ nguyên thứ tự kết quả từ CSDL
        Map<String, Integer> categoryData = new LinkedHashMap<>();

        try (Connection conn = db.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String categoryName = rs.getString("category_name");
                int count = rs.getInt("product_count");
                categoryData.put(categoryName, count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categoryData;
    }
    // MAIN để test nhanh
    public static void main(String[] args) {
        ProductDao dao = new ProductDao();
        List<Product> list = dao.getAllProduct();

        if (list != null && !list.isEmpty()) {
            for (Product p : list) {
                System.out.println("ID: " + p.getProduct_id());
                System.out.println("Tên: " + p.getName());
                System.out.println("Mô tả: " + p.getDescription());
                System.out.println("Giá: " + p.getPrice());
                System.out.println("Tồn kho: " + p.getStock());
                System.out.println("Danh mục ID: " + p.getCategory_id());
                System.out.println("Ảnh: " + p.getImage());
                System.out.println("-------------------------------");
            }
        } else {
            System.out.println("Không có sản phẩm.");
        }
    }
}
