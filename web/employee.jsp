<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách Nhân viên</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

        <style>
            /* CSS THỐNG NHẤT */
            body {
                display: flex;
                min-height: 100vh;
                background-color: #f8f9fa;
            }
            .menu {
                width: 250px;
                position: fixed;
                top: 0;
                bottom: 0;
                left: 0;
                background: #343a40;
                color: white;
                padding-top: 0;
                overflow-y: auto;
                z-index: 1030;
            }
            .menu .text-white {
                background-color: #212529;
            }
            .list-group-item {
                background-color: #343a40;
                color: #adb5bd;
                border: none;
                padding: 12px 20px;
                display: block;
                text-decoration: none;
                transition: background-color 0.3s;
            }
            .list-group-item:hover,
            .list-group-item.active {
                background-color: #007bff;
                color: white;
            }
            .list-group-item.active {
                border-left: 5px solid white;
                padding-left: 15px;
            }
            .list-group-item i {
                margin-right: 10px;
            }
            /* HẾT CSS THỐNG NHẤT */

            /* CSS RIÊNG CỦA QUẢN LÝ NHÂN VIÊN */
            .main-content-wrapper {
                margin-left: 250px;
                width: calc(100% - 250px);
                padding: 20px;
            }
            .navbar-custom {
                background-color: #ffffff;
                border-bottom: 1px solid #dee2e6;
                padding: 15px 20px;
                margin-bottom: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,.05);
            }
            .employee-table-container {
                background-color: #ffffff;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .id-input-group.edit-mode #employee_id {
                background-color: #e9ecef;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body>
        <div class="menu">
            <div class="text-white text-center py-3 mb-3">
                <h4>Admin Panel</h4>
            </div>
            <div class="list-group">
                <a href="${pageContext.request.contextPath}/admin" class="list-group-item list-group-item-action">
                    <i class="bi bi-speedometer2"></i> Quản lý tổng quan hệ thống
                </a>
                <a href="${pageContext.request.contextPath}/admin/profile" class="list-group-item list-group-item-action">
                    <i class="bi bi-person-fill"></i> Quản lý hồ sơ cá nhân
                </a>
                <a href="${pageContext.request.contextPath}/listproducts" class="list-group-item list-group-item-action">
                    <i class="bi bi-box-seam-fill"></i> Quản lý Kho
                </a>
                <a href="${pageContext.request.contextPath}/customer-list" class="list-group-item list-group-item-action">
                    <i class="bi bi-people-fill"></i> Quản lý Khách Hàng
                </a>
                <a href="${pageContext.request.contextPath}/employeelist" class="list-group-item list-group-item-action">
                    <i class="bi bi-person-badge-fill"></i> Quản lý Nhân Viên
                </a>
                <a href="${pageContext.request.contextPath}/orderlist" class="list-group-item list-group-item-action">
                    <i class="bi bi-journal-text"></i> Quản lý Đơn Hàng
                </a>
                <a href="${pageContext.request.contextPath}/supplierlist" class="list-group-item list-group-item-action">
                    <i class="bi bi-truck"></i> Quản lý Nhà Cung Cấp
                </a>
                <a href="${pageContext.request.contextPath}/voucherslist" class="list-group-item list-group-item-action ">
                    <i class="bi bi-gift-fill"></i> Quản lý Mã Giảm Giá
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="list-group-item list-group-item-action">
                    <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                </a>
            </div>
        </div>
        </div>


        <div class="main-content-wrapper" id="mainContentWrapper">


            <%-- Thông báo thành công/lỗi --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>


            <%-- Nội dung chính: Danh sách nhân viên --%>
            <div class="employee-table-container">
                <h2 class="mb-3"><i class="bi bi-person-badge-fill"></i> Quản Lý Nhân Viên</h2>

                <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#employeeModal" id="btnAddEmployee">
                    <i class="bi bi-plus-circle"></i> Thêm Nhân Viên Mới
                </button>

                <p>Tổng số nhân viên: ${listEmployee.size()}</p>

                <table class="table table-striped table-hover" id="employeeTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>User ID</th> 
                            <th>Tên</th>
                            <th>Email</th>
                            <th>SĐT</th>
                            <th>Địa chỉ</th>
                            <th>Vị trí</th> 
                            <th>Lương</th>
                            <th>Ngày thuê</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="employee" items="${listEmployee}">
                            <tr>
                                <td><c:out value="${employee.employee_id}" /></td>
                                <td><c:out value="${employee.user_id}" /></td> 
                                <td><c:out value="${employee.name}" /></td>
                                <td><c:out value="${employee.email}" /></td>
                                <td><c:out value="${employee.phone}" /></td>
                                <td><c:out value="${employee.address}" /></td>
                                <td><c:out value="${employee.position}" /></td> 
                                <td><c:out value="${employee.salary}" /></td>
                                <td><c:out value="${employee.hireDate}" /></td>
                                <td><c:out value="${employee.status}" /></td>
                                <td class="text-center action-buttons">
                                    <button type="button" class="btn btn-warning btn-sm btn-edit-employee"
                                            data-bs-toggle="modal" data-bs-target="#employeeModal"
                                            data-id="<c:out value='${employee.employee_id}' />" title="Sửa">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                    <button type="button" class="btn btn-danger btn-sm btn-delete-employee"
                                            data-bs-toggle="modal" data-bs-target="#deleteConfirmModal"
                                            data-id="<c:out value='${employee.employee_id}' />" title="Xóa">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listEmployee}">
                            <tr>
                                <td colspan="11" class="no-data">Không có nhân viên nào trong hệ thống.</td> 
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>


        </div>

        <%-- Employee Modal (Form for Add/Edit) --%>
        <div class="modal fade" id="employeeModal" tabindex="-1" aria-labelledby="employeeModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="employeeForm" method="post"> 
                        <div class="modal-header">
                            <h5 class="modal-title" id="employeeModalLabel">Thêm Nhân viên mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <%-- ID Input field --%>
                            <div class="mb-3 id-input-group">
                                <label for="employee_id" class="form-label">Employee ID:</label>
                                <input type="number" class="form-control" id="employee_id" name="employee_id" required>
                                <small class="form-text text-danger" id="idHelpText" style="display: none;">ID này đã tồn tại. Vui lòng chọn ID khác.</small>
                            </div>

                            <div class="mb-3">
                                <label for="user_id" class="form-label">User ID:</label>
                                <input type="number" class="form-control" id="user_id" name="user_id" readonly required>
                                <small class="form-text text-muted">User ID này thường liên kết đến một tài khoản người dùng trong bảng 'users'. ID tự tạo khi thêm mới, chỉ hiển thị khi sửa.</small>
                            </div>

                            <%-- THÊM TRƯỜNG MẬT KHẨU VÀ XÁC NHẬN MẬT KHẨU --%>
                            <div class="mb-3 add-only">
                                <label for="password" class="form-label">Mật khẩu:</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>

                            <div class="mb-3 add-only">
                                <label for="confirmPassword" class="form-label">Xác nhận Mật khẩu:</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            <%-- KẾT THÚC TRƯỜNG MẬT KHẨU --%>

                            <div class="mb-3">
                                <label for="name" class="form-label">Tên:</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email:</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>

                            <%-- THÊM TRƯỜNG VAI TRÒ (ROLE) --%>
                            <div class="mb-3">
                                <label for="role" class="form-label">Vai trò (Role):</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="EMPLOYEE">Employee</option>
                                    <option value="ADMIN">Admin</option>
                                    <option value="CUSTOMER" disabled>Customer (Chỉ cho User)</option>
                                </select>
                            </div>
                            <%-- KẾT THÚC TRƯỜNG VAI TRÒ --%>

                            <div class="mb-3">
                                <label for="phone" class="form-label">Số điện thoại:</label>
                                <input type="text" class="form-control" id="phone" name="phone">
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">Địa chỉ:</label>
                                <input type="text" class="form-control" id="address" name="address">
                            </div>


                            <div class="mb-3">
                                <label for="position" class="form-label">Vị trí:</label>
                                <input type="text" class="form-control" id="position" name="position" required>
                            </div>

                            <div class="mb-3">
                                <label for="salary" class="form-label">Lương:</label>
                                <input type="number" step="0.01" class="form-control" id="salary" name="salary" required>
                            </div>

                            <div class="mb-3">
                                <label for="hireDate" class="form-label">Ngày thuê:</label>
                                <input type="date" class="form-control" id="hireDate" name="hireDate">
                            </div>

                            <div class="mb-3">
                                <label for="status" class="form-label">Trạng thái:</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="Active">Active</option>
                                    <option value="On Leave">On Leave</option>
                                    <option value="Terminated">Terminated</option>
                                </select>
                            </div>


                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary" id="saveEmployeeBtn">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%-- Delete Confirmation Modal --%>
        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteConfirmModalLabel">Xác nhận xóa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Bạn có chắc chắn muốn xóa nhân viên này?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <form id="deleteEmployeeForm" method="post" action="${pageContext.request.contextPath}/delete-employee" style="display:inline;">
                            <input type="hidden" name="id" id="deleteEmployeeId">
                            <button type="submit" class="btn btn-danger">Xóa</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>


        <script>
            $(document).ready(function () {
                // Toggle Menu
                $('#btnToggle').click(function () {
                    $('.menu').toggleClass('closed');

                    $('#mainContentWrapper').toggleClass('menu-closed');
                });

                // Active menu item on load based on current URL
                var currentPath = window.location.pathname;
                $('.menu .list-group-item').each(function () {
                    var linkHref = $(this).attr('href');
                    // Check if currentPath contains '/employeelist' for employee management
                    if (linkHref && currentPath.includes('${pageContext.request.contextPath}/employeelist')) {

                        if (linkHref.endsWith('/employeelist')) {
                            $('.menu .list-group-item').removeClass('active');
                            $(this).addClass('active');
                        }

                    }
                });
                // Reset form when modal is hidden
                $('#employeeModal').on('hidden.bs.modal', function () {
                    $('#employeeForm')[0].reset();
                    $('#employee_id').val(''); // Clear ID field
                    $('#user_id').val(''); // Clear User ID field
                    $('#employeeModalLabel').text('Thêm Nhân viên mới');

                    $('#employeeForm').attr('action', '${pageContext.request.contextPath}/add-employee'); // Set action to add

                    // Hiện các trường chỉ dành cho Add
                    $('.add-only').show();
                    $('#password').prop('required', true).val(''); // Yêu cầu và reset mật khẩu
                    $('#confirmPassword').prop('required', true).val('');

                    // Reset ID field for add mode
                    $('#employee_id').prop('readonly', false).removeClass('form-control-plaintext').addClass('form-control');
                    $('.id-input-group').removeClass('edit-mode'); // Remove gray background
                    $('#idHelpText').hide();
                });
                // Handle "Add New Employee" button click
                $('#btnAddEmployee').click(function () {
                    $('#employeeForm')[0].reset();
                    $('#employee_id').val('');
                    $('#user_id').val(''); // Clear User ID field
                    $('#employeeModalLabel').text('Thêm Nhân viên mới');

                    $('#employeeForm').attr('action', '${pageContext.request.contextPath}/add-employee'); // Set action to add

                    // Hiện các trường chỉ dành cho Add
                    $('.add-only').show();
                    $('#password').prop('required', true); // Yêu cầu mật khẩu khi thêm
                    $('#confirmPassword').prop('required', true);

                    // Make ID field editable for add mode
                    $('#employee_id').prop('readonly', false).removeClass('form-control-plaintext').addClass('form-control');
                    $('.id-input-group').removeClass('edit-mode'); // Remove gray background
                    $('#idHelpText').hide(); // Hide error message for ID
                });
                // Handle "Edit Employee" button click
                $('.btn-edit-employee').click(function () {
                    var employeeId = $(this).data('id');

                    $('#employeeModalLabel').text('Sửa thông tin nhân viên');
                    $('#employeeForm').attr('action', '${pageContext.request.contextPath}/update-employee'); // Set action to update

                    // ẨN CÁC TRƯỜNG CHỈ DÀNH CHO ADD (Mật khẩu)
                    $('.add-only').hide();
                    $('#password').prop('required', false).val(''); // Bỏ required và xóa giá trị
                    $('#confirmPassword').prop('required', false).val('');

                    // Set ID field to readonly for edit mode

                    $('#employee_id').val(employeeId).prop('readonly', true).removeClass('form-control').addClass('form-control-plaintext');
                    $('.id-input-group').addClass('edit-mode'); // Add gray background
                    $('#idHelpText').hide(); // Hide error message for ID (shouldn't appear in edit)

                    // Fetch employee data via AJAX

                    $.ajax({
                        url: '${pageContext.request.contextPath}/employee-get',
                        type: 'GET',
                        data: {id: employeeId},

                        dataType: 'json',
                        success: function (employee) {
                            if (employee) {

                                $('#employee_id').val(employee.employee_id);
                                $('#user_id').val(employee.user_id);
                                $('#name').val(employee.name);
                                $('#email').val(employee.email);
                                $('#phone').val(employee.phone);
                                $('#address').val(employee.address);
                                $('#position').val(employee.position); // Fill position field
                                $('#salary').val(employee.salary);

                                // Vai trò (Role) - Cần phải được fetch qua Employee-get hoặc mặc định Employee
                                // Giả định role được lưu trong User và có thể lấy được qua employee.user_role
                                // Nếu không, cần gọi thêm API hoặc sửa GetEmployeeByIdController.
                                if (employee.user_role) {
                                    $('#role').val(employee.user_role);
                                } else {
                                    // Tạm thời set mặc định nếu không có dữ liệu role từ server
                                    $('#role').val('Employee');
                                }

                                // Handle hireDate.
                                // Convert to YYYY-MM-DD for input type="date"
                                if (employee.hireDate) {
                                    var date = new Date(employee.hireDate);
                                    var formattedDate = date.getFullYear() + '-' +
                                            ('0' + (date.getMonth() + 1)).slice(-2) + '-' +
                                            ('0' + date.getDate()).slice(-2);
                                    $('#hireDate').val(formattedDate);
                                } else {
                                    $('#hireDate').val('');
                                }

                                $('#status').val(employee.status);
                            } else {
                                alert('Không tìm thấy thông tin nhân viên. Có thể nhân viên đã bị xóa hoặc lỗi server.');
                                $('#employeeModal').modal('hide');
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("AJAX Error: " + status + " - " + error);
                            alert('Có lỗi khi tải dữ liệu nhân viên. Vui lòng kiểm tra console để biết chi tiết.');
                            $('#employeeModal').modal('hide');
                        }
                    });
                });

                // Handle "Delete Employee" button click (open confirmation modal)
                $('.btn-delete-employee').click(function () {
                    var employeeIdToDelete = $(this).data('id');
                    $('#deleteEmployeeId').val(employeeIdToDelete); // Set hidden input value in delete form
                });

                // (Tùy chọn) Thêm kiểm tra trùng ID khi thêm mới (Client-side check)
                $('#employee_id').on('input', function () {
                    var inputId = $(this).val();
                    var exists = false;
                    // Chỉ kiểm tra khi ở chế độ "thêm mới"
                    if ($('#employeeForm').attr('action').endsWith('/add-employee'))
                    {
                        $('#employeeTable tbody tr').each(function () {
                            var tableId = $(this).find('td:first').text(); // Lấy ID từ cột đầu tiên
                            if (inputId === tableId) {

                                exists = true;
                                return false; // Break loop
                            }

                        });
                    }

                    if (exists) {
                        $('#idHelpText').show();

                        $('#saveEmployeeBtn').prop('disabled', true);
                    } else {
                        $('#idHelpText').hide();
                        $('#saveEmployeeBtn').prop('disabled', false);

                    }
                });

                // Kiểm tra xác nhận mật khẩu
                $('#password, #confirmPassword').on('keyup', function () {
                    if ($('#employeeForm').attr('action').endsWith('/add-employee')) {
                        if ($('#password').val() !== $('#confirmPassword').val() && $('#confirmPassword').val() !== '') {
                            $('#confirmPassword').css('border-color', 'red');
                            $('#saveEmployeeBtn').prop('disabled', true);
                        } else {
                            $('#confirmPassword').css('border-color', '');
                            // Re-check ID duplication logic just in case
                            if ($('#idHelpText').is(':hidden')) {
                                $('#saveEmployeeBtn').prop('disabled', false);
                            }
                        }
                    }
                });
            });
        </script>
    </body>
</html>