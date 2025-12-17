<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="thang.itplus.models.Category" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>WorkFitShop - Home</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            :root {
                --primary-blue: #007bff;
                --dark-blue: #0056b3;
                --light-gray: #f8f9fa;
                --text-main: #333;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                color: var(--text-main);
            }

            /* --- 1. CAROUSEL (KHÔI PHỤC NGUYÊN BẢN LOGIC CỦA BẠN) --- */
            .carousel-item {
                position: relative;
                width: 100%;
                padding-top: 45%; /* Tỷ lệ khung hình gốc của bạn */
                height: 0;
                background-color: #f1f1f1;
            }

            .carousel-item img {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: contain; /* Giữ nguyên ảnh không bị cắt */
                display: block;
            }

            /* --- 2. SẢN PHẨM (PRODUCT ITEM) NÂNG CẤP GIAO DIỆN --- */
            .product-item {
                border: 1px solid #eee;
                border-radius: 12px;
                background-color: #fff;
                transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
                overflow: hidden;
                height: 100%;
                display: flex;
                flex-direction: column;
            }

            .product-item:hover {
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                transform: translateY(-8px);
                border-color: var(--primary-blue);
            }

            /* Khung ảnh VUÔNG đồng bộ */
            .product-image-container {
                position: relative;
                aspect-ratio: 1 / 1;
                overflow: hidden;
                background-color: #fff;
            }

            .product-image-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .product-item:hover img {
                transform: scale(1.08);
            }

            /* Overlay nút bấm khi hover */
            .product-overlay {
                position: absolute;
                top: 0; left: 0; width: 100%; height: 100%;
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(2px);
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                gap: 10px;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .product-item:hover .product-overlay {
                opacity: 1;
            }

            /* Tag New */
            .product-tag-new {
                background-color: var(--primary-blue);
                color: white;
                border-radius: 0 0 8px 0;
                position: absolute;
                top: 0; left: 0;
                padding: 5px 12px;
                font-size: 0.75rem;
                font-weight: 700;
                z-index: 10;
                text-transform: uppercase;
            }

            /* Tiêu đề và giá */
            .product-info-area {
                padding: 1.25rem;
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
                color: #222 !important;
                text-decoration: none;
                margin-bottom: 8px;
            }

            .product-price-display {
                color: var(--primary-blue);
                font-size: 1.2rem;
                font-weight: 700;
                display: block;
            }

            /* --- 3. TIÊU ĐỀ SECTION --- */
            .section-header h1 {
                font-weight: 700;
                color: #222;
                position: relative;
                padding-bottom: 15px;
            }
            .section-header h1::after {
                content: '';
                position: absolute;
                left: 0; bottom: 0;
                width: 50px; height: 3px;
                background-color: var(--primary-blue);
            }

            /* Banner xanh giữa trang */
            .promo-banner {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                border-radius: 15px;
                padding: 50px 20px;
            }

            /* --- 4. FOOTER --- */
            .footer {
                background-color: #111 !important;
            }
            .footer .btn-link {
                text-decoration: none;
                transition: 0.3s;
            }
            .footer .btn-link:hover {
                color: var(--primary-blue) !important;
                padding-left: 10px;
            }
        </style>
    </head>
    <body>

        <%@include file="menu_horizontal.jsp" %>

        <div id="header-carousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3000">
            <div class="carousel-inner">
                <c:forEach var="item" items="${carouselItems}" varStatus="status">
                    <div class="carousel-item ${status.first ? 'active' : ''}">
                        <img class="carousel-image w-100" src="${item.imageUrl}" alt="Banner Image">
                    </div>
                </c:forEach>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#header-carousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#header-carousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>

        <div class="container my-5">
            <div class="section-header mb-5">
                <h1 class="display-6">Sản Phẩm Mới</h1>
            </div>

            <div class="promo-banner text-center mb-5 shadow-sm">
                <h2 class="display-5 fw-bold mb-3">Khám Phá Các Sản Phẩm Hot Nhất</h2>
                <p class="lead mb-4">Thời trang công sở hiện đại, chuyên nghiệp và đầy phong cách.</p>
                <a href="allproducts" class="btn btn-light btn-lg rounded-pill px-5 fw-bold shadow">Xem Ngay</a>
            </div>

            <div class="row g-4">
                <c:forEach var="product" items="${requestScope.lastFour}">
                    <div class="col-xl-3 col-lg-4 col-md-6 mb-2">
                        <div class="product-item shadow-sm">
                            <div class="product-image-container">
                                <div class="product-tag-new">New</div>
                                <img src="${product.image}" alt="${product.name}">
                                
                                <div class="product-overlay">
                                    <a class="btn btn-primary rounded-pill px-4" href="/WebApplication1/product-detail?productId=${product.product_id}">Chi tiết</a>
                                    <c:choose>
                                        <c:when test="${empty user}">
                                            <a class="btn btn-dark rounded-pill px-4" href="/WebApplication1/login">Đặt hàng</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="btn btn-dark rounded-pill px-4" href="addtocart?productId=${product.getProduct_id()}&quantity=1">Đặt hàng</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="product-info-area">
                                <a class="product-name-fixed" href="viewdetail?productId=${product.product_id}" title="${product.name}">
                                    ${product.name}
                                </a>
                                <span class="product-price-display">$${product.price}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="row g-0 align-items-end mt-5 mb-4">
                <div class="col-lg-8">
                    <div class="section-header">
                        <h1 class="display-6 mb-3">Tất Cả Sản Phẩm</h1>
                        <p class="text-muted">Chúng tôi cam kết mang đến cho bạn những lựa chọn trang phục chuyên nghiệp và thoải mái.</p>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <c:forEach var="product" items="${requestScope.listP}">
                    <div class="col-xl-3 col-lg-4 col-md-6">
                        <div class="product-item shadow-sm">
                            <div class="product-image-container">
                                <img src="${product.image}" alt="${product.name}">
                                <div class="product-overlay">
                                    <a class="btn btn-primary btn-sm rounded-pill px-3" href="/WebApplication1/product-detail?productId=${product.product_id}">
                                        <i class="fa fa-eye me-1"></i> Chi tiết
                                    </a>
                                </div>
                            </div>
                            <div class="product-info-area">
                                <a class="product-name-fixed" href="/WebApplication1/product-detail?productId=${product.product_id}">
                                    ${product.name}
                                </a>
                                <div class="product-price-display mb-3">$${product.price}</div>
                                
                                <div class="border-top pt-3 d-flex justify-content-center">
                                    <c:choose>
                                        <c:when test="${empty user}">
                                            <a class="text-primary fw-bold text-decoration-none" href="/WebApplication1/login">
                                                <i class="fa fa-shopping-bag me-2"></i>Đặt hàng ngay
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="text-primary fw-bold text-decoration-none" href="addtocart?productId=${product.getProduct_id()}&quantity=1">
                                                <i class="fa fa-shopping-bag me-2"></i>Đặt hàng ngay
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="text-center mt-5">
                <a href="allproducts" class="btn btn-primary btn-lg rounded-pill px-5 shadow-sm">
                    <i class="fa fa-arrow-right me-2"></i> Xem tất cả
                </a>
            </div>
        </div>

        <div class="container-fluid bg-dark text-light footer mt-5 pt-5">
            <div class="container py-5">
                <div class="row g-5">
                    <div class="col-lg-3 col-md-6">
                        <h1 class="fw-bold text-white mb-4">WorkFit<span class="text-primary text-lowercase">shop</span></h1>
                        <p>Cửa hàng thời trang uy tín với các mẫu thiết kế công sở hiện đại, chất lượng cao.</p>
                        <div class="d-flex pt-2 gap-2">
                            <a class="btn btn-outline-light btn-sm rounded-circle p-2" href=""><i class="fab fa-facebook-f"></i></a>
                            <a class="btn btn-outline-light btn-sm rounded-circle p-2" href=""><i class="fab fa-instagram"></i></a>
                            <a class="btn btn-outline-light btn-sm rounded-circle p-2" href=""><i class="fab fa-youtube"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h4 class="text-white mb-4">Liên Hệ</h4>
                        <p><i class="fa fa-map-marker-alt me-3"></i>123 Pháp Vân, Hà Nội</p>
                        <p><i class="fa fa-phone-alt me-3"></i>+012 345 6789</p>
                        <p><i class="fa fa-envelope me-3"></i>support@workfitshop.com</p>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h4 class="text-white mb-4">Liên Kết</h4>
                        <a class="btn btn-link text-light d-block mb-1" href="#">Trang chủ</a>
                        <a class="btn btn-link text-light d-block mb-1" href="#">Cửa hàng</a>
                        <a class="btn btn-link text-light d-block mb-1" href="#">Về chúng tôi</a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h4 class="text-white mb-4">Bản Tin</h4>
                        <p>Đăng ký để nhận các ưu đãi mới nhất.</p>
                        <div class="position-relative mx-auto" style="max-width: 400px;">
                            <input class="form-control bg-transparent text-white w-100 py-3 ps-4 pe-5" type="email" placeholder="Email của bạn">
                            <button type="button" class="btn btn-primary py-2 position-absolute top-0 end-0 mt-2 me-2">Gửi</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>