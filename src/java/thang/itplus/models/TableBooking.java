package thang.itplus.models;

import java.sql.Date;
import java.sql.Time;

public class TableBooking {
    private int maDatBan;
    private int maKhachHang; // Đây là user_id từ bảng 'users'
    private Date ngayDatBan;
    private Time gioDatBan;
    private int soLuongNguoi;
    private String trangThaiDatBan;
    private User user; // Để lưu thông tin người dùng liên quan nếu cần

    public TableBooking() {
    }

    public TableBooking(int maDatBan, int maKhachHang, Date ngayDatBan, Time gioDatBan, int soLuongNguoi, String trangThaiDatBan) {
        this.maDatBan = maDatBan;
        this.maKhachHang = maKhachHang;
        this.ngayDatBan = ngayDatBan;
        this.gioDatBan = gioDatBan;
        this.soLuongNguoi = soLuongNguoi;
        this.trangThaiDatBan = trangThaiDatBan;
    }

    // Constructor cho việc tạo đặt bàn mới (MaDatBan sẽ được auto-increment)
    public TableBooking(int maKhachHang, Date ngayDatBan, Time gioDatBan, int soLuongNguoi, String trangThaiDatBan) {
        this.maKhachHang = maKhachHang;
        this.ngayDatBan = ngayDatBan;
        this.gioDatBan = gioDatBan;
        this.soLuongNguoi = soLuongNguoi;
        this.trangThaiDatBan = trangThaiDatBan;
    }

    // --- Getters and Setters ---
    public int getMaDatBan() {
        return maDatBan;
    }

    public void setMaDatBan(int maDatBan) {
        this.maDatBan = maDatBan;
    }

    public int getMaKhachHang() {
        return maKhachHang;
    }

    public void setMaKhachHang(int maKhachHang) {
        this.maKhachHang = maKhachHang;
    }

    public Date getNgayDatBan() {
        return ngayDatBan;
    }

    public void setNgayDatBan(Date ngayDatBan) {
        this.ngayDatBan = ngayDatBan;
    }

    public Time getGioDatBan() {
        return gioDatBan;
    }

    public void setGioDatBan(Time gioDatBan) {
        this.gioDatBan = gioDatBan;
    }

    public int getSoLuongNguoi() {
        return soLuongNguoi;
    }

    public void setSoLuongNguoi(int soLuongNguoi) {
        this.soLuongNguoi = soLuongNguoi;
    }

    public String getTrangThaiDatBan() {
        return trangThaiDatBan;
    }

    public void setTrangThaiDatBan(String trangThaiDatBan) {
        this.trangThaiDatBan = trangThaiDatBan;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}