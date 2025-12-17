package thang.itplus.models;

import java.math.BigDecimal; // Quan trọng cho tiền tệ

public class OrderDetail {
    private int order_detail_id; // PK
    private int order_id;        // FK
    private int product_id;      // FK
    private int quantity;        // Số lượng
    private BigDecimal unit_price; // Giá bán tại thời điểm mua (DECIMAL trong DB)

    // THUỘC TÍNH BỔ SUNG CHO VIỆC HIỂN THỊ (lấy từ bảng 'products')
    private String product_name;
    private String product_image; // Giả định tên cột ảnh là 'Image' trong bảng products

    
    // Getters and Setters
    public int getOrder_detail_id() { return order_detail_id; }
    public void setOrder_detail_id(int order_detail_id) { this.order_detail_id = order_detail_id; }
    
    public int getOrder_id() { return order_id; }
    public void setOrder_id(int order_id) { this.order_id = order_id; }
    
    public int getProduct_id() { return product_id; }
    public void setProduct_id(int product_id) { this.product_id = product_id; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    // Sử dụng BigDecimal cho tiền tệ
    public BigDecimal getUnit_price() { return unit_price; }
    public void setUnit_price(BigDecimal unit_price) { this.unit_price = unit_price; }

    // Getters and Setters cho thuộc tính hiển thị
    public String getProduct_name() { return product_name; }
    public void setProduct_name(String product_name) { this.product_name = product_name; }

    public String getProduct_image() { return product_image; }
    public void setProduct_image(String product_image) { this.product_image = product_image; }
}