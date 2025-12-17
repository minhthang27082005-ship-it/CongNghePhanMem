<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh mục: ${pageTitle}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            :root {
                --primary-blue: #007bff;
                --dark-blue: #0056b3;
                --soft-bg: #f8f9fa;
            }

            body {
                background-color: #fff;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            /* 1. Header Banner Phong cách mới */
            .category-header-banner {
                background: linear-gradient(135deg, var(--primary-blue) 0%, var(--dark-blue) 100%);
                color: white;
                padding: 60px 0;
                margin-bottom: 50px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .category-header-banner h1 {
                font-size: 2.8rem;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 2px;
                margin-bottom: 15px;
            }
            .category-header-banner p {
                font-size: 1.2rem;
                font-weight: 300;
                opacity: 0.9;
            }
            .header-underline {
                width: 60px;
                height: 4px;
                background-color: #fff;
                margin: 20px auto 0;
                border-radius: 2px;
            }

            /* 2. Product Item Nâng cấp */
            .product-item {
                /* Thay đổi độ dày và màu sắc của viền tại đây */
                border: 2px solid #e0e0e0;
                border-radius: 15px;
                background-color: #fff;
                transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
                height: 100%;
                display: flex;
                flex-direction: column;
                overflow: hidden; /* Đảm bảo nội dung không tràn khỏi góc bo tròn */
            }

            .product-item:hover {
                /* Thay đổi màu viền khi di chuột qua để làm nổi bật sản phẩm */
                border-color: var(--primary-blue);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                transform: translateY(-10px);
            }

            .product-image-container {
                aspect-ratio: 1 / 1;
                width: 100%;
                overflow: hidden;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 15px 15px 0 0;
                position: relative;
            }
            .product-item img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.6s ease;
            }
            .product-item:hover img {
                transform: scale(1.1);
            }

            .product-info {
                padding: 20px;
                text-align: center;
                flex-grow: 1;
            }
            .product-name-fixed {
                height: 3rem;
                line-height: 1.5rem;
                overflow: hidden;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                font-weight: 600;
                color: #2d3436 !important;
                text-decoration: none;
                margin-bottom: 10px;
            }
            .product-name-fixed:hover {
                color: var(--primary-blue) !important;
            }
            .product-price-display {
                color: var(--primary-blue);
                font-size: 1.4rem;
                font-weight: 800;
                display: block;
            }

            /* 3. Button & Action Area */
            .product-actions {
                border-top: 1px solid #f1f3f5;
                display: flex;
                background-color: var(--soft-bg);
                border-radius: 0 0 15px 15px;
            }
            .action-link {
                flex: 1;
                text-align: center;
                padding: 12px 5px;
                font-size: 0.95rem;
                font-weight: 600;
                color: #4a5568;
                text-decoration: none;
                transition: background 0.2s;
            }
            .action-link:hover {
                background-color: #e9ecef;
                color: var(--primary-blue);
            }
            .action-link i {
                margin-right: 5px;
            }
            .border-divider {
                width: 1px;
                background-color: #dee2e6;
            }

            .section-divider {
                width: 80px;
                height: 3px;
                background-color: var(--primary-blue);
                margin: 15px auto 40px;
            }
        </style>
    </head>
    <body>

        <%-- INCLUDE MENU --%>
        <%@include file="menu_horizontal.jsp" %>

        <%-- CATEGORY HERO BANNER --%>
        <div class="category-header-banner shadow-sm">
            <div class="container text-center">
                <h1>${pageTitle}</h1>
                <p>Khám phá phong cách thời trang công sở chuyên nghiệp dành riêng cho bạn.</p>
                <div class="header-underline"></div>
            </div>
        </div>

        <div class="container my-5">

            <%-- HIỂN THỊ THÔNG BÁO LỖI (NẾU CÓ) --%>
            <c:if test="${not empty requestScope.error_message}">
                <div class="alert alert-danger shadow-sm rounded-pill text-center px-4" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${requestScope.error_message}
                </div>
            </c:if>

            <%-- TIÊU ĐỀ PHỤ --%>
            <div class="text-center">
                <h2 class="text-dark fw-bold text-uppercase">Danh sách sản phẩm</h2>
                <div class="section-divider"></div>
            </div>

            <%-- DANH SÁCH SẢN PHẨM --%>
            <c:choose>
                <%-- Kiểm tra nếu có sản phẩm [cite: 76] --%>
                <c:when test="${not empty requestScope.products}">
                    <div class="row g-4">
                        <c:forEach var="p" items="${requestScope.products}">
                            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                <div class="product-item">
                                    <%-- Ảnh sản phẩm [cite: 78] --%>
                                    <div class="product-image-container">
                                        <img src="${p.image}" alt="${p.name}">
                                    </div>

                                    <%-- Thông tin tên & giá [cite: 79, 80] --%>
                                    <div class="product-info">
                                        <a class="product-name-fixed" href="/WebApplication1/product-detail?productId=${p.product_id}" title="${p.name}">
                                            ${p.name}
                                        </a>
                                        <span class="product-price-display">
                                            $<fmt:formatNumber value="${p.price}" pattern="#,##0"/>
                                        </span>
                                    </div>

                                    <%-- Các nút hành động [cite: 81, 84] --%>
                                    <div class="product-actions">
                                        <a class="action-link" href="/WebApplication1/product-detail?productId=${p.product_id}">
                                            <i class="fa fa-eye"></i> Chi tiết
                                        </a>

                                        <div class="border-divider"></div>

                                        <c:choose>
                                            <%-- Logic kiểm tra đăng nhập để đặt hàng [cite: 85, 87, 88] --%>
                                            <c:when test="${empty sessionScope.user}">
                                                <a class="action-link" href="/WebApplication1/login">
                                                    <i class="fa fa-shopping-bag"></i> Đặt hàng
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="action-link" href="addtocart?productId=${p.getProduct_id()}&quantity=1">
                                                    <i class="fa fa-shopping-bag"></i> Đặt hàng
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <%-- Thông báo khi không có sản phẩm [cite: 92] --%>
                <c:otherwise>
                    <c:if test="${empty requestScope.error_message}">
                        <div class="alert alert-light border shadow-sm text-center p-5" role="alert">
                            <i class="fas fa-box-open fa-3x text-muted mb-3 d-block"></i>
                            <h4 class="text-secondary">Rất tiếc, hiện tại không có sản phẩm nào!</h4>
                            <p class="text-muted mb-0">Chúng tôi sẽ cập nhật danh mục <strong>${pageTitle}</strong> trong thời gian sớm nhất.</p>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>