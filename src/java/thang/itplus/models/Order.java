package thang.itplus.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Order {

    private int order_id;
    private int user_id;
    private LocalDateTime order_date;
    private BigDecimal total_amount;
    private Status status;

    private String shipping_address;
    private String phone_number;
    private Integer voucherId;

    // Sửa Order.java để khớp với ENUM trong MySQL
    // Sửa Order.java để có thể trả về giá trị có dấu cho MySQL
    public enum Status {
        PHE_DUYET("Phê duyệt"),
        DANG_GIAO("Đang giao"),
        HOAN_THANH("Hoàn thành"),
        HUY("Hủy");

        private final String dbValue;

        Status(String dbValue) {
            this.dbValue = dbValue;
        }

        public String getDbValue() {
            return dbValue; // <--- Phương thức này sẽ được dùng trong OrderDao
        }
    }

    public Order() {
        this.order_date = LocalDateTime.now();
        this.status = Status.PHE_DUYET;
    }

    // Getters and setters
    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public LocalDateTime getOrder_date() {
        return order_date;
    }

    public void setOrder_date(LocalDateTime order_date) {
        this.order_date = order_date;
    }

    public BigDecimal getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(BigDecimal total_amount) {
        this.total_amount = total_amount;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    // Getters and setters cho thông tin giao hàng
    public String getShipping_address() {
        return shipping_address;
    }

    public void setShipping_address(String shipping_address) {
        this.shipping_address = shipping_address;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }

    public Integer getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(Integer voucherId) {
        this.voucherId = voucherId;
    }
}
