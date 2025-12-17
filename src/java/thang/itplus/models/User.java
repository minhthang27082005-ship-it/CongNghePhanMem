package thang.itplus.models;

import java.sql.Timestamp; // Cần thiết để lưu trữ thời điểm khóa

/**
 *
 * @author a4698
 */
public class User {
    private int user_id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String address;
    private Role role; // Sử dụng enum Role
    
    // BỔ SUNG: Các thuộc tính cần thiết cho chức năng khóa tài khoản
    private int loginAttempts;
    private Timestamp lockoutUntil; // Lưu thời điểm tài khoản được mở khóa tự động

    public User() {
    }

    // Constructor đầy đủ
    public User(int user_id, String name, String email, String password, String phone, String address, Role role) {
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.address = address;
        this.role = role;
        // Các trường mới sẽ được gán thông qua Setter sau khi lấy từ DB
    }

    // --- Getters and Setters ---

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
    
    // BỔ SUNG: Getters và Setters cho các thuộc tính khóa
    public int getLoginAttempts() {
        return loginAttempts;
    }

    public void setLoginAttempts(int loginAttempts) {
        this.loginAttempts = loginAttempts;
    }

    public Timestamp getLockoutUntil() {
        return lockoutUntil;
    }

    public void setLockoutUntil(Timestamp lockoutUntil) {
        this.lockoutUntil = lockoutUntil;
    }
    
    // ĐIỀU CHỈNH: Thêm ENUM_ROLE.EMPLOYEE và đổi tên các giá trị thành UPPERCASE
    public enum Role {
        customer, // Trước đây là "customer"
        admin,    // Trước đây là "admin"
        EMPLOYEE  // Thêm giá trị này
    }

    @Override
    public String toString() {
        return "User{" +
               "user_id=" + user_id +
               ", name='" + name + '\'' +
               ", email='" + email + '\'' +
               ", password='" + (password != null ? "[PROTECTED]" : "null") + '\'' + 
               ", phone='" + phone + '\'' +
               ", address='" + address + '\'' +
               ", role=" + role +
               ", loginAttempts=" + loginAttempts + // Hiển thị thông tin mới
               ", lockoutUntil=" + lockoutUntil +   // Hiển thị thông tin mới
               '}';
    }
}