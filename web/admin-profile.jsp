<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hồ Sơ Admin | Chỉnh sửa</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
                left: 0;
                bottom: 0;
                background: #343a40;
                color: #f8f9fa;
                z-index: 1000;
                padding-top: 0;
                overflow-y: auto;
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

            /* CSS RIÊNG CỦA ADMIN PROFILE */
            .content {
                margin-left: 250px;
                padding: 30px;
                flex-grow: 1;
            }
            .profile-card {
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                background-color: #ffffff;
            }
            .form-control:read-only {
                background-color: #e9ecef;
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

    <div class="content">
        <h2 class="mb-4 text-primary"><i class="bi bi-person-circle me-2"></i>Chỉnh sửa Hồ sơ Quản trị viên</h2>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i> ${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}</div>
        </c:if>

        <div class="profile-card">
            <form action="${pageContext.request.contextPath}/admin/profile" method="post">

                <div class="row g-3">

                    <div class="col-md-6">
                        <label class="form-label">ID Người dùng</label>
                        <input type="text" class="form-control" value="${adminProfile.user_id}" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Vai trò</label>
                        <input type="text" class="form-control" value="${adminProfile.role}" readonly>
                    </div>

                    <div class="col-12">
                        <label for="name" class="form-label">Họ và Tên (*)</label>
                        <input type="text" class="form-control" id="name" name="name" value="${adminProfile.name}" required>
                    </div>

                    <div class="col-md-6">
                        <label for="email" class="form-label">Email (*)</label>
                        <input type="email" class="form-control" id="email" name="email" value="${adminProfile.email}" required>
                    </div>

                    <div class="col-md-6">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" id="phone" name="phone" value="${adminProfile.phone}">
                    </div>

                    <div class="col-12">
                        <label for="address" class="form-label">Địa chỉ</label>
                        <textarea class="form-control" id="address" name="address" rows="3">${adminProfile.address}</textarea>
                    </div>

                    <hr class="mt-4">

                    <div class="col-12">
                        <h5 class="text-secondary">Thay đổi Mật khẩu (Để trống nếu không thay đổi)</h5>
                    </div>

                    <div class="col-md-6">
                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới">
                    </div>

                    <div class="col-md-6">
                        <label for="confirmPassword" class="form-label">Xác nhận Mật khẩu mới</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu mới">
                    </div>

                    <div class="col-12 mt-4">
                        <button type="submit" class="btn btn-primary me-2"><i class="bi bi-save me-2"></i>Lưu Thay Đổi</button>
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary">Quay lại Dashboard</a>
                    </div>

                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>