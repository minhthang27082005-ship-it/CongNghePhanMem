package thang.itplus.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date; // Import java.util.Date
import thang.itplus.context.DBContext;
import thang.itplus.models.Employee;
import thang.itplus.models.User;

public class EmployeeDAO {

    // Các câu lệnh SQL
    private static final String SELECT_ALL_EMPLOYEES
            = "SELECT e.employee_id, e.user_id, e.name, e.email, e.phone, e.address, "
            + "e.position, e.salary, e.hire_date, e.status "
            + "FROM employees e "
            + "JOIN users u ON e.user_id = u.user_id "
            + "WHERE u.role = 'employee'";
    private static final String UPDATE_USER_PASSWORD = "UPDATE users SET password = ? WHERE user_id = ?";
    private static final String SELECT_EMPLOYEE_BY_ID = "SELECT employee_id, user_id, name, email, phone, address, position, salary, hire_date, status FROM employees WHERE employee_id = ?";
    private static final String INSERT_EMPLOYEE = "INSERT INTO employees (employee_id, user_id, name, email, phone, address, position, salary, hire_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_EMPLOYEE = "UPDATE employees SET name = ?, email = ?, phone = ?, address = ?, position = ?, salary = ?, hire_date = ?, status = ? WHERE employee_id = ?";
    private static final String DELETE_EMPLOYEE = "DELETE FROM employees WHERE employee_id = ?";
    private static final String UPDATE_EMPLOYEE_PROFILE = "UPDATE employees SET name = ?, email = ?, phone = ?, address = ? WHERE employee_id = ?";
    private static final String UPDATE_USER_PROFILE = "UPDATE users SET name = ?, email = ?, phone = ?, address = ? WHERE user_id = ?";

    // Phương thức trợ giúp để in lỗi SQLException một cách chi tiết
    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                if (!"02000".equalsIgnoreCase(((SQLException) e).getSQLState())) {
                    System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                    System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                    System.err.println("Message: " + e.getMessage());
                    Throwable t = ex.getCause();
                    while (t != null) {
                        System.out.println("Cause: " + t);
                        t = t.getCause();
                    }
                }
            }
        }
    }

    // --- CRUD Operations ---
    public List<Employee> selectAllEmployees() throws SQLException {
        List<Employee> employees = new ArrayList<>();
        DBContext dbContext = new DBContext();
        Connection connection = null;
        try {
            connection = dbContext.getConnection();
            if (connection == null) {
                System.err.println("Lỗi: Không thể lấy kết nối CSDL từ DBContext. Kiểm tra cấu hình DBContext (URL, User, Pass) và trạng thái MySQL server.");
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }

            try (PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_EMPLOYEES); ResultSet rs = preparedStatement.executeQuery()) {

                while (rs.next()) {
                    int employeeId = rs.getInt("employee_id");
                    int userId = rs.getInt("user_id");
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    String phone = rs.getString("phone");
                    String address = rs.getString("address");
                    String position = rs.getString("position");
                    double salary = rs.getDouble("salary");
                    java.util.Date hireDate = rs.getDate("hire_date");
                    String status = rs.getString("status");

                    employees.add(new Employee(employeeId, userId, name, email, phone, address, position, salary, hireDate, status));
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw e;
        } finally {
            if (connection != null) {

            }
        }
        return employees;
    }

    /**
     * Lấy thông tin chi tiết nhân viên dựa trên User ID.
     */
    public Employee selectEmployeeByUserId(int userId) throws SQLException {
        Employee employee = null;
        // ⭐ SQL: Tìm kiếm theo user_id
        String sql = "SELECT employee_id, user_id, name, email, phone, address, position, salary, hire_date, status FROM employees WHERE user_id = ?";
        DBContext dbContext = new DBContext();
        Connection connection = null;
        try {
            connection = dbContext.getConnection();
            if (connection == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setInt(1, userId);
                try (ResultSet rs = preparedStatement.executeQuery()) {
                    if (rs.next()) {
                        int employeeId = rs.getInt("employee_id");
                        // Lấy các cột còn lại
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String phone = rs.getString("phone");
                        String address = rs.getString("address");
                        String position = rs.getString("position");
                        double salary = rs.getDouble("salary");
                        java.util.Date hireDate = rs.getDate("hire_date");
                        String status = rs.getString("status");

                        employee = new Employee(employeeId, userId, name, email, phone, address, position, salary, hireDate, status);
                    }
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw e;
        } finally {

        }
        return employee;
    }

    public boolean updateEmployeeProfile(Employee employee, User user, String newPassword) throws SQLException {
        DBContext dbContext = new DBContext();
        Connection connection = null;
        boolean success = false;

        try {
            connection = dbContext.getConnection();
            connection.setAutoCommit(false);

            // 1. Cập nhật bảng employees
            try (PreparedStatement psEmp = connection.prepareStatement(UPDATE_EMPLOYEE_PROFILE)) {
                psEmp.setString(1, employee.getName());
                psEmp.setString(2, employee.getEmail());
                psEmp.setString(3, employee.getPhone());
                psEmp.setString(4, employee.getAddress());
                psEmp.setInt(5, employee.getEmployee_id());
                psEmp.executeUpdate();
            }

            // 2. Cập nhật bảng users
            try (PreparedStatement psUser = connection.prepareStatement(UPDATE_USER_PROFILE)) {
                psUser.setString(1, user.getName());
                psUser.setString(2, user.getEmail());
                psUser.setString(3, user.getPhone());
                psUser.setString(4, user.getAddress());
                psUser.setInt(5, user.getUser_id());
                psUser.executeUpdate();
            }

            // 3. Cập nhật Mật khẩu (Nếu người dùng có nhập)
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                try (PreparedStatement psPass = connection.prepareStatement(UPDATE_USER_PASSWORD)) {
                    psPass.setString(1, newPassword); // Gán mật khẩu mới
                    psPass.setInt(2, user.getUser_id());
                    psPass.executeUpdate();
                }
            }

            connection.commit();
            success = true;
        } catch (SQLException e) {
            if (connection != null) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
            }
        }
        return success;
    }

    public Employee selectEmployeeById(int id) throws SQLException {
        Employee employee = null;
        DBContext dbContext = new DBContext();
        Connection connection = null;
        try {
            connection = dbContext.getConnection();
            if (connection == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            try (PreparedStatement preparedStatement = connection.prepareStatement(SELECT_EMPLOYEE_BY_ID)) {
                preparedStatement.setInt(1, id);
                try (ResultSet rs = preparedStatement.executeQuery()) {
                    if (rs.next()) {
                        int employeeId = rs.getInt("employee_id");
                        int userId = rs.getInt("user_id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String phone = rs.getString("phone");
                        String address = rs.getString("address");
                        String position = rs.getString("position");
                        double salary = rs.getDouble("salary");
                        java.util.Date hireDate = rs.getDate("hire_date");
                        String status = rs.getString("status");
                        employee = new Employee(employeeId, userId, name, email, phone, address, position, salary, hireDate, status);
                    }
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw e;
        } finally {
            if (connection != null) {

            }
        }
        return employee;
    }

    public boolean insertEmployee(Employee employee) throws SQLException {
        boolean rowInserted = false;
        DBContext dbContext = new DBContext();
        Connection connection = null;
        try {
            connection = dbContext.getConnection();
            if (connection == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            try (PreparedStatement preparedStatement = connection.prepareStatement(INSERT_EMPLOYEE)) {
                preparedStatement.setInt(1, employee.getEmployee_id());
                preparedStatement.setInt(2, employee.getUser_id());
                preparedStatement.setString(3, employee.getName());
                preparedStatement.setString(4, employee.getEmail());
                preparedStatement.setString(5, employee.getPhone());
                preparedStatement.setString(6, employee.getAddress());
                preparedStatement.setString(7, employee.getPosition());
                preparedStatement.setDouble(8, employee.getSalary());

                java.util.Date utilHireDate = employee.getHireDate();
                java.sql.Date sqlHireDate = null;
                if (utilHireDate != null) {
                    sqlHireDate = new java.sql.Date(utilHireDate.getTime());
                }
                preparedStatement.setDate(9, sqlHireDate);

                preparedStatement.setString(10, employee.getStatus());
                rowInserted = preparedStatement.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw e;
        } finally {
            if (connection != null) {

            }
        }
        return rowInserted;
    }

    public boolean updateEmployee(Employee employee) throws SQLException {
        boolean rowUpdated = false;
        DBContext dbContext = new DBContext();
        Connection connection = null;
        try {
            connection = dbContext.getConnection();
            if (connection == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            try (PreparedStatement statement = connection.prepareStatement(UPDATE_EMPLOYEE)) {
                statement.setString(1, employee.getName());
                statement.setString(2, employee.getEmail());
                statement.setString(3, employee.getPhone());
                statement.setString(4, employee.getAddress());
                statement.setString(5, employee.getPosition());
                statement.setDouble(6, employee.getSalary());

                java.util.Date utilHireDate = employee.getHireDate();
                java.sql.Date sqlHireDate = null;
                if (utilHireDate != null) {
                    sqlHireDate = new java.sql.Date(utilHireDate.getTime());
                }
                statement.setDate(7, sqlHireDate);

                statement.setString(8, employee.getStatus());
                statement.setInt(9, employee.getEmployee_id());
                rowUpdated = statement.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw e;
        } finally {
            if (connection != null) {

            }
        }
        return rowUpdated;
    }

    public boolean deleteEmployee(int employeeId) throws SQLException {
        boolean rowDeleted = false;
        DBContext dbContext = new DBContext();
        Connection connection = null;
        try {
            connection = dbContext.getConnection();
            if (connection == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            try (PreparedStatement statement = connection.prepareStatement(DELETE_EMPLOYEE)) {
                statement.setInt(1, employeeId);
                rowDeleted = statement.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw e;
        } finally {
            if (connection != null) {

            }
        }
        return rowDeleted;
    }

    public int getTotalEmployees() {
        String sql = "SELECT COUNT(*) AS total_employees FROM employees";
        DBContext dbContext = new DBContext();
        int total = 0;
        try (Connection connection = dbContext.getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql); ResultSet rs = preparedStatement.executeQuery()) {

            if (rs.next()) {
                total = rs.getInt("total_employees");
            }
        } catch (SQLException e) {
            // printSQLException(e); // Hoặc log lỗi
        }
        return total;
    }

    // PHƯƠNG THỨC MAIN ĐỂ KIỂM TRA
    public static void main(String[] args) {
        EmployeeDAO employeeDAO = new EmployeeDAO();
        try {
            // Test selectAllEmployees()
            List<Employee> employees = employeeDAO.selectAllEmployees();
            if (employees != null && !employees.isEmpty()) {
                System.out.println("Danh sách nhân viên:");
                for (Employee emp : employees) {
                    System.out.println(emp);
                }
            } else {
                System.out.println("Không tìm thấy nhân viên nào trong cơ sở dữ liệu.");
            }

            // Test selectEmployeeById (thay thế bằng một ID có thật trong DB của bạn)
            System.out.println("\n--- Kiểm tra tìm nhân viên theo ID ---");
            int testId = 101; // Thay bằng ID nhân viên bạn muốn kiểm tra
            Employee employeeById = employeeDAO.selectEmployeeById(testId);
            if (employeeById != null) {
                System.out.println("Tìm thấy nhân viên ID " + testId + ": " + employeeById.getName() + " - " + employeeById.getPosition());
            } else {
                System.out.println("Không tìm thấy nhân viên với ID " + testId + ".");
            }

        } catch (SQLException e) {
            System.err.println("Lỗi SQL xảy ra trong phương thức main:");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Lỗi không mong muốn xảy ra trong phương thức main:");
            e.printStackTrace();
        }
    }
}
