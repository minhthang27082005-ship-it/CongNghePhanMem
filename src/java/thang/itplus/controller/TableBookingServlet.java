/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package thang.itplus.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.logging.Level;
import java.util.logging.Logger;
import thang.itplus.dao.TableBookingDao;
import thang.itplus.models.TableBooking;
import thang.itplus.models.User;

/**
 *
 * @author a4698
 */
public class TableBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); // Lấy thông tin người dùng từ session

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            session.setAttribute("bookingMessage", "Vui lòng đăng nhập để đặt bàn.");
            session.setAttribute("bookingAlertType", "danger");
            response.sendRedirect("login"); // Chuyển hướng đến trang đăng nhập
            return;
        }

        String ngayDatBanStr = request.getParameter("bookingDate");
        String gioDatBanStr = request.getParameter("bookingTime");
        String soLuongNguoiStr = request.getParameter("numberOfPeople");

        String message = "";
        String alertType = "";

        try {
            // 2. Chuyển đổi dữ liệu từ form
            Date ngayDatBan = Date.valueOf(ngayDatBanStr);
            Time gioDatBan = Time.valueOf(gioDatBanStr + ":00"); // Thêm giây vì Time.valueOf cần hh:mm:ss
            int soLuongNguoi = Integer.parseInt(soLuongNguoiStr);
            int maKhachHang = user.getUser_id(); // Lấy User ID từ đối tượng User trong session

            TableBookingDao bookingDao = new TableBookingDao();

            // 3. Kiểm tra sức chứa còn lại
            int availableCapacity = bookingDao.getAvailableTables(ngayDatBan, gioDatBan, soLuongNguoi);
            if (soLuongNguoi > availableCapacity) {
                // Nếu số lượng người yêu cầu lớn hơn sức chứa còn lại
                message = "Rất tiếc, chỉ còn đủ chỗ cho " + availableCapacity + " người vào thời gian này. Vui lòng điều chỉnh số lượng hoặc chọn thời gian khác.";
                alertType = "danger";
            } else {
                // 4. Thực hiện đặt bàn nếu đủ chỗ
                TableBooking newBooking = new TableBooking(maKhachHang, ngayDatBan, gioDatBan, soLuongNguoi, "Đang chờ xử lý");
                bookingDao.addTableBooking(newBooking);
                message = "Đặt bàn thành công! Chúng tôi sẽ liên hệ lại để xác nhận.";
                alertType = "success";
            }

        } catch (NumberFormatException e) {
            message = "Dữ liệu nhập vào không hợp lệ. Vui lòng kiểm tra lại số lượng người.";
            alertType = "danger";
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
             message = "Ngày hoặc giờ đặt bàn không hợp lệ. Vui lòng chọn đúng định dạng.";
            alertType = "danger";
            e.printStackTrace();
        } catch (SQLException ex) {
            Logger.getLogger(TableBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // 5. Lưu thông báo vào session (để hiển thị sau khi chuyển hướng)
        session.setAttribute("bookingMessage", message);
        session.setAttribute("bookingAlertType", alertType);

        // 6. Chuyển hướng về trang chủ
        response.sendRedirect("booking.jsp"); // Chuyển hướng về HomeServlet (hoặc home.jsp nếu HomeServlet không làm gì)
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu người dùng truy cập trực tiếp /bookTable bằng GET, chuyển hướng về trang chủ
        response.sendRedirect("booking.jsp");
    }
}