package thang.itplus.models;

import java.util.Date; // Hoặc java.sql.Date tùy thuộc vào cách bạn quản lý

public class Employee {
    private int employee_id;
    private int user_id; // Khóa ngoại tới bảng Users
    private String name;
    private String email;
    private String phone;
    private String address;
    private String position;
    private double salary;
    private Date hireDate; // Sử dụng java.util.Date
    private String status;

    public Employee() {
    }

    // Constructor đầy đủ
    public Employee(int employee_id, int user_id, String name, String email, String phone, String address, String position, double salary, Date hireDate, String status) {
        this.employee_id = employee_id;
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.position = position;
        this.salary = salary;
        this.hireDate = hireDate;
        this.status = status;
    }

    // Constructor không có ID (ví dụ khi thêm mới và ID tự tăng)
    public Employee(int user_id, String name, String email, String phone, String address, String position, double salary, Date hireDate, String status) {
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.position = position;
        this.salary = salary;
        this.hireDate = hireDate;
        this.status = status;
    }

    // --- Getters and Setters ---

    public int getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
    }

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

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Employee{" +
               "employee_id=" + employee_id +
               ", user_id=" + user_id +
               ", name='" + name + '\'' +
               ", email='" + email + '\'' +
               ", phone='" + phone + '\'' +
               ", address='" + address + '\'' +
               ", position='" + position + '\'' +
               ", salary=" + salary +
               ", hireDate=" + hireDate +
               ", status='" + status + '\'' +
               '}';
    }
}