<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Ký - WorkFit</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <style>
            /* --- CSS CHỈ SỬA CHO THANH MENU NGANG --- */
            :root {
                --wf-primary: #0d6efd;
                --wf-success: #198754;
                --wf-shadow: 0 2px 12px rgba(0,0,0,0.08);
            }
            .navbar-workfit {
                background-color: #ffffff !important;
                box-shadow: var(--wf-shadow);
                padding: 0.75rem 1rem;
                border: none !important;
            }
            .navbar-brand h1 {
                font-weight: 800;
                font-size: 1.6rem;
                color: var(--wf-primary) !important;
                letter-spacing: -0.5px;
            }
            .nav-link {
                font-weight: 500;
                color: #495057 !important;
                margin: 0 8px;
                display: flex;
                align-items: center;
                gap: 5px;
                transition: color 0.2s ease;
            }
            .nav-link:hover { color: var(--wf-primary) !important; }
            .auth-btn {
                padding: 0.5rem 1.25rem;
                border-radius: 6px;
                font-weight: 600;
                min-width: 100px;
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }
            .btn-outline-success.auth-btn { border-color: var(--wf-success); color: var(--wf-success); }
            .btn-outline-success.auth-btn:hover { background-color: var(--wf-success); color: white; }

            /* --- GIỮ NGUYÊN CSS GỐC CHO PHẦN NỘI DUNG --- */
            body {
                background-color: #e0f2f7;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .register-container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: calc(100vh - 60px);
                padding: 20px;
                box-sizing: border-box;
            }
            .register-card {
                background-color: #ffffff;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 550px;
            }
            .register-card h2 {
                text-align: center;
                margin-bottom: 30px;
                color: #007bff;
                font-weight: 700;
            }
            .form-label { font-weight: 500; color: #333; }
            .profile-circle {
                width: 38px; height: 38px;
                background-color: var(--wf-primary); color: white;
                display: flex; justify-content: center; align-items: center;
                border-radius: 50%; font-weight: bold; text-transform: uppercase;
                box-shadow: 0 2px 4px rgba(13, 110, 253, 0.2);
            }
            .login-link { display: block; text-align: center; margin-top: 15px; color: #007bff; text-decoration: none; }
            .login-link:hover { text-decoration: underline; }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light navbar-workfit sticky-top">
            <div class="container">
                <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
                    <h1 class="fw-bold m-0">WorkFit</h1>
                </a>
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarCollapse">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">
                                <i class="bi bi-house-door"></i> Home
                            </a>
                        </li>
                    </ul>
                    <div class="d-flex align-items-center">
                        <c:choose>
                            <c:when test="${sessionScope.user == null}">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success auth-btn me-2">Login</a>
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-success auth-btn">Register</a>
                            </c:when>
                            <c:otherwise>
                                <div class="user-profile d-flex align-items-center">
                                    <div class="profile-circle me-2">
                                        <c:out value="${fn:substring(sessionScope.user.getName(), 0, 1)}" />
                                    </div>
                                    <a href="#" class="btn btn-outline-danger auth-btn" onclick="confirmLogout()">Logout</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </nav>

        <div class="register-container">
            <div class="register-card">
                <h2 class="text-center">Đăng Ký Tài Khoản</h2>

                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${requestScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="register" method="post" onsubmit="return validateForm()">
                    <div class="mb-3">
                        <label for="name" class="form-label">Họ và Tên</label>
                        <input name="name" type="text" class="form-control" id="name" placeholder="Nhập họ và tên" value="${param.name}" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input name="email" type="email" class="form-control" id="email" placeholder="Nhập email" value="${param.email}" required onkeyup="validateEmail()">
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input name="password" type="password" class="form-control" id="password" placeholder="Nhập mật khẩu" required onkeyup="validatePassword()">
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Xác nhận Mật khẩu</label>
                        <input name="confirmPassword" type="password" class="form-control" id="confirmPassword" placeholder="Nhập lại mật khẩu" required onkeyup="validatePassword()">
                        <div id="passwordConfirmError" class="text-danger mt-2" style="display:none;">Mật khẩu xác nhận không khớp.</div>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input name="phone" type="text" class="form-control" id="phone" placeholder="Nhập số điện thoại" value="${param.phone}" required>
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Địa chỉ</label>
                        <textarea name="address" class="form-control" id="address" rows="3" placeholder="Nhập địa chỉ" required>${param.address}</textarea>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">Đăng Ký</button>
                    </div>
                </form>
                <a href="${pageContext.request.contextPath}/login" class="login-link">Đã có tài khoản? Đăng nhập ngay!</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // GIỮ NGUYÊN TOÀN BỘ SCRIPT CỦA BẠN
            function confirmLogout() {
                if (confirm("Bạn có chắc chắn muốn đăng xuất không?")) {
                    window.location.href = "${pageContext.request.contextPath}/logout";
                }
            }

            function validateEmail() {
                const emailInput = document.getElementById('email');
                const email = emailInput.value.trim();
                let emailError = document.getElementById('emailError');
                if (!emailError) {
                    emailError = document.createElement('div');
                    emailError.id = 'emailError';
                    emailError.classList.add('text-danger', 'mt-2');
                    emailInput.closest('.mb-3').appendChild(emailError);
                }
                const emailRegex = /^[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$/;
                if (email.length > 0 && !emailRegex.test(email)) {
                    emailError.innerHTML = "Định dạng Email không hợp lệ.";
                    emailError.style.display = 'block';
                    return false;
                }
                emailError.style.display = 'none';
                return true;
            }

            function validatePassword() {
                const password = document.getElementById('password').value.trim();
                const confirmPassword = document.getElementById('confirmPassword').value.trim();
                const confirmError = document.getElementById('passwordConfirmError');
                
                let isValid = true;
                if (confirmPassword.length > 0 && password !== confirmPassword) {
                    confirmError.style.display = 'block';
                    isValid = false;
                } else {
                    confirmError.style.display = 'none';
                }
                return isValid;
            }

            function validateForm() {
                const isEmailOk = validateEmail();
                const isPassOk = validatePassword();
                const name = document.getElementById('name').value.trim();
                if (!name || !isEmailOk || !isPassOk) {
                    alert("Vui lòng kiểm tra lại thông tin đăng ký.");
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>