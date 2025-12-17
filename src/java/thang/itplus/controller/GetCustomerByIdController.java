/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package thang.itplus.controller;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import thang.itplus.dao.CustomerDAO;
import thang.itplus.models.User;
import java.sql.SQLException;

/**
 *
 * @author a4698
 */
public class GetCustomerByIdController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;
    private Gson gson = new Gson();

    public void init() {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        int id = 0;
        User user = null;

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            id = Integer.parseInt(idParam);
            user = customerDAO.selectUserById(id);
        } catch (NumberFormatException e) {
            System.err.println("LỖI: Tham số ID không phải là số: " + idParam);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"ID không hợp lệ.\"}");
            return;
        } catch (Exception e) {
            System.err.println("LỖI không mong muốn khi lấy user từ DAO (ID: " + id + "): " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Lỗi server khi tải dữ liệu khách hàng.\"}");
            return;
        }

        if (user != null) {
            out.print(gson.toJson(user));
            System.out.println("DEBUG: Đã trả về JSON cho user ID: " + id);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{}");
            System.out.println("DEBUG: Không tìm thấy user với ID: " + id + ", trả về JSON rỗng.");
        }
        out.flush();
    }
}
