package thang.itplus.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payment {

    private int payment_id;
    private int order_id;
    private BigDecimal amount;
    private PaymentMethod payment_method;
    private LocalDateTime payment_date;

    public enum PaymentMethod {
        CREDIT_CARD, PAYPAL, CASH_ON_DELIVERY
    }

    // Getters and setters
    public int getPayment_id() { return payment_id; }
    public void setPayment_id(int payment_id) { this.payment_id = payment_id; }
    public int getOrder_id() { return order_id; }
    public void setOrder_id(int order_id) { this.order_id = order_id; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public PaymentMethod getPayment_method() { return payment_method; }
    public void setPayment_method(PaymentMethod payment_method) { this.payment_method = payment_method; }
    public LocalDateTime getPayment_date() { return payment_date; }
    public void setPayment_date(LocalDateTime payment_date) { this.payment_date = payment_date; }
}