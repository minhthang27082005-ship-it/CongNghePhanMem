package thang.itplus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

import thang.itplus.dao.EmployeeDAO;
import thang.itplus.dao.CustomerDAO; // Cần để xóa User liên quan

/**
 * Servlet để xóa nhân viên.
 * Xử lý yêu cầu từ employee.jsp (thường là POST từ một form hoặc AJAX).
 *
 * @author a4698
 */
// @jakarta.servlet.annotation.WebServlet("/delete-employee")
public class DeleteEmployeeController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private EmployeeDAO employeeDAO;
    private CustomerDAO userDAO; // Để xóa user liên quan

    @Override
    public void init() throws ServletException {
        super.init(); // Thêm super.init()
        employeeDAO = new EmployeeDAO();
        userDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thông thường, việc xóa nên được xử lý bằng POST để tránh các vấn đề bảo mật.
        // Chuyển hướng về trang danh sách nhân viên nếu có GET request không hợp lệ.
        response.sendRedirect(request.getContextPath() + "/employeelist");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        try {
            // Lấy ID nhân viên từ request.getParameter (tên tham số là "id" từ form/AJAX)
            int employeeId = Integer.parseInt(request.getParameter("id"));

            // Lấy thông tin nhân viên để có userId trước khi xóa
            thang.itplus.models.Employee employeeToDelete = employeeDAO.selectEmployeeById(employeeId);
            if (employeeToDelete == null) {
                session.setAttribute("errorMessage", "Không tìm thấy nhân viên để xóa.");
                response.sendRedirect(request.getContextPath() + "/employeelist");
                return;
            }
            int userId = employeeToDelete.getUser_id();

            // Thao tác xóa: Cần xóa User trước (nếu User là cha của Employee)
//            boolean userDeleted = false;
//            if (userId != 0) { // Giả định userId 0 là không hợp lệ hoặc không có user liên kết
//                userDeleted = userDAO.deleteUser(userId); // Giả định CustomerDAO có phương thức deleteUser
//            }

            boolean employeeDeleted = employeeDAO.deleteEmployee(employeeId);

            if (employeeDeleted) {
                if ( userId == 0) { // Nếu user được xóa hoặc không có user liên kết
                    session.setAttribute("successMessage", "Xóa nhân viên thành công!");
                } else {
                    session.setAttribute("successMessage", "Xóa nhân viên thành công, nhưng không thể xóa tài khoản người dùng liên quan.");
                }
            } else {
                session.setAttribute("errorMessage", "Không thể xóa nhân viên. Vui lòng thử lại.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID nhân viên không hợp lệ.");
            System.err.println("NumberFormatException in DeleteEmployeeController: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu khi xóa nhân viên: " + e.getMessage());
            System.err.println("SQLException in DeleteEmployeeController: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi không xác định khi xóa nhân viên: " + e.getMessage());
            System.err.println("General Exception in DeleteEmployeeController: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/employeelist");
    }
}