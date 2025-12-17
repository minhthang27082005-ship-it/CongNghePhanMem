package thang.itplus.dao;

import thang.itplus.context.DBContext;
import thang.itplus.models.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    private static final String SELECT_ALL_CUSTOMERS_SQL = "SELECT user_id, name, email, password, phone, address, role FROM users WHERE role = 'customer'";
    private static final String INSERT_USER_SQL = "INSERT INTO users (user_id, name, email, password, phone, address, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_USER_BY_ID_SQL = "SELECT user_id, name, email, password, phone, address, role FROM users WHERE user_id = ?"; // GIỮ LẠI CÂU LỆNH NÀY
    private static final String UPDATE_USER_SQL = "UPDATE users SET name = ?, email = ?, password = ?, phone = ?, address = ?, role = ? WHERE user_id = ?";
    // private static final String DELETE_USER_SQL = "DELETE FROM users WHERE user_id = ?"; // ĐÃ LOẠI BỎ CÂU LỆNH NÀY

    public CustomerDAO() {
    }

    private User.Role parseRole(String roleStr) {
        if (roleStr == null || roleStr.isEmpty()) {
            return null;
        }

        // 1. Nếu chuỗi là "employee" (thường/hoa), ánh xạ tới hằng số EMPLOYEE (HOA)
        if (roleStr.equalsIgnoreCase("employee")) {
            return User.Role.EMPLOYEE;
        }

        // 2. Với các vai trò còn lại ("admin", "customer"), chúng là chữ thường.
        try {
            return User.Role.valueOf(roleStr.toLowerCase());
        } catch (IllegalArgumentException e) {
            System.err.println("Giá trị role không hợp lệ trong Enum: " + roleStr);
            return null;
        }
    }

    public List<User> selectAllCustomers() {
        List<User> customers = new ArrayList<>();
        DBContext dbContext = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;

        try {
            dbContext = new DBContext();
            connection = dbContext.getConnection();
            preparedStatement = connection.prepareStatement(SELECT_ALL_CUSTOMERS_SQL);
            System.out.println("Executing SQL: " + preparedStatement);
            rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int userId = rs.getInt("user_id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String password = rs.getString("password");
                String phone = rs.getString("phone");
                String address = rs.getString("address");
                String roleStr = rs.getString("role");

                User.Role role = parseRole(roleStr);

                customers.add(new User(userId, name, email, password, phone, address, role));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn dữ liệu khách hàng:");
            printSQLException(e);
        } catch (RuntimeException e) {
            System.err.println("Không thể kết nối CSDL để lấy khách hàng: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return customers;
    }

    public void insertUser(User user) throws SQLException {
        DBContext dbContext = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        try {
            dbContext = new DBContext();
            connection = dbContext.getConnection();
            preparedStatement = connection.prepareStatement(INSERT_USER_SQL);
            preparedStatement.setInt(1, user.getUser_id());
            preparedStatement.setString(2, user.getName());
            preparedStatement.setString(3, user.getEmail());
            preparedStatement.setString(4, user.getPassword());
            preparedStatement.setString(5, user.getPhone());
            preparedStatement.setString(6, user.getAddress());
            preparedStatement.setString(7, user.getRole().name());

            System.out.println("Executing insert SQL: " + preparedStatement);
            preparedStatement.executeUpdate();
        } finally {
            try {
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                
            } catch (SQLException e) {
                printSQLException(e);
            }
        }
    }

    // GIỮ LẠI PHƯƠNG THỨC NÀY
    public User selectUserById(int userId) {
        User user = null;
        DBContext dbContext = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;

        try {
            dbContext = new DBContext();
            connection = dbContext.getConnection();
            preparedStatement = connection.prepareStatement(SELECT_USER_BY_ID_SQL);
            preparedStatement.setInt(1, userId);
            System.out.println("Executing select by ID SQL: " + preparedStatement);
            rs = preparedStatement.executeQuery();

            if (rs.next()) {
                int foundUserId = rs.getInt("user_id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String password = rs.getString("password");
                String phone = rs.getString("phone");
                String address = rs.getString("address");
                String roleStr = rs.getString("role");
                User.Role role = parseRole(roleStr);
                user = new User(foundUserId, name, email, password, phone, address, role);
            }
        } catch (SQLException e) {
            printSQLException(e);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                
            } catch (SQLException e) {
                printSQLException(e);
            }
        }
        return user;
    }

    public boolean updateUser(User user) throws SQLException {
        boolean rowUpdated;
        DBContext dbContext = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        try {
            dbContext = new DBContext();
            connection = dbContext.getConnection();
            preparedStatement = connection.prepareStatement(UPDATE_USER_SQL);
            preparedStatement.setString(1, user.getName());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPassword());
            preparedStatement.setString(4, user.getPhone());
            preparedStatement.setString(5, user.getAddress());
            preparedStatement.setString(6, user.getRole().name());
            preparedStatement.setInt(7, user.getUser_id());

            System.out.println("Executing update SQL: " + preparedStatement);
            rowUpdated = preparedStatement.executeUpdate() > 0;
        } finally {
            try {
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                
            } catch (SQLException e) {
                printSQLException(e);
            }
        }
        return rowUpdated;
    }

    // ĐÃ LOẠI BỎ PHƯƠNG THỨC NÀY
    // public boolean deleteUser(int userId) throws SQLException {
    //     // ... logic xóa ...
    // }
    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = e.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
}
    