package thang.itplus.dao;

import thang.itplus.context.DBContext; // Đảm bảo đúng package DBContext của bạn
import thang.itplus.models.TableBooking;
import thang.itplus.models.User; // Sử dụng User model của bạn
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;
import java.sql.Time;

public class TableBookingDao {

    public void addTableBooking(TableBooking booking) throws SQLException {
        String sql = "INSERT INTO DatBan (MaKhachHang, NgayDatBan, GioDatBan, SoLuongNguoi, TrangThaiDatBan) VALUES (?, ?, ?, ?, ?)";
        // Sử dụng try-with-resources để đảm bảo Connection được đóng tự động
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (conn == null) {
                throw new SQLException("Failed to establish database connection.");
            }

            ps.setInt(1, booking.getMaKhachHang());
            ps.setDate(2, booking.getNgayDatBan());
            ps.setTime(3, booking.getGioDatBan());
            ps.setInt(4, booking.getSoLuongNguoi());
            ps.setString(5, booking.getTrangThaiDatBan());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e; // Ném lại ngoại lệ để Servlet có thể xử lý
        }
        // ClassNotFoundException đã được xử lý trong DBContext constructor
        // Nên không cần catch lại ở đây trừ khi bạn muốn xử lý khác
    }

    public List<TableBooking> getAllTableBookings() throws SQLException {
        List<TableBooking> bookings = new ArrayList<>();
        // JOIN với bảng 'users' và lấy các trường cần thiết
        String sql = "SELECT db.*, u.name AS UserName, u.email AS UserEmail, u.phone AS UserPhone " +
                     "FROM DatBan db JOIN users u ON db.MaKhachHang = u.user_id ORDER BY NgayDatBan DESC, GioDatBan DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (conn == null) {
                throw new SQLException("Failed to establish database connection.");
            }

            while (rs.next()) {
                TableBooking booking = new TableBooking();
                booking.setMaDatBan(rs.getInt("MaDatBan"));
                booking.setMaKhachHang(rs.getInt("MaKhachHang"));
                booking.setNgayDatBan(rs.getDate("NgayDatBan"));
                booking.setGioDatBan(rs.getTime("GioDatBan"));
                booking.setSoLuongNguoi(rs.getInt("SoLuongNguoi"));
                booking.setTrangThaiDatBan(rs.getString("TrangThaiDatBan"));

                // Tạo đối tượng User và gán vào booking
                User user = new User();
                user.setUser_id(rs.getInt("MaKhachHang")); // user_id trong bảng users chính là MaKhachHang trong DatBan
                user.setName(rs.getString("UserName"));
                user.setEmail(rs.getString("UserEmail"));
                user.setPhone(rs.getString("UserPhone"));
                // Bạn có thể không cần set password, address, role nếu không hiển thị chúng
                booking.setUser(user);

                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return bookings;
    }

    public void updateBookingStatus(int maDatBan, String newStatus) throws SQLException {
        String sql = "UPDATE DatBan SET TrangThaiDatBan = ? WHERE MaDatBan = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (conn == null) {
                throw new SQLException("Failed to establish database connection.");
            }

            ps.setString(1, newStatus);
            ps.setInt(2, maDatBan);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Phương thức này ước tính sức chứa còn lại dựa trên số lượng người đã được xác nhận đặt bàn.
     * Cần cải thiện logic này để quản lý bàn thực tế hơn (ví dụ: có bảng bàn, sức chứa từng bàn).
     *
     * @param date Ngày đặt bàn.
     * @param time Giờ đặt bàn.
     * @param requestedCapacity Số lượng người muốn đặt.
     * @return Sức chứa còn lại (số lượng người có thể phục vụ thêm).
     * @throws SQLException Nếu có lỗi CSDL.
     */
    public int getAvailableTables(Date date, Time time, int requestedCapacity) throws SQLException {
        // Đây là một logic ĐƠN GIẢN. Trong thực tế, bạn sẽ cần một hệ thống quản lý bàn phức tạp hơn.
        // Ví dụ: Giả định nhà hàng có tổng sức chứa là 50 người.
        // Bạn sẽ kiểm tra tổng số người đã được ĐẶT BÀN VÀ ĐÃ XÁC NHẬN vào thời điểm đó.
        String sql = "SELECT SUM(SoLuongNguoi) FROM DatBan WHERE NgayDatBan = ? AND GioDatBan = ? AND TrangThaiDatBan = N'Đã xác nhận'";
        int totalBookedCapacity = 0;
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (conn == null) {
                throw new SQLException("Failed to establish database connection.");
            }

            ps.setDate(1, date);
            ps.setTime(2, time);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalBookedCapacity = rs.getInt(1); // Lấy tổng số người đã đặt
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        // Giả định tổng sức chứa tối đa của nhà hàng bạn là 50 người
        int maxTotalCapacity = 50; // CON SỐ NÀY CẦN ĐƯỢC CẤU HÌNH THỰC TẾ
        int remainingCapacity = maxTotalCapacity - totalBookedCapacity;

        // Trả về số lượng người còn có thể phục vụ
        return Math.max(0, remainingCapacity); // Đảm bảo không trả về số âm
    }
}