<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WorkFit - Đăng Nhập</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <style>
            :root {
                --wf-primary: #0d6efd;
                --wf-success: #198754;
                --wf-danger: #dc3545;
                --wf-shadow: 0 2px 12px rgba(0,0,0,0.08);
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #e0f2f7; /* ĐÃ KHÔI PHỤC: Nền xanh nhạt toàn trang */
            }

            /* --- NAVBAR STYLE (PHẲNG & ĐỒNG BỘ) --- */
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
                transition: color 0.2s ease;
            }

            .auth-btn {
                padding: 0.5rem 1.2rem;
                border-radius: 6px;
                font-weight: 600;
                min-width: 100px;
                transition: all 0.3s ease;
                font-size: 0.9rem;
            }

            .btn-outline-success.auth-btn { border-color: var(--wf-success); color: var(--wf-success); }
            .btn-outline-success.auth-btn:hover { background-color: var(--wf-success); color: white; }

            /* --- LOGIN CARD STYLE --- */
            .login-container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 80vh;
                padding: 20px;
            }
            .login-card {
                background-color: #ffffff;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); /* Bóng đổ cho card */
                width: 100%;
                max-width: 450px;
            }
            .login-card h2 {
                text-align: center;
                margin-bottom: 30px;
                color: var(--wf-primary);
                font-weight: 700;
            }
            .forgot-password, .register-link {
                display: block;
                text-align: center;
                margin-top: 15px;
                text-decoration: none;
                font-size: 0.9rem;
            }
            .social-login {
                text-align: center;
                margin-top: 30px;
                border-top: 1px solid #eee;
                padding-top: 20px;
            }
            .social-btn {
                display: inline-flex;
                width: 40px; height: 40px;
                border-radius: 50%;
                justify-content: center; align-items: center;
                margin: 0 10px; color: white; transition: opacity 0.3s;
            }
            .facebook { background-color: #3b5998; }
            .google { background-color: #db4437; }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light navbar-workfit sticky-top">
            <div class="container">
                <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
                    <h1 class="fw-bold m-0">WorkFit</h1>
                </a>
                <div class="collapse navbar-collapse" id="navbarCollapse">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">
                                <i class="bi bi-house-door"></i> Home
                            </a>
                        </li>
                    </ul>
                    <div class="d-flex align-items-center">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success auth-btn me-2">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-success auth-btn">Register</a>
                    </div>
                </div>
            </div>
        </nav>

        <div class="login-container">
            <div class="login-card">
                <h2>Đăng Nhập</h2>

                <%-- Hiển thị thông báo lỗi từ Servlet --%>
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Lỗi:</strong> ${requestScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <%-- Hiển thị thông báo thành công --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Thành Công!</strong> ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <form action="login" method="post" onsubmit="return handleSubmit(event)">
                    <div class="mb-3">
                        <label for="emailInput" class="form-label">Địa chỉ Email</label>
                        <input name="email" type="email" class="form-control" id="emailInput" placeholder="Nhập email của bạn" required
                               pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$"
                               title="Vui lòng nhập định dạng email hợp lệ (ví dụ: ten@domain.com)">
                    </div>
                    <div class="mb-3">
                        <label for="passwordInput" class="form-label">Mật khẩu</label>
                        <input name="password" type="password" class="form-control" id="passwordInput" placeholder="Nhập mật khẩu" required>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="rememberMe">
                        <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary fw-bold">Đăng Nhập</button>
                    </div>
                </form>

                <a href="#" class="forgot-password">Quên mật khẩu?</a>
                <a href="${pageContext.request.contextPath}/register" class="register-link text-primary">Chưa có tài khoản? Đăng ký ngay!</a>

                <div class="social-login">
                    <p class="text-muted small">Hoặc đăng nhập bằng</p>
                    <a href="#" class="social-btn facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="social-btn google"><i class="fab fa-google"></i></a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function confirmLogout() {
                var confirmResult = confirm("Bạn có chắc chắn muốn đăng xuất không?");
                if (confirmResult) {
                    window.location.href = "${pageContext.request.contextPath}/logout";
                }
            }

            function handleSubmit(event) {
                const emailInput = document.getElementById('emailInput');
                const passwordInput = document.getElementById('passwordInput');

                emailInput.value = emailInput.value.trim();
                passwordInput.value = passwordInput.value.trim();

                if (emailInput.value === "" || passwordInput.value === "") {
                    alert("Email hoặc Mật khẩu không được để trống.");
                    event.preventDefault();
                    return false;
                }

                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
                if (!emailPattern.test(emailInput.value)) {
                    alert("Vui lòng nhập định dạng email hợp lệ.");
                    event.preventDefault();
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>