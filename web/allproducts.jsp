<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="thang.itplus.models.Product" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tất Cả Sản Phẩm - WorkFitShop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            :root {
                --primary-blue: #007bff;
                --text-dark: #2d3436;
                --bg-light: #f8f9fa;
            }

            body {
                background-color: #fff;
                font-family: 'Segoe UI', sans-serif;
                color: var(--text-dark);
            }

            /* 1. Header & Title */
            .section-header h1 {
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: var(--text-dark);
                margin-bottom: 15px;
            }
            .underline {
                width: 50px;
                height: 4px;
                background-color: var(--primary-blue);
                border-radius: 2px;
            }

            /* 2. Product Card Nâng Cấp */
            .product-item {
                border: 1px solid #eee; /* Viền mỏng tinh tế */
                border-radius: 12px;
                background-color: #fff;
                transition: all 0.3s cubic-bezier(.25,.8,.25,1);
                height: 100%;
                display: flex;
                flex-direction: column;
            }

            .product-item:hover {
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08); /* Bóng đổ mềm */
                transform: translateY(-8px);
                border-color: var(--primary-blue);
            }

            /* Khung ảnh tỷ lệ 1:1 */
            .product-image-container {
                aspect-ratio: 1 / 1;
                width: 100%;
                overflow: hidden;
                border-radius: 12px 12px 0 0;
                position: relative;
            }

            .product-item img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .product-item:hover img {
                transform: scale(1.08);
            }

            /* Thông tin sản phẩm */
            .product-info {
                padding: 1.5rem;
                text-align: center;
                flex-grow: 1;
            }

            .product-name-fixed {
                height: 2.8rem;
                line-height: 1.4rem;
                overflow: hidden;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                font-weight: 600;
                color: var(--text-dark) !important;
                text-decoration: none;
                margin-bottom: 8px;
            }

            .product-price-display {
                color: var(--primary-blue);
                font-size: 1.3rem;
                font-weight: 800;
                display: block;
            }

            /* Nút hành động chân Card */
            .product-actions {
                display: flex;
                border-top: 1px solid #f1f3f5;
                background-color: var(--bg-light);
                border-radius: 0 0 12px 12px;
            }

            .action-link {
                flex: 1;
                text-align: center;
                padding: 12px 5px;
                font-size: 0.9rem;
                font-weight: 600;
                color: #636e72;
                text-decoration: none;
                transition: background 0.2s;
            }

            .action-link:hover {
                background-color: #e9ecef;
                color: var(--primary-blue);
            }

            .action-link i {
                margin-right: 6px;
                font-size: 1rem;
            }

            .divider {
                width: 1px;
                background-color: #dee2e6;
            }

            /* Footer Tối Ưu */
            .footer {
                background-color: #1a1a1a !important;
            }
        </style>
    </head>
    <body>

        <%@include file="menu_horizontal.jsp" %>

        <div class="container py-5">
            <div class="section-header text-center mb-5">
                <h1 class="display-6">Tất Cả Sản Phẩm</h1>
                <div class="underline mx-auto"></div>
            </div>

            <div class="row g-4">
                <c:forEach var="product" items="${requestScope.listAllP}">
                    <div class="col-xl-3 col-lg-4 col-md-6">
                        <div class="product-item">
                            <div class="product-image-container">
                                <img src="${product.image}" alt="${product.name}">
                            </div>
                            
                            <div class="product-info">
                                <a class="product-name-fixed" href="/WebApplication1/product-detail?productId=${product.product_id}" title="${product.name}">
                                    ${product.name}
                                </a>
                                <span class="product-price-display">$${product.price}</span>
                            </div>

                            <div class="product-actions">
                                <a class="action-link" href="/WebApplication1/product-detail?productId=${product.product_id}">
                                    <i class="fa fa-eye text-primary"></i> Chi tiết
                                </a>
                                
                                <div class="divider"></div>

                                <c:choose>
                                    <c:when test="${empty user}">
                                        <a class="action-link" href="/WebApplication1/login">
                                            <i class="fa fa-shopping-bag text-primary"></i> Đặt hàng
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="action-link" href="addtocart?productId=${product.getProduct_id()}&quantity=1">
                                            <i class="fa fa-shopping-bag text-primary"></i> Đặt hàng
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${empty requestScope.listAllP}">
                    <div class="col-12 text-center py-5">
                        <i class="fas fa-search fa-3x text-light mb-3"></i>
                        <p class="lead text-muted">Không tìm thấy sản phẩm nào phù hợp.</p>
                        <a href="home" class="btn btn-primary rounded-pill px-4">Quay lại trang chủ</a>
                    </div>
                </c:if>
            </div>
        </div>

        <footer class="footer mt-5 pt-5 text-light">
            <div class="container py-5">
                <div class="row g-5">
                    <div class="col-lg-3 col-md-6">
                        <h2 class="fw-bold text-light mb-4">WorkFit<span class="text-primary">Shop</span></h2>
                        <p>Cửa hàng thời trang công sở uy tín, mang lại phong cách chuyên nghiệp cho cả nam và nữ.</p>
                        <div class="d-flex pt-2 gap-2">
                            <a class="btn btn-outline-light btn-sm rounded-circle" href=""><i class="fab fa-facebook-f"></i></a>
                            <a class="btn btn-outline-light btn-sm rounded-circle" href=""><i class="fab fa-instagram"></i></a>
                            <a class="btn btn-outline-light btn-sm rounded-circle" href=""><i class="fab fa-youtube"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h4 class="text-light mb-4">Liên Hệ</h4>
                        <p><i class="fa fa-map-marker-alt me-3"></i>123 Pháp Vân, Hà Nội</p>
                        <p><i class="fa fa-phone-alt me-3"></i>+012 345 6789</p>
                        <p><i class="fa fa-envelope me-3"></i>support@workfit.com</p>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h4 class="text-light mb-4">Liên Kết Nhanh</h4>
                        <a class="btn btn-link text-light text-decoration-none d-block mb-1" href="#">Trang chủ</a>
                        <a class="btn btn-link text-light text-decoration-none d-block mb-1" href="#">Cửa hàng</a>
                        <a class="btn btn-link text-light text-decoration-none d-block mb-1" href="#">Chính sách</a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h4 class="text-light mb-4">Đăng Ký</h4>
                        <p>Nhận thông báo về bộ sưu tập mới nhất.</p>
                        <div class="input-group">
                            <input type="text" class="form-control border-0" placeholder="Email của bạn">
                            <button class="btn btn-primary">Gửi</button>
                        </div>
                    </div>
                </div>
            </div>   
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>