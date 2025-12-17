package thang.itplus.controller;

import com.google.gson.Gson; // Cần thư viện Gson để chuyển đổi đối tượng Java sang JSON
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;

import thang.itplus.dao.EmployeeDAO;
import thang.itplus.models.Employee;

/**
 * Servlet để lấy thông tin chi tiết của một nhân viên dựa trên ID.
 * Trả về dữ liệu dưới dạng JSON cho các yêu cầu AJAX.
 *
 * @author a4698
 */
// @jakarta.servlet.annotation.WebServlet("/employee-get")
public class GetEmployeeByIdController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EmployeeDAO employeeDAO;
    private Gson gson; // Để chuyển đổi đối tượng Employee sang JSON

    @Override
    public void init() throws ServletException {
        super.init();
        employeeDAO = new EmployeeDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int employeeId = Integer.parseInt(request.getParameter("id"));
            Employee employee = employeeDAO.selectEmployeeById(employeeId);

            if (employee != null) {
                String employeeJson = gson.toJson(employee);
                out.print(employeeJson);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Employee not found\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid employee ID format\"}");
            System.err.println("NumberFormatException in GetEmployeeByIdController: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Database error occurred: " + e.getMessage() + "\"}");
            System.err.println("SQLException in GetEmployeeByIdController: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"An unexpected error occurred: " + e.getMessage() + "\"}");
            System.err.println("General Exception in GetEmployeeByIdController: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.flush();
                out.close();
            }
        }
    }
}