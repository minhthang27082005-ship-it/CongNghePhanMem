package thang.itplus.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import thang.itplus.context.DBContext;
import thang.itplus.models.Order;
import thang.itplus.models.Order.Status;
import thang.itplus.models.OrderDetail;
import thang.itplus.models.Payment;
import thang.itplus.models.Payment.PaymentMethod;
import thang.itplus.models.Voucher;
import thang.itplus.models.Cart;
import thang.itplus.models.CartItem;
import java.util.LinkedHashMap;
import java.util.Map;
import java.time.Month;
import java.sql.Statement;
public class OrderDao {

    // Helper method to map ResultSet to Order object
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrder_id(rs.getInt("order_id"));
        order.setUser_id(rs.getInt("user_id"));

        Timestamp orderTimestamp = rs.getTimestamp("order_date");
        if (orderTimestamp != null) {
            order.setOrder_date(orderTimestamp.toLocalDateTime());
        }

        order.setTotal_amount(rs.getBigDecimal("total_amount"));

        String statusStr = rs.getString("status");
        for (Status s : Status.values()) {
            if (s.getDbValue().equalsIgnoreCase(statusStr)) {
                order.setStatus(s);
                break;
            }
        }

        order.setShipping_address(rs.getString("shipping_address"));
        order.setPhone_number(rs.getString("phone_number"));

        int voucherId = rs.getInt("voucher_id");
        if (!rs.wasNull()) {
            order.setVoucherId(voucherId);
        } else {
            order.setVoucherId(null);
        }

        return order;
    }

    // ========================================================================
    // --- CHỨC NĂNG ADMIN & USER (LIST, ADD, UPDATE, DELETE) ---
    // ========================================================================
    /**
     * Lấy danh sách tất cả Order.
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT order_id, user_id, order_date, total_amount, status, shipping_address, phone_number, voucher_id FROM orders ORDER BY order_date DESC";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Thêm một Order mới.
     */
    public boolean insertOrder(Order order) {
        // Bao gồm order_id nếu nó là trường do người dùng nhập (không phải tự tăng)
        String sql = "INSERT INTO orders (order_id, user_id, order_date, total_amount, status, shipping_address, phone_number, voucher_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        DBContext db = new DBContext();
        int rowsAffected = 0;

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, order.getOrder_id());
            ps.setInt(2, order.getUser_id());
            ps.setTimestamp(3, Timestamp.valueOf(order.getOrder_date()));
            ps.setBigDecimal(4, order.getTotal_amount());
            ps.setString(5, order.getStatus().getDbValue());

            // Lấy thông tin từ đối tượng Order (dù đang gán mặc định trong Controller)
            ps.setString(6, order.getShipping_address());
            ps.setString(7, order.getPhone_number());

            if (order.getVoucherId() != null) {
                ps.setInt(8, order.getVoucherId());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }

            rowsAffected = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowsAffected > 0;
    }

    /**
     * Cập nhật thông tin Order.
     */
    public boolean updateOrder(Order order) {
        String sql = "UPDATE orders SET user_id = ?, order_date = ?, total_amount = ?, status = ?, shipping_address = ?, phone_number = ?, voucher_id = ? WHERE order_id = ?";
        DBContext db = new DBContext();
        int rowsAffected = 0;

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, order.getUser_id());
            ps.setTimestamp(2, Timestamp.valueOf(order.getOrder_date()));
            ps.setBigDecimal(3, order.getTotal_amount());
            ps.setString(4, order.getStatus().getDbValue());

            // Các trường này phải được cung cấp (từ giá trị cũ hoặc giá trị mặc định)
            ps.setString(5, order.getShipping_address());
            ps.setString(6, order.getPhone_number());

            if (order.getVoucherId() != null) {
                ps.setInt(7, order.getVoucherId());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }

            ps.setInt(8, order.getOrder_id()); // WHERE condition

            rowsAffected = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowsAffected > 0;
    }

    /**
     * Xóa một Order dựa trên ID (Đã sửa lỗi Khóa ngoại bằng Transaction).
     */
    public boolean deleteOrder(int orderId) {
        // Lưu ý: Nếu có ràng buộc khóa ngoại (Foreign Key) với order_details hoặc payments,
        // chúng ta cần xóa các dòng liên quan trước trong một transaction.
        String sqlDeletePayments = "DELETE FROM payments WHERE order_id = ?";
        String sqlDeleteOrderDetails = "DELETE FROM order_details WHERE order_id = ?";
        String sqlDeleteOrder = "DELETE FROM orders WHERE order_id = ?";

        DBContext db = new DBContext();
        int rowsAffected = 0;
        Connection conn = null;

        try {
            conn = db.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Xóa Payments (Nếu bảng này tồn tại)
            try (PreparedStatement psPayments = conn.prepareStatement(sqlDeletePayments)) {
                psPayments.setInt(1, orderId);
                psPayments.executeUpdate();
            }

            // 2. Xóa Order Details (Nếu bảng này tồn tại)
            try (PreparedStatement psDetails = conn.prepareStatement(sqlDeleteOrderDetails)) {
                psDetails.setInt(1, orderId);
                psDetails.executeUpdate();
            }

            // 3. Xóa Order chính
            try (PreparedStatement psOrder = conn.prepareStatement(sqlDeleteOrder)) {
                psOrder.setInt(1, orderId);
                rowsAffected = psOrder.executeUpdate();
            }

            conn.commit(); // Thành công: Commit Transaction
        } catch (SQLException e) {
            e.printStackTrace();
            // Xảy ra lỗi: Rollback Transaction
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            // Quan trọng: Phải đóng connection và bật AutoCommit trở lại
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close(); // Đóng kết nối sau khi hoàn thành
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }

        return rowsAffected > 0;
    }

    /**
     * Lấy danh sách Order dựa trên ID của người dùng (Customer View).
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT order_id, user_id, order_date, total_amount, status, shipping_address, phone_number, voucher_id "
                + "FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // ========================================================================
    // --- CÁC CHỨC NĂNG XEM CHI TIẾT VÀ THANH TOÁN (Giữ nguyên) ---
    // ========================================================================
    /**
     * Lấy Order dựa trên ID.
     */
    public Order getOrderById(int orderId) {
        Order order = null;
        String sql = "SELECT order_id, user_id, order_date, total_amount, status, shipping_address, phone_number, voucher_id FROM orders WHERE order_id = ?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = mapResultSetToOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    /**
     * Lấy chi tiết sản phẩm trong đơn hàng (JOIN products).
     */
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.order_detail_id, od.order_id, od.product_id, od.quantity, od.unit_price, "
                + "p.product_name, p.image "
                + "FROM order_details od "
                + "JOIN products p ON od.product_id = p.product_id "
                + "WHERE od.order_id = ?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setOrder_detail_id(rs.getInt("order_detail_id"));
                    detail.setOrder_id(rs.getInt("order_id"));
                    detail.setProduct_id(rs.getInt("product_id"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setUnit_price(rs.getBigDecimal("unit_price"));

                    detail.setProduct_name(rs.getString("product_name"));
                    detail.setProduct_image(rs.getString("image"));

                    details.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    /**
     * Lấy thông tin thanh toán dựa trên Order ID.
     */
    public Payment getPaymentByOrderId(int orderId) {
        Payment payment = null;
        String sql = "SELECT payment_id, order_id, payment_date, amount, payment_method FROM payments WHERE order_id = ?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    payment = new Payment();
                    payment.setPayment_id(rs.getInt("payment_id"));
                    payment.setOrder_id(rs.getInt("order_id"));

                    Timestamp paymentTimestamp = rs.getTimestamp("payment_date");
                    if (paymentTimestamp != null) {
                        payment.setPayment_date(paymentTimestamp.toLocalDateTime());
                    }

                    payment.setAmount(rs.getBigDecimal("amount"));

                    String methodStr = rs.getString("payment_method");
                    if (methodStr != null) {
                        payment.setPayment_method(PaymentMethod.valueOf(methodStr.toUpperCase()));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payment;
    }

    /**
     * Lấy thông tin Voucher dựa trên ID.
     */
    public Voucher getVoucherById(int voucherId) {
        Voucher voucher = null;
        String sql = "SELECT voucher_id, code, discount_value, min_order_amount FROM vouchers WHERE voucher_id = ?";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    voucher = new Voucher();
                    voucher.setVoucher_id(rs.getInt("voucher_id"));
                    voucher.setCode(rs.getString("code"));
                    voucher.setDiscountValue(rs.getDouble("discount_value"));
                    voucher.setMinOrderAmount(rs.getDouble("min_order_amount"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return voucher;
    }

    public boolean processCheckout(Order order, Cart cart, Payment payment) {
        Connection conn = null;
        DBContext db = new DBContext();

        try {
            conn = db.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Chèn đơn hàng và lấy ID tự động tăng
            String sqlOrder = "INSERT INTO orders (user_id, order_date, total_amount, status, shipping_address, phone_number, voucher_id) "
                    + "VALUES (?, NOW(), ?, ?, ?, ?, ?)";
            PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUser_id());
            psOrder.setBigDecimal(2, order.getTotal_amount());
            psOrder.setString(3, order.getStatus().getDbValue());
            psOrder.setString(4, order.getShipping_address());
            psOrder.setString(5, order.getPhone_number());
            if (order.getVoucherId() != null) {
                psOrder.setInt(6, order.getVoucherId());
            } else {
                psOrder.setNull(6, java.sql.Types.INTEGER);
            }
            psOrder.executeUpdate();

            // Lấy ID vừa tạo
            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
                order.setOrder_id(orderId);
            }

            // 2. Chèn chi tiết đơn hàng và TRỪ KHO
            String sqlDetail = "INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";

            PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
            PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock);

            for (CartItem item : cart.getListItems().values()) {
                // Lưu chi tiết
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getProduct().getProduct_id());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setBigDecimal(4, new BigDecimal(item.getProduct().getPrice()));
                psDetail.addBatch();

                // Trừ kho (Đảm bảo cột trong DB là 'stock')
                psStock.setInt(1, item.getQuantity());
                psStock.setInt(2, item.getProduct().getProduct_id());
                psStock.setInt(3, item.getQuantity()); // Điều kiện stock >= số lượng mua
                psStock.addBatch();
            }
            psDetail.executeBatch();

            int[] stockResults = psStock.executeBatch();
            for (int res : stockResults) {
                if (res == 0) {
                    throw new SQLException("Một số sản phẩm đã hết hàng!");
                }
            }

            // 3. Chèn thông tin thanh toán
            String sqlPayment = "INSERT INTO payments (order_id, payment_date, amount, payment_method) VALUES (?, NOW(), ?, ?)";
            PreparedStatement psPayment = conn.prepareStatement(sqlPayment);
            psPayment.setInt(1, orderId);
            psPayment.setBigDecimal(2, payment.getAmount());
            psPayment.setString(3, payment.getPayment_method().name());
            psPayment.executeUpdate();

            // 4. CẬP NHẬT SỐ LẦN DÙNG VOUCHER
            if (order.getVoucherId() != null) {
                String sqlVoucher = "UPDATE vouchers SET times_used = times_used + 1 WHERE voucher_id = ?";
                PreparedStatement psVoucher = conn.prepareStatement(sqlVoucher);
                psVoucher.setInt(1, order.getVoucherId());
                psVoucher.executeUpdate();
            }

            conn.commit(); // Thành công thì lưu tất cả
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    private static final String UPDATE_ORDER_STATUS = "UPDATE orders SET status = ? WHERE order_id = ?";

    public void updateOrderStatus(int orderId, Order.Status status) throws SQLException {
        DBContext db = new DBContext();
        String statusDbValue = status.getDbValue();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            ps.setString(1, statusDbValue);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }

    public boolean insertPayment(int orderId, BigDecimal amount, String paymentMethod) throws SQLException {
        // Giả định payment_method là string "CASH"
        String sql = "INSERT INTO payments (order_id, payment_date, amount, payment_method) VALUES (?, NOW(), ?, ?)";
        DBContext db = new DBContext();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setBigDecimal(2, amount);
            ps.setString(3, paymentMethod.toUpperCase()); // Ví dụ: "CASH"

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy tổng số Order đã được tạo.
     */
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) AS total_orders FROM orders";
        DBContext db = new DBContext();
        int total = 0;

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total_orders");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    /**
     * Lấy tổng doanh thu từ các đơn hàng đã HOÀN THÀNH.
     */
    public BigDecimal getTotalRevenue() {
        // ⭐ ĐÃ SỬA: Sử dụng giá trị Enum chính xác từ Order.java: "Hoàn thành"
        String completedStatus = Order.Status.HOAN_THANH.getDbValue();
        String sql = "SELECT SUM(total_amount) AS total_revenue FROM orders WHERE status = ?";
        DBContext db = new DBContext();
        BigDecimal revenue = BigDecimal.ZERO;

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, completedStatus); // Gán giá trị "Hoàn thành"

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal result = rs.getBigDecimal("total_revenue");
                    if (result != null) {
                        revenue = result;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenue;
    }

    /**
     * Lấy dữ liệu doanh thu theo tháng trong 12 tháng gần nhất (chỉ tính đơn
     * hàng HOÀN THÀNH).
     */
    public Map<String, BigDecimal> getMonthlyRevenueData() {
        String completedStatus = Order.Status.HOAN_THANH.getDbValue(); // ⭐ ĐÃ SỬA

        // Truy vấn nhóm theo năm và tháng, chỉ lấy đơn hàng "Hoàn thành" trong 12 tháng gần nhất
        String sql = "SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(total_amount) AS monthly_revenue "
                + "FROM orders "
                + "WHERE status = ? AND order_date >= DATE_SUB(NOW(), INTERVAL 12 MONTH) "
                + "GROUP BY year, month "
                + "ORDER BY year ASC, month ASC";

        DBContext db = new DBContext();
        Map<String, BigDecimal> monthlyData = new LinkedHashMap<>();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, completedStatus); // Gán giá trị "Hoàn thành"

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int year = rs.getInt("year");
                    int monthValue = rs.getInt("month");
                    BigDecimal revenue = rs.getBigDecimal("monthly_revenue");

                    String monthName = Month.of(monthValue).toString().substring(0, 3) + "/" + year;
                    monthlyData.put(monthName, revenue);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return monthlyData;
    }

    public static void main(String[] args) {
        // Logic main
    }
}
