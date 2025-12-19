<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Khách hàng - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            body { display: flex; min-height: 100vh; background-color: #f8f9fa; }
            .menu { width: 250px; position: fixed; top: 0; bottom: 0; left: 0; background: #343a40; color: white; z-index: 1030; }
            .list-group-item { background-color: #343a40; color: #adb5bd; border: none; padding: 12px 20px; text-decoration: none; transition: 0.3s; }
            .list-group-item:hover { background-color: #495057; color: white; }
            .list-group-item.active { background-color: #007bff; color: white; }
            .main-content-wrapper { margin-left: 250px; width: calc(100% - 250px); padding: 20px; }
            .history-card { padding: 30px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); border-radius: 8px; background-color: #fff; }
            .order-history-table th { background-color: #007bff; color: white; text-align: center; }
            .order-history-table td { text-align: center; font-size: 1.1rem; }
            .customer-table-container { background-color: #ffffff; border-radius: 8px; padding: 20px; box-shadow: 0 0 15px rgba(0,0,0,0.1); }
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

        <div class="main-content-wrapper">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:choose>
                <%-- HIỂN THỊ LỊCH SỬ --%>
                <c:when test="${isHistoryView == true}">
                    <div class="container-fluid mt-2">
                        <h3 class="mb-4">Lịch sử mua hàng của ${customer.name}</h3>
                        <div class="history-card mb-4">
                            <h5 class="text-secondary border-bottom pb-2">Thông tin Khách hàng</h5>
                            <p class="mt-3"><strong>ID:</strong> ${customer.user_id}</p>
                            <p><strong>Số điện thoại:</strong> ${customer.phone}</p>
                            <p><strong>Địa chỉ:</strong> ${customer.address}</p>
                        </div>
                        <h4>Các Đơn hàng đã đặt</h4>
                        <div class="table-responsive">
                            <table class="table table-bordered order-history-table">
                                <thead>
                                    <tr><th>ID Đơn hàng</th><th>Ngày đặt</th><th>Tổng tiền</th><th>Trạng thái</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orderHistory}">
                                        <tr>
                                            <td>${order.order_id}</td>
                                            <td>${order.order_date.toString().replace('T', ' ')}</td>
                                            <td><fmt:formatNumber value="${order.total_amount}" pattern="#,##0"/> VNĐ</td>
                                            <td><span class="badge bg-primary">${order.status.dbValue}</span></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty orderHistory}">
                                        <tr><td colspan="4" class="alert alert-info">Chưa có đơn hàng nào.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                        <a href="${pageContext.request.contextPath}/customer-list" class="btn btn-secondary mt-3">
                            <i class="fas fa-arrow-left"></i> Quay lại tìm kiếm
                        </a>
                    </div>
                </c:when>

                <%-- HIỂN THỊ DANH SÁCH KHÁCH HÀNG --%>
                <c:otherwise>
                    <div class="customer-table-container bg-white p-4 rounded shadow-sm">
                        <h2 class="mb-4">Quản Lý Khách Hàng</h2>
                        
                        <c:if test="${not empty warningMessage}">
                            <div class="alert alert-warning alert-dismissible fade show">
                                <i class="fas fa-exclamation-triangle"></i> ${warningMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <div class="card mb-4 bg-light">
                            <div class="card-body">
                                <form method="GET" action="${pageContext.request.contextPath}/customer-list" class="row g-3 align-items-end">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Tìm kiếm theo:</label>
                                        <select name="searchType" id="searchType" class="form-select">
                                            <option value="phone" ${param.searchType == 'phone' ? 'selected' : ''}>Số điện thoại</option>
                                            <option value="name" ${param.searchType == 'name' ? 'selected' : ''}>Tên Khách hàng</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Từ khóa:</label>
                                        <input type="text" class="form-control" id="keyword" name="keyword" value="${param.keyword}">
                                    </div>
                                    <div class="col-md-3 d-flex gap-2">
                                        <button type="submit" class="btn btn-success flex-grow-1"><i class="fas fa-search"></i> Tìm Kiếm</button>
                                        <c:if test="${not empty param.keyword}">
                                            <a href="${pageContext.request.contextPath}/customer-list" class="btn btn-outline-secondary" title="Hiện đầy đủ danh sách">
                                                <i class="fas fa-sync-alt"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#customerModal" id="btnAddCustomer">
                            <i class="bi bi-plus-circle"></i> Thêm Khách Hàng Mới
                        </button>

                        <table class="table table-bordered table-hover">
                            <thead class="table-dark text-center">
                                <tr><th>ID</th><th>Tên</th><th>Email</th><th>SĐT</th><th>Địa chỉ</th><th>Hành động</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${listCustomers}">
                                    <tr>
                                        <td class="text-center">${user.user_id}</td>
                                        <td>${user.name}</td>
                                        <td>${user.email}</td>
                                        <td class="text-center">${user.phone}</td>
                                        <td>${user.address}</td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/admin/customer-history?userId=${user.user_id}" class="btn btn-info btn-sm">
                                                <i class="fas fa-history text-white"></i>
                                            </a>
                                            <button type="button" class="btn btn-warning btn-sm btn-edit-customer" data-bs-toggle="modal" data-bs-target="#customerModal" data-id="${user.user_id}">
                                                <i class="bi bi-pencil-square text-white"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="modal fade" id="customerModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="customerForm" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title">Thông tin Khách hàng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3"><label class="form-label">ID:</label><input type="number" class="form-control" id="id" name="id" required></div>
                            <div class="mb-3"><label class="form-label">Tên:</label><input type="text" class="form-control" id="name" name="name" required></div>
                            <div class="mb-3"><label class="form-label">Email:</label><input type="email" class="form-control" id="email" name="email" required></div>
                            <div class="mb-3"><label class="form-label">Mật khẩu:</label><input type="password" class="form-control" id="password" name="password"></div>
                            <div class="mb-3"><label class="form-label">Số điện thoại:</label><input type="text" class="form-control" id="phone" name="phone"></div>
                            <div class="mb-3"><label class="form-label">Địa chỉ:</label><input type="text" class="form-control" id="address" name="address"></div>
                            <div class="mb-3">
                                <label class="form-label">Vai trò:</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="customer">customer</option>
                                    <option value="admin">admin</option>
                                    <option value="employee">employee</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            $(document).ready(function () {
                $('#searchType').change(function() { $('#keyword').val('').focus(); });
                $('.btn-edit-customer').click(function () {
                    var userId = $(this).data('id');
                    $('#customerForm').attr('action', '${pageContext.request.contextPath}/update-customer');
                    $('#id').val(userId).prop('readonly', true);
                    $.ajax({
                        url: '${pageContext.request.contextPath}/customer-get',
                        type: 'GET',
                        data: {id: userId},
                        dataType: 'json',
                        success: function (user) {
                            if (user) {
                                $('#name').val(user.name); $('#email').val(user.email);
                                $('#phone').val(user.phone); $('#address').val(user.address);
                                $('#role').val(user.role);
                            }
                        }
                    });
                });
                $('#btnAddCustomer').click(function () {
                    $('#customerForm')[0].reset();
                    $('#customerForm').attr('action', '${pageContext.request.contextPath}/add-customer');
                    $('#id').prop('readonly', false);
                });
            });
        </script>
    </body>
</html>