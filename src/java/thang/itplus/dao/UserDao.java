// UserDao.java (ĐÃ CẬP NHẬT LOGIC ROLE TÌM KIẾM)
package thang.itplus.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import thang.itplus.context.DBContext;
import thang.itplus.models.User;
import java.util.Scanner;
import java.sql.Timestamp;

/**
 *
 * @author Admin
 */
public class UserDao extends DBContext {

    private List<User> listU = new ArrayList<>();
    // KHẮC PHỤC LỖI: Thêm khai báo biến hằng số DELETE_USER ở cấp độ lớp.
    private static final String DELETE_USER = "DELETE FROM users WHERE user_id = ?";

    // Các Controller Add/Update cần các câu lệnh SQL này (giả định)
    private static final String UPDATE_USER = "UPDATE users SET name = ?, email = ?, password = ?, phone = ?, address = ?, role = ? WHERE user_id = ?";
    private static final String SELECT_USER_BY_ID = "SELECT user_id, name, email, password, phone, address, role, login_attempts, lockout_until FROM `users` WHERE user_id=?";
    private static final String INSERT_USER = "INSERT INTO users (user_id, name, email, password, phone, address, role, login_attempts, lockout_until) VALUES (?, ?, ?, ?, ?, ?, ?, 0, NULL)";

    private User.Role parseRole(String roleStr) {
        if (roleStr == null || roleStr.isEmpty()) {
            return null;
        }

        if (roleStr.equalsIgnoreCase("employee")) {
            return User.Role.EMPLOYEE;
        }

        try {
            return User.Role.valueOf(roleStr.toLowerCase());
        } catch (IllegalArgumentException e) {
            System.err.println("Giá trị role không hợp lệ trong Enum: " + roleStr);
            return null;
        }
    }

    // PHƯƠNG THỨC TRỢ GIÚP: Ánh xạ ResultSet thành User
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        int user_id = rs.getInt("user_id");
        String name = rs.getString("name");
        String email = rs.getString("email");
        String password = rs.getString("password");
        String phone = rs.getString("phone");
        String address = rs.getString("address");
        String roleStr = rs.getString("role");

        User.Role rl = parseRole(roleStr);
        if (rl == null) {
            return null;
        }

        User user = new User(user_id, name, email, password, phone, address, rl);
        user.setLoginAttempts(rs.getInt("login_attempts"));
        user.setLockoutUntil(rs.getTimestamp("lockout_until"));
        return user;
    }

    public List<User> getAllUser() {
        listU.clear();
        try {
            String sql = "SELECT * FROM `users` WHERE 1";
            PreparedStatement statement = getConnection().prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                User newUser = mapResultSetToUser(rs);
                if (newUser != null) {
                    listU.add(newUser);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listU;
    }

    public User getUserByEmail(String email) {
        User user = null;
        String sql = "SELECT * FROM `users` WHERE email=?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public User getUserByPhoneAndRole(String phone, User.Role role) {
        User user = null;
        String cleanedPhone = phone.replaceAll("[^0-9]", ""); 
        
        // SỬ DỤNG REPLACE TRONG SQL (Để khớp với dữ liệu không chuẩn hóa trong CSDL)
        String sql = "SELECT * FROM `users` WHERE REPLACE(REPLACE(phone, ' ', ''), '-', '') = ? AND role=?";

        try (java.sql.Connection connection = getConnection(); 
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, cleanedPhone);
            ps.setString(2, role.toString().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public List<User> getCustomersByName(String nameKeyword) {
        List<User> customers = new ArrayList<>();
        String sql = "SELECT * FROM `users` WHERE role='customer' AND name LIKE ? ORDER BY name";

        try (java.sql.Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, "%" + nameKeyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User customer = mapResultSetToUser(rs);
                    if (customer != null) {
                        customers.add(customer);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }
    public User CheckLogin(String e, String p) {
        User newUser = null;
        String query = "SELECT * FROM `users` WHERE email=? AND password=?";
        try {
            DBContext db = new DBContext();
            System.out.println("Câu lệnh SQL trước khi prepare: " + query);
            PreparedStatement statement = getConnection().prepareStatement(query);
            statement.setString(1, e.trim());
            statement.setString(2, p.trim());
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                newUser = mapResultSetToUser(rs);
                System.out.println("User found: " + newUser.getName());
            }
            rs.close();
            statement.close();
        } catch (SQLException error) {
            error.printStackTrace();
        }
        if (newUser == null) {
            System.out.println("User null rồi");
        }
        return newUser;
    }

    public void increaseLoginAttempts(String email) {
        String sql = "UPDATE users SET login_attempts = login_attempts + 1 WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void lockUserUntil(String email, java.sql.Timestamp unlockTime) {
        String sql = "UPDATE users SET lockout_until = ? WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setTimestamp(1, unlockTime);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void resetLoginAttemptsAndUnlock(String email) {
        String sql = "UPDATE users SET login_attempts = 0, lockout_until = NULL WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // PHƯƠNG THỨC XÓA (Khắc phục lỗi cannot find symbol: variable DELETE_USER)
    public boolean deleteUser(int userId) throws SQLException {
        boolean rowDeleted = false;
        try (java.sql.Connection connection = getConnection(); // Sử dụng biến hằng số đã khai báo
                 PreparedStatement statement = connection.prepareStatement(DELETE_USER)) {

            statement.setInt(1, userId);
            rowDeleted = statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return rowDeleted;
    }

    // Phương thức Thêm User (Cần cho AddEmployeeController)
    public boolean insertUser(User user) throws SQLException {
        try (java.sql.Connection connection = getConnection(); PreparedStatement ps = connection.prepareStatement(INSERT_USER)) {
            ps.setInt(1, user.getUser_id());
            ps.setString(2, user.getName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getRole().toString());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Phương thức Cập nhật User (Cần cho UpdateEmployeeController)
    public boolean updateUser(User user) throws SQLException {
        try (java.sql.Connection connection = getConnection(); PreparedStatement ps = connection.prepareStatement(UPDATE_USER)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole().toString());
            ps.setInt(7, user.getUser_id());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    // Phương thức Lấy User theo ID (Cần cho UpdateEmployeeController)
    public User selectUserById(int userId) {
        User user = null;
        try (java.sql.Connection connection = getConnection(); PreparedStatement ps = connection.prepareStatement(SELECT_USER_BY_ID)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // Giữ lại phương thức addUser gốc, có thể bị trùng lặp với insertUser tùy cách sử dụng
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (name, email, password, phone, address, role, login_attempts, lockout_until) VALUES (?, ?, ?, ?, ?, ?, 0, NULL)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole().toString());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isEmailExists(String email) {
        boolean exists = false;
        try {
            String sql = "SELECT * FROM users WHERE email = ?";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                exists = true;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }
    public int getTotalCustomers() {
    String sql = "SELECT COUNT(*) AS total_customers FROM users WHERE role = 'customer'";
    int total = 0;
    
    // Lưu ý: UserDao extends DBContext, nên dùng getConnection() trực tiếp
    try (Connection connection = getConnection(); 
         PreparedStatement ps = connection.prepareStatement(sql); 
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            total = rs.getInt("total_customers");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return total;
}
    public static void main(String[] args) {
        UserDao dao = new UserDao();
        
        System.out.println("--- BẮT ĐẦU TEST TÌM KIẾM KHÁCH HÀNG ---");

        // Dữ liệu mẫu (Dựa trên image_5defe5.png):
        // 4 | Phạm Văn Hòa | abc@gmail.com | 0356777779 | Huế | customer
        // 3 | Phạm Dũng    | dung1975@gmail.com | 0812166737 | thái bình | customer
        
        // 1. TEST QLKH_01: TÌM THEO SĐT (Dữ liệu tồn tại, SĐT chuẩn hóa)
        String testPhone1 = "0356777779";
        System.out.println("\nTEST 1: Tìm kiếm SĐT tồn tại: " + testPhone1);
        User result1 = dao.getUserByPhoneAndRole(testPhone1, User.Role.customer);
        if (result1 != null) {
            System.out.println("  ✅ TÌM THẤY! ID: " + result1.getUser_id() + ", Tên: " + result1.getName());
        } else {
            System.out.println("  ❌ KHÔNG TÌM THẤY (Lỗi CSDL hoặc SĐT không khớp).");
        }
        
        // 2. TEST TÌM THEO SĐT VỚI DẤU CÁCH (Kiểm tra logic .replaceAll("[^0-9]", ""))
        String testPhone2 = "081 216 6737";
        System.out.println("\nTEST 2: Tìm kiếm SĐT có dấu cách: " + testPhone2);
        User result2 = dao.getUserByPhoneAndRole(testPhone2, User.Role.customer);
        if (result2 != null) {
            System.out.println("  ✅ TÌM THẤY! ID: " + result2.getUser_id() + ", Tên: " + result2.getName());
        } else {
            System.out.println("  ❌ KHÔNG TÌM THẤY (Logic làm sạch SĐT có thể sai hoặc SĐT không tồn tại).");
        }

        // 3. TEST QLKH_02: TÌM THEO TÊN (Tìm gần đúng - LIKE)
        String testName1 = "Phạm";
        System.out.println("\nTEST 3: Tìm kiếm Tên (Keyword: " + testName1 + ")");
        List<User> results3 = dao.getCustomersByName(testName1);
        if (!results3.isEmpty()) {
            System.out.println("  ✅ TÌM THẤY " + results3.size() + " khách hàng:");
            for (User u : results3) {
                System.out.println("    - ID: " + u.getUser_id() + ", Tên: " + u.getName() + ", SĐT: " + u.getPhone());
            }
        } else {
            System.out.println("  ❌ KHÔNG TÌM THẤY (Logic LIKE %Keyword% có thể sai).");
        }
        
        // 4. TEST SĐT KHÔNG TỒN TẠI
        String testPhone3 = "0123456789";
        System.out.println("\nTEST 4: Tìm kiếm SĐT không tồn tại: " + testPhone3);
        User result4 = dao.getUserByPhoneAndRole(testPhone3, User.Role.customer);
        if (result4 == null) {
            System.out.println("  ✅ CHÍNH XÁC: Không tìm thấy khách hàng này.");
        } else {
            System.out.println("  ❌ LỖI: Tìm thấy khách hàng không mong muốn.");
        }

        System.out.println("\n--- KẾT THÚC TEST ---");
    }
}
