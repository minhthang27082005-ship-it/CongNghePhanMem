package thang.itplus.dao;

import thang.itplus.context.DBContext;
import thang.itplus.models.CarouselItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarouselItemDao {

    // Phương thức lấy tất cả các CarouselItem từ cơ sở dữ liệu
    public List<CarouselItem> getAllItems() {
        List<CarouselItem> items = new ArrayList<>();
        String query = "SELECT * FROM carousel_items";

        // ⭐ ĐÃ SỬA: Sử dụng try-with-resources cho Connection, PreparedStatement, ResultSet
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CarouselItem item = new CarouselItem();
                item.setId(rs.getInt("id"));
                item.setTitle(rs.getString("title"));
                item.setImageUrl(rs.getString("image_url"));
                item.setLink1(rs.getString("link1"));
                item.setLink2(rs.getString("link2"));

                items.add(item);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn carousel_items: " + e.getMessage());
            e.printStackTrace();
        } 

        return items;
    }

    public static void main(String[] args) {
        CarouselItemDao dao = new CarouselItemDao();
        List<CarouselItem> items = dao.getAllItems();

        if (items != null && !items.isEmpty()) {
            System.out.println("Danh sách CarouselItem:");
            for (CarouselItem item : items) {
                System.out.println("ID: " + item.getId());
                System.out.println("Title: " + item.getTitle());
                System.out.println("Image URL: " + item.getImageUrl());
                System.out.println("Link 1: " + item.getLink1());
                System.out.println("Link 2: " + item.getLink2());
                System.out.println("-------------------------------");
            }
        } else {
            System.out.println("Không có dữ liệu trong cơ sở dữ liệu.");
        }
    }
}
