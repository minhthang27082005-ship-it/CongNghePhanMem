package thang.itplus.models;

import java.sql.Timestamp; // Dùng cho startDate và endDate

/**
 * Model cho Voucher (Mã giảm giá)
 */
public class Voucher {

    // --- ENUM cho Loại giảm giá ---
    // ⭐ ĐÃ SỬA: Bổ sung percentage_order và fixed_amount để tương thích với logic JSP/Business
    public enum DiscountType {
        percentage_product, // Giảm % trên sản phẩm
        free_shipping,      // Miễn phí vận chuyển
        percentage_order,   // Giảm % trên tổng đơn hàng
        fixed_amount        // Giảm số tiền cố định trên tổng đơn hàng
    }

    private int voucher_id;
    private String code;
    private DiscountType discountType;
    private double discountValue; // Giá trị: % hoặc số tiền cố định
    private double minOrderAmount;
    private int usageLimit; // Tổng số lần có thể dùng
    private int timesUsed; // Số lần đã dùng
    private Timestamp startDate;
    private Timestamp endDate;
    private boolean isActive;

    public Voucher() {
    }

    // Constructor đầy đủ
    public Voucher(int voucher_id, String code, DiscountType discountType, double discountValue, 
                   double minOrderAmount, int usageLimit, int timesUsed, Timestamp startDate, 
                   Timestamp endDate, boolean isActive) {
        this.voucher_id = voucher_id;
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderAmount = minOrderAmount;
        this.usageLimit = usageLimit;
        this.timesUsed = timesUsed;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
    }

    // Constructor cho việc thêm mới (không cần ID, timesUsed=0, isActive=true)
     public Voucher(String code, DiscountType discountType, double discountValue, 
                   double minOrderAmount, int usageLimit, Timestamp startDate, 
                   Timestamp endDate) {
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderAmount = minOrderAmount;
        this.usageLimit = usageLimit;
        this.startDate = startDate;
        this.endDate = endDate;
        this.timesUsed = 0;
        this.isActive = true;
    }
    
    // --- Getters and Setters ---
    public int getVoucher_id() { return voucher_id; }
    public void setVoucher_id(int voucher_id) { this.voucher_id = voucher_id; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; } // Sửa lại: Dùng this.code = code
    
    public DiscountType getDiscountType() { return discountType; }
    public void setDiscountType(DiscountType discountType) { this.discountType = discountType; }
    
    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }
    
    public double getMinOrderAmount() { return minOrderAmount; }
    public void setMinOrderAmount(double minOrderAmount) { this.minOrderAmount = minOrderAmount; }
    
    public int getUsageLimit() { return usageLimit; }
    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }
    
    public int getTimesUsed() { return timesUsed; }
    public void setTimesUsed(int timesUsed) { this.timesUsed = timesUsed; }
    
    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }
    
    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}