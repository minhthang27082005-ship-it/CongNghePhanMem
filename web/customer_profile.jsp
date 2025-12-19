<%-- customer_profile.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hồ sơ của tôi - WorkFit</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <style>
            body {
                background: #f4f7f6;
                font-family: 'Segoe UI', system-ui, sans-serif;
            }

            .profile-container {
                max-width: 800px; /* Thu hẹp container để nội dung tập trung */
                margin: 50px auto;
            }

            .card-profile {
                border: none;
                border-radius: 20px;
                background: #ffffff;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                padding: 40px;
            }

            /* Chữ cái đại diện (Avatar) */
            .profile-avatar-big {
                width: 120px;
                height: 120px;
                background: linear-gradient(135deg, #0d6efd, #0056b3);
                color: #fff;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 4rem;
                font-weight: bold;
                margin: 0 auto 20px;
                box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
            }

            /* Thiết lập hàng dọc và chữ to */
            .info-list {
                margin-top: 30px;
            }

            .info-row {
                display: flex;
                align-items: flex-start;
                padding: 20px 0;
                border-bottom: 1px solid #eee;
            }

            .info-row:last-child {
                border-bottom: none;
            }

            .info-label {
                width: 280px; /* Độ rộng cột nhãn để thẳng hàng */
                font-size: 1.3rem; /* Chữ to rõ ràng */
                font-weight: 700;
                color: #495057;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .info-value {
                flex: 1;
                font-size: 1.3rem; /* Chữ to rõ ràng */
                color: #212529;
                font-weight: 500;
            }

            .badge-role {
                font-size: 1.1rem;
                padding: 8px 15px;
                background-color: #e7f1ff;
                color: #0d6efd;
                border-radius: 10px;
                text-transform: capitalize;
            }

            .btn-edit {
                font-size: 1.2rem;
                padding: 12px 35px;
                border-radius: 12px;
                font-weight: 600;
                margin-top: 30px;
                transition: 0.3s;
            }

            .btn-edit:hover {
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
            }

            /* Alert styling */
            .alert {
                border: none;
                border-radius: 15px;
                font-size: 1.1rem;
            }
        </style>
    </head>
    <body>
        <jsp:include page="menu_horizontal.jsp" />

        <div class="container profile-container">
            
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="card-profile">
                <div class="text-center mb-4">
                    <div class="profile-avatar-big">
                        <c:out value="${fn:substring(sessionScope.user.name, 0, 1)}" />
                    </div>
                    <h1 class="fw-bold m-0">${sessionScope.user.name}</h1>
                    <p class="text-muted fs-5 mt-2">Chào mừng bạn trở lại!</p>
                </div>

                <div class="info-list">
                    <div class="info-row">
                        <div class="info-label">
                            <i class="bi bi-envelope-at text-primary"></i> Email đăng ký:
                        </div>
                        <div class="info-value text-break">${sessionScope.user.email}</div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">
                            <i class="bi bi-telephone text-primary"></i> Số điện thoại:
                        </div>
                        <div class="info-value">
                            ${not empty sessionScope.user.phone ? sessionScope.user.phone : '<span class="text-muted"><em>Chưa cập nhật</em></span>'}
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">
                            <i class="bi bi-geo-alt text-primary"></i> Địa chỉ mặc định:
                        </div>
                        <div class="info-value">
                            ${not empty sessionScope.user.address ? sessionScope.user.address : '<span class="text-muted"><em>Chưa cập nhật</em></span>'}
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">
                            <i class="bi bi-person-badge text-primary"></i> Vai trò tài khoản:
                        </div>
                        <div class="info-value">
                            <span class="badge-role">${sessionScope.user.role}</span>
                        </div>
                    </div>
                </div>

                <div class="text-center">
                    <button class="btn btn-primary btn-edit shadow-sm" data-bs-toggle="modal" data-bs-target="#editModal">
                        <i class="bi bi-pencil-square me-2"></i> Chỉnh sửa hồ sơ & Mật khẩu
                    </button>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow-lg" style="border-radius: 20px; border: none;">
                    <form action="${pageContext.request.contextPath}/update-customer-profile" method="post" id="updateForm">
                        <div class="modal-header border-0 pt-4 px-4">
                            <h5 class="modal-title fw-bold fs-3">Cập nhật hồ sơ</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body px-4 fs-5">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Họ và tên</label>
                                <input type="text" name="name" class="form-control form-control-lg" value="${sessionScope.user.name}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Số điện thoại</label>
                                <input type="text" name="phone" class="form-control form-control-lg" value="${sessionScope.user.phone}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Địa chỉ nhận hàng</label>
                                <textarea name="address" class="form-control form-control-lg" rows="2">${sessionScope.user.address}</textarea>
                            </div>

                            <div class="p-3 bg-light rounded-4 mt-4 border">
                                <h6 class="text-primary fw-bold fs-5 mb-2"><i class="bi bi-key-fill me-1"></i>Thay đổi mật khẩu</h6>
                                <p class="text-muted small mb-3">Bỏ trống nếu không muốn thay đổi mật khẩu.</p>
                                <div class="mb-2">
                                    <input type="password" name="newPassword" id="newPassword" class="form-control" placeholder="Mật khẩu mới">
                                </div>
                                <div>
                                    <input type="password" id="confirmPassword" class="form-control" placeholder="Xác nhận mật khẩu mới">
                                    <small id="pwError" class="text-danger d-none mt-1">Mật khẩu xác nhận không trùng khớp!</small>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-0 pb-4 px-4">
                            <button type="button" class="btn btn-light btn-lg px-4" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary btn-lg px-4">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Kiểm tra khớp mật khẩu trước khi gửi
            document.getElementById('updateForm').onsubmit = function (e) {
                const pass = document.getElementById('newPassword').value;
                const confirm = document.getElementById('confirmPassword').value;
                const errorMsg = document.getElementById('pwError');

                if (pass !== "" && pass !== confirm) {
                    e.preventDefault();
                    errorMsg.classList.remove('d-none');
                    return false;
                }
                return true;
            };
        </script>
    </body>
</html>