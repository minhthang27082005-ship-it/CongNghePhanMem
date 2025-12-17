package thang.itplus.models;

import java.time.LocalDateTime;

public class InventoryTransaction {

    private int transactionId;
    private int productId;
    private LocalDateTime transactionDate;
    private String type; // Ví dụ: "NHAP" hoặc "XUAT"
    private int quantity;
    private int employeeId;
    private String employeeName; // Lấy từ JOIN users trong InventoryDao

    // Constructor mặc định
    public InventoryTransaction() {
    }

    // Constructor đầy đủ (tùy chọn)
    public InventoryTransaction(int transactionId, int productId, LocalDateTime transactionDate, String type, int quantity, int employeeId, String employeeName) {
        this.transactionId = transactionId;
        this.productId = productId;
        this.transactionDate = transactionDate;
        this.type = type;
        this.quantity = quantity;
        this.employeeId = employeeId;
        this.employeeName = employeeName;
    }

    // --- Getters và Setters ---

    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public LocalDateTime getTransactionDate() {
        return transactionDate;
    }

    // Lưu ý: Sử dụng LocalDateTime để xử lý ngày giờ từ CSDL (rs.getTimestamp().toLocalDateTime())
    public void setTransactionDate(LocalDateTime transactionDate) {
        this.transactionDate = transactionDate;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }
    
    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }
}