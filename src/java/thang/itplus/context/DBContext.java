// DBContext.java (ĐÃ SỬA LỖI QUẢN LÝ KẾT NỐI - CONNECTION IS CLOSED FIX)
package thang.itplus.context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    // Loại bỏ biến đối tượng 'connection' toàn cục: public Connection connection;

    private final String url = "jdbc:mysql://localhost:8888/mydatabase?serverTimezone=UTC";
    private final String username = "root";
    private final String password = "270805";

    public DBContext() {
        // KHÔNG CẦN TẠO KẾT NỐI TRONG CONSTRUCTOR NỮA
        try {
            // Chỉ cần load Driver một lần
            Class.forName("com.mysql.cj.jdbc.Driver"); 
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy driver JDBC: " + e.getMessage());
        }
    }

    // ⭐ PHƯƠNG THỨC QUAN TRỌNG: LUÔN TRẢ VỀ KẾT NỐI MỚI VÀ ĐANG MỞ
    public Connection getConnection() throws SQLException {
        // Mở kết nối MỚI mỗi khi phương thức này được gọi
        Connection conn = DriverManager.getConnection(url, username, password);
        // Lưu ý: Lớp DAO (UserDao) phải đảm bảo đóng kết nối này an toàn (bằng try-with-resources)
        return conn;
    }

    // Phương thức đóng kết nối không còn cần thiết ở đây, 
    // vì DAO sẽ tự động đóng kết nối (dùng try-with-resources).
    // public void closeConnection() { ... } 
    
    public static void main(String[] args) {
        // Test kết nối riêng biệt
        try (Connection testConn = new DBContext().getConnection()) {
             if (testConn != null) {
                System.out.println("Kết nối cơ sở dữ liệu thành công!");
             } else {
                 System.err.println("Không thể kết nối đến cơ sở dữ liệu.");
             }
        } catch (SQLException e) {
            System.err.println("Lỗi kiểm tra kết nối: " + e.getMessage());
        }
    }
}