<%-- menu_horizontal.jsp --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WorkFit</title>
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
                background-color: #f9f9f9;
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
                transition: color 0.2s ease;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .nav-link:hover { color: var(--wf-primary) !important; }

            .profile-circle {
                width: 38px;
                height: 38px;
                background-color: var(--wf-primary);
                color: white;
                display: flex; justify-content: center; align-items: center;
                border-radius: 50%; font-weight: 600; text-transform: uppercase;
                box-shadow: 0 2px 4px rgba(13, 110, 253, 0.2);
                transition: transform 0.2s ease;
            }
            
            /* Hiệu ứng khi di chuột vào vòng tròn tên */
            .profile-link:hover .profile-circle {
                transform: scale(1.1);
                background-color: #0b5ed7;
            }

            .auth-btn {
                padding: 0.5rem 1.2rem;
                border-radius: 6px; font-weight: 600;
                min-width: 100px; transition: all 0.3s ease; font-size: 0.9rem;
            }

            .btn-outline-success.auth-btn { border-color: var(--wf-success); color: var(--wf-success); }
            .btn-outline-success.auth-btn:hover { background-color: var(--wf-success); color: white; }
            .btn-outline-danger.auth-btn { border-color: var(--wf-danger); color: var(--wf-danger); }
            .btn-outline-danger.auth-btn:hover { background-color: var(--wf-danger); color: white; }

            .icon-btn {
                width: 40px;
                height: 40px;
                display: flex; align-items: center; justify-content: center;
                background-color: var(--wf-primary); color: white;
                border-radius: 50%; cursor: pointer; text-decoration: none;
                position: relative;
            }

            .cart-count {
                position: absolute;
                top: -3px; right: -3px;
                background: var(--wf-danger); color: white;
                border-radius: 50%; font-size: 10px;
                width: 18px; height: 18px;
                display: flex; align-items: center;
                justify-content: center;
                border: 2px solid white;
            }

            .search-bar {
                margin-top: 15px;
                display: none;
                background: white; padding: 15px;
                border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
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
                                <i class="fa-solid fa-house"></i> Home
                            </a>
                        </li>
                        
                        <c:forEach var="ct" items="${requestScope.listCt}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/category?categoryId=${ct.category_id}">${ct.getName()}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${sessionScope.user != null}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/my-orders">
                                    <i class="fa-solid fa-list-check"></i> Đơn hàng của tôi
                                </a>
                            </li>
                        </c:if>
                    </ul>

                    <div class="d-flex align-items-center gap-3">
                        <a class="icon-btn" href="${pageContext.request.contextPath}/cartdetail">
                            <i class="fa fa-shopping-cart"></i>
                            <span class="cart-count">
                                <c:choose>
                                    <c:when test="${sessionScope.cart == null}">0</c:when>
                                    <c:otherwise>${sessionScope.cart.getTotalProduct()}</c:otherwise>
                                </c:choose>
                            </span>
                        </a>

                        <div class="icon-btn" onclick="toggleSearch()">
                            <i class="fa fa-search"></i>
                        </div>

                        <c:choose>
                            <c:when test="${sessionScope.user == null}">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success auth-btn">Login</a>
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-success auth-btn">Register</a>
                            </c:when>
                            <c:otherwise>
                                <div class="user-profile d-flex align-items-center">
                                    <%-- THAY ĐỔI: Thêm thẻ <a> bọc quanh vòng tròn tên để dẫn đến trang Profile --%>
                                    <a href="${pageContext.request.contextPath}/profile" class="profile-link text-decoration-none">
                                        <div class="profile-circle" title="Hồ sơ cá nhân: ${sessionScope.user.name}">
                                            <c:out value="${fn:substring(sessionScope.user.getName(), 0, 1)}" />
                                        </div>
                                    </a>
                                    
                                    <a href="javascript:void(0)" class="btn btn-outline-danger auth-btn ms-2" onclick="confirmLogout()">Logout</a>
                                    
                                    <c:if test="${sessionScope.user.role == 'admin'}">
                                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-primary auth-btn ms-2">Admin</a>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </nav>

        <div id="searchBar" class="container search-bar">
            <form action="${pageContext.request.contextPath}/search" method="get" class="input-group">
                <input type="text" name="query" class="form-control border-primary" placeholder="Search for products..." value="${requestScope.searchQuery != null ? requestScope.searchQuery : ''}">
                <button class="btn btn-primary px-4" type="submit">Go</button>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function toggleSearch() {
                const searchBar = document.getElementById("searchBar");
                searchBar.style.display = (searchBar.style.display === "none" || searchBar.style.display === "") ? "block" : "none";
            }

            function confirmLogout() {
                if (confirm("Bạn có chắc chắn muốn đăng xuất không?")) {
                    window.location.href = "${pageContext.request.contextPath}/logout";
                }
            }
        </script>
    </body>
</html>