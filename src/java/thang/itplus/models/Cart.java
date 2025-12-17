package thang.itplus.models;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Cart {

    private HashMap<Integer, CartItem> listCart = new HashMap<>();

    public void addItem(Product product, int quantity) {
        if (listCart.containsKey(product.getProduct_id())) {
            CartItem item = listCart.get(product.getProduct_id());
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            // Giả định CartItem constructor đã được sửa để lưu unitPrice tĩnh
            listCart.put(product.getProduct_id(), new CartItem(product, quantity));
        }
    }

    public void removeItem(Product product) {
        listCart.remove(product.getProduct_id());
    }

    public CartItem getItemCart(int productId) {
        if (listCart.containsKey(productId)) {
            return listCart.get(productId);
        }
        return null;
    }

    public HashMap<Integer, CartItem> getListItems() {
        return listCart;
    }

    public int getTotalProduct() {
        return listCart.size();
    }

    // Phương thức gốc tính tổng tiền (double)
    public double getTotalPrice() {
        return calculateTotalPrice();
    }

    // Tính tổng tiền bằng double (dùng giá trị từ CartItem.getTotalPrice() đã được sửa)
    public double calculateTotalPrice() {
        double total = 0;
        for (CartItem item : listCart.values()) {
            // Dòng này phải gọi phương thức trong CartItem đã được sửa để dùng giá tĩnh (unitPrice)
            total += item.getTotalPrice();
        }
        return total;
    }

    public void updateItemQuantity(int productId, int quantity) {

        CartItem item = listCart.get(productId);

        if (item != null) {

            item.setQuantity(item.getQuantity() + quantity);

            if (item.getQuantity() <= 0) {

                listCart.remove(productId);

            }

        }

    }

    public List<CartItem> getItems() {
        return new ArrayList<>(listCart.values());
    }

    /**
     * Phương thức chính được PaymentServlet gọi. Sử dụng BigDecimal để chính
     * xác. Đã khắc phục lỗi logic cộng dồn bằng cách gọi calculateTotalPrice().
     */
    public BigDecimal calculateTotalAmount() {
        // Lấy giá trị double đã được tính toán chính xác
        double totalDouble = this.calculateTotalPrice();

        // DEBUG: In ra để xác nhận giá trị tính toán
        System.out.println(">>> DEBUG FINAL CALCULATED TOTAL (Double): " + totalDouble);

        // Chuyển đổi sang BigDecimal một cách an toàn
        if (totalDouble <= 0) {
            return BigDecimal.ZERO;
        }
        // Chuyển đổi double sang String trước khi tạo BigDecimal là cách an toàn nhất
        return new BigDecimal(String.valueOf(totalDouble));
    }
}
