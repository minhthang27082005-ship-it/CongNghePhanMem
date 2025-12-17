package thang.itplus.models;

public class CartItem {

    private Product product;  // Đối tượng Product (sản phẩm)
    private int quantity;     // Số lượng sản phẩm trong giỏ
    
    private double unitPrice; // <--- TRƯỜNG MỚI: Lưu giá tĩnh tại thời điểm thêm hàng

    // Constructor
    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        this.unitPrice = product.getPrice(); // <--- LẤY GIÁ CỐ ĐỊNH TỪ PRODUCT
    }

    // Getters và Setters
    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    // Getter cho giá tĩnh (nếu cần)
    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    // Tính tổng giá trị của sản phẩm trong giỏ (sử dụng giá tĩnh)
    @Deprecated // Báo hiệu rằng phương thức này nên được thay thế bằng unitPrice * quantity
    public double getTotalPrice() {
        // Sử dụng giá tĩnh để đảm bảo tính toán luôn đúng
        return this.unitPrice * quantity; 
        // return product.getPrice() * quantity; // Dòng cũ có thể bị lỗi khi product.getPrice() là 0
    }

    // Kiểm tra nếu sản phẩm này giống với một sản phẩm khác trong giỏ hàng
    public boolean isEqualTo(Product product) {
        return this.product.getProduct_id() == product.getProduct_id();
    }
}