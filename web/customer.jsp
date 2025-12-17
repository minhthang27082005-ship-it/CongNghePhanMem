<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách Khách hàng</title>
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

            /* CSS RIÊNG CỦA QUẢN LÝ KHÁCH HÀNG */
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
            .customer-table-container {
                background-color: #ffffff;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .id-input-group.edit-mode #id {
                background-color: #e9ecef;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body>
        <div class="menu" id="menu">
            <div class="text-white text-center py-3 mb-3" style="background-color: #212529;">
                <h4>Admin Panel</h4>
            </div>
            <div class="list-group">
                <a href="${pageContext.request.contextPath}/admin" class="list-group-item list-group-item-action active">
                    <i class="bi bi-speedometer2"></i> Tổng quan hệ thống
                </a>
                <a href="${pageContext.request.contextPath}/admin/profile" class="list-group-item list-group-item-action">
                    <i class="bi bi-person-fill"></i> Hồ sơ cá nhân
                </a>
                <a href="${pageContext.request.contextPath}/listproducts" class="list-group-item list-group-item-action">
                    <i class="bi bi-box-seam-fill"></i> Quản lý Sản Phẩm
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
                <a href="${pageContext.request.contextPath}/voucherslist" class="list-group-item list-group-item-action">
                    <i class="bi bi-gift-fill"></i> Quản lý Mã Giảm Giá
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="list-group-item list-group-item-action">
                    <i class="bi bi-box-arrow-right"></i> Đăng Xuất
                </a>
            </div>
        </div>

        <div class="main-content-wrapper" id="mainContentWrapper">


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


            <div class="customer-table-container">
                <h2 class="mb-3"><i class="bi bi-people-fill"></i> Quản Lý Khách Hàng</h2>

                <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#customerModal" id="btnAddCustomer">
                    <i class="bi bi-plus-circle"></i> Thêm Khách Hàng Mới
                </button>

                <p>Tổng số khách hàng: ${listCustomers.size()}</p>
                <table class="table table-striped table-hover" id="customerTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>Email</th>
                            <th>SĐT</th>
                            <th>Địa chỉ</th>
                            <th>Vai trò</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${listCustomers}">
                            <tr>
                                <td><c:out value="${user.user_id}" /></td>
                                <td><c:out value="${user.name}" /></td>
                                <td><c:out value="${user.email}" /></td>
                                <td><c:out value="${user.phone}" /></td>
                                <td><c:out value="${user.address}" /></td>
                                <td><c:out value="${user.role}" /></td>
                                <td class="text-center action-buttons">
                                    <button type="button" class="btn btn-warning btn-sm btn-edit-customer"
                                            data-bs-toggle="modal" data-bs-target="#customerModal"
                                            data-id="<c:out value='${user.user_id}' />" title="Sửa">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                    <%-- Nút xóa đã được loại bỏ do DAO không còn chức năng deleteUser --%>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listCustomers}">
                            <tr>
                                <td colspan="7" class="no-data">Không có khách hàng nào trong hệ thống.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </div>

        <%-- Customer Modal (Form for Add/Edit) - ĐÃ SỬA GIAO DIỆN --%>
        <div class="modal fade" id="customerModal" tabindex="-1" aria-labelledby="customerModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="customerForm" method="post"> <%-- Action set by JS --%>
                        <div class="modal-header">
                            <h5 class="modal-title" id="customerModalLabel">Thêm Khách hàng mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <%-- ID Input field --%>
                            <div class="mb-3 id-input-group">
                                <label for="id" class="col-form-label">ID:</label>
                                <input type="number" class="form-control" id="id" name="id" required>
                                <small class="form-text text-danger" id="idHelpText" style="display: none;">ID này đã tồn tại. Vui lòng chọn ID khác.</small>
                            </div>

                            <div class="mb-3">
                                <label for="name" class="col-form-label">Tên:</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="col-form-label">Email:</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="col-form-label">Mật khẩu:</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                                <small class="form-text text-muted" id="passwordHelp">
                                    <span class="edit-only" style="display: none;">Để trống nếu không đổi mật khẩu.</span>
                                    <span class="add-only">Mật khẩu bắt buộc cho khách hàng mới.</span>
                                </small>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="col-form-label">Số điện thoại:</label>
                                <input type="text" class="form-control" id="phone" name="phone">
                            </div>

                            <div class="mb-3">
                                <label for="address" class="col-form-label">Địa chỉ:</label>
                                <input type="text" class="form-control" id="address" name="address">
                            </div>

                            <div class="mb-3">
                                <label for="role" class="col-form-label">Vai trò:</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="customer">Khách hàng</option>
                                    <option value="admin">Admin</option>
                                    <option value="employee">Nhân viên</option>
                                </select>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary" id="saveCustomerBtn">Lưu</button>
                        </div>
                    </form>
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
                    if (linkHref && currentPath.includes('${pageContext.request.contextPath}/customer-list')) {
                        if (linkHref.endsWith('/customer-list')) {
                            $('.menu .list-group-item').removeClass('active');
                            $(this).addClass('active');
                        }
                    }
                });
                // Reset form when modal is hidden
                $('#customerModal').on('hidden.bs.modal', function () {
                    $('#customerForm')[0].reset();
                    $('#id').val(''); // Clear ID field
                    $('#customerModalLabel').text('Thêm Khách hàng mới');
                    $('#customerForm').attr('action', '${pageContext.request.contextPath}/add-customer');
                    $('#password').attr('required', true);
                    $('.edit-only').hide();
                    $('.add-only').show();
                    $('#id').prop('readonly', false).removeClass('form-control-plaintext').addClass('form-control');
                    $('.id-input-group').removeClass('edit-mode');
                    $('#idHelpText').hide();
                });
                // Handle "Add New Customer" button click
                $('#btnAddCustomer').click(function () {
                    $('#customerForm')[0].reset();
                    $('#id').val('');
                    $('#customerModalLabel').text('Thêm Khách hàng mới');
                    $('#customerForm').attr('action', '${pageContext.request.contextPath}/add-customer');
                    $('#password').attr('required', true);
                    $('.edit-only').hide();
                    $('.add-only').show();
                    $('#id').prop('readonly', false).removeClass('form-control-plaintext').addClass('form-control');
                    $('.id-input-group').removeClass('edit-mode');
                    $('#idHelpText').hide();
                });
                // Handle "Edit Customer" button click
                $('.btn-edit-customer').click(function () {
                    var userId = $(this).data('id');

                    $('#customerModalLabel').text('Sửa thông tin khách hàng');
                    $('#customerForm').attr('action', '${pageContext.request.contextPath}/update-customer');
                    $('#password').attr('required', false);
                    $('.edit-only').show();
                    $('.add-only').hide();

                    $('#id').val(userId).prop('readonly', true).removeClass('form-control').addClass('form-control-plaintext');
                    $('.id-input-group').addClass('edit-mode');
                    $('#idHelpText').hide();

                    // Fetch customer data via AJAX
                    $.ajax({
                        url: '${pageContext.request.contextPath}/customer-get',
                        type: 'GET',
                        data: {id: userId},
                        dataType: 'json',
                        success: function (user) {
                            if (user) {
                                $('#id').val(user.user_id);
                                $('#name').val(user.name);
                                $('#email').val(user.email);
                                $('#password').val('');
                                $('#phone').val(user.phone);
                                $('#address').val(user.address);
                                $('#role').val(user.role);
                            } else {
                                alert('Không tìm thấy thông tin khách hàng. Có thể khách hàng đã bị xóa hoặc lỗi server.');
                                $('#customerModal').modal('hide');
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("AJAX Error: " + status + " - " + error);
                            alert('Có lỗi khi tải dữ liệu khách hàng. Vui lòng kiểm tra console để biết chi tiết.');
                            $('#customerModal').modal('hide');
                        }
                    });
                });

                // (Tùy chọn) Thêm kiểm tra trùng ID khi thêm mới (Client-side check)
                $('#id').on('input', function () {
                    var inputId = $(this).val();
                    var exists = false;

                    if ($('#customerForm').attr('action').endsWith('/add-customer'))
                    {
                        $('#customerTable tbody tr').each(function () {
                            var tableId = $(this).find('td:first').text();
                            if (inputId === tableId) {
                                exists = true;
                                return false;
                            }
                        });
                    }

                    if (exists) {
                        $('#idHelpText').show();
                        $('#saveCustomerBtn').prop('disabled', true);
                    } else {
                        $('#idHelpText').hide();
                        $('#saveCustomerBtn').prop('disabled', false);
                    }
                });
            });
        </script>
    </body>
</html>