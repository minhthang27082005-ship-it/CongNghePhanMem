<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Kết Quả Tìm Kiếm - EmTyShop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            /* Các CSS chung từ home.jsp và menu_horizontal.jsp */
            body {
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }

            .profile-circle {
                width: 40px;
                height: 40px;
                background-color: #4285F4;
                color: white;
                display: flex;
                justify-content: center;
                align-items: center;
                border-radius: 50%;
                font-size: 18px;
                font-weight: bold;
                text-transform: uppercase;
                margin-right: 10px;
            }

            .cart-btn {
                position: relative;
                background-color: #007bff;
                color: white;
                padding: 10px 15px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
            }

            .cart-btn:hover {
                background-color: #0056b3;
            }

            .cart-count {
                position: absolute;
                top: -5px;
                right: -5px;
                background: red;
                color: white;
                border-radius: 50%;
                font-size: 12px;
                width: 18px;
                height: 18px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .navbar-nav .user-profile {
                display: flex;
                align-items: center;
            }

            .search-icon {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                background-color: #007bff;
                color: white;
                border-radius: 50%;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .search-icon:hover {
                background-color: #0056b3;
            }

            .search-icon i {
                font-size: 20px;
            }

            .content-section {
                margin-top: 20px;
                padding: 20px;
                background-color: white;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            .search-bar {
                margin-top: 15px;
                display: none; /* Mặc định ẩn */
            }

            /* Product item styles (from home.jsp) */
            .product-item {
                border: 2px solid #007bff; /* Viền màu xanh */
                border-radius: 10px; /* Bo góc cho sản phẩm */
                background-color: #fff; /* Màu nền trắng */
                transition: all 0.3s ease; /* Hiệu ứng mượt mà */
            }

            .product-item:hover {
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1); /* Thêm bóng đổ */
                transform: translateY(-10px); /* Dịch chuyển nhẹ lên */
                border-color: #0056b3; /* Đổi màu viền khi hover */
            }

            .product-item img {
                transition: transform 0.3s ease; /* Hiệu ứng zoom cho ảnh */
            }

            .product-item:hover img {
                transform: scale(1.05); /* Phóng to ảnh khi hover */
            }

            .product-item .product-image-container {
                position: relative;
                overflow: hidden;
            }

            .product-item .product-overlay {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                display: none;
                width: 100%;
                text-align: center;
            }

            .product-item:hover .product-overlay {
                display: block;
            }

            .product-overlay .btn {
                margin: 0 5px;
                padding: 10px 15px;
                font-size: 1rem;
                color: white;
                background-color: #007bff;
                border-radius: 5px;
                text-decoration: none;
            }

            .product-overlay .btn:hover {
                background-color: #0056b3;
            }

            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
            }

            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004085;
                box-shadow: 0px 6px 15px rgba(0, 0, 0, 0.2);
            }

            .section-header h1 {
                font-family: 'Arial', sans-serif;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: #007bff;
            }

            .section-header p {
                font-size: 1.1rem;
                color: #777;
            }
        </style>
    </head>
    <body>
        <%-- Include the horizontal menu --%>
        <%-- Đảm bảo đường dẫn tới menu_horizontal.jsp là đúng --%>
        <%@include file="menu_horizontal.jsp" %>

        <div class="container-fluid bg-light bg-icon my-5 py-6" style="background-color: #f9f9f9;">
            <div class="container">
                <div class="col-lg-12">
                    <div class="section-header text-start mb-5 wow fadeInUp" data-wow-delay="0.1s" style="max-width: 100%;">
                        <c:choose>
                            <c:when test="${not empty requestScope.searchQuery}">
                                <h1 class="display-5 mb-3">Kết Quả Tìm Kiếm cho "<c:out value="${requestScope.searchQuery}" />"</h1>
                                <p>Tìm thấy ${fn:length(requestScope.searchResults)} sản phẩm phù hợp.</p>
                            </c:when>
                            <c:otherwise>
                                <h1 class="display-5 mb-3">Tìm Kiếm Sản Phẩm</h1>
                                <p>Vui lòng nhập từ khóa để tìm kiếm.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="row g-4">
                    <c:choose>
                        <c:when test="${empty requestScope.searchResults && not empty requestScope.searchQuery}">
                            <div class="col-12 text-center">
                                <p>Không tìm thấy sản phẩm nào phù hợp với từ khóa "<c:out value="${requestScope.searchQuery}" />".</p>
                                <a href="home" class="btn btn-primary mt-3">Quay lại trang chủ</a>
                            </div>
                        </c:when>
                        <c:when test="${empty requestScope.searchResults && empty requestScope.searchQuery}">
                            <div class="col-12 text-center">
                                <p>Hãy nhập từ khóa vào ô tìm kiếm ở phía trên để bắt đầu tìm kiếm sản phẩm của chúng tôi!</p>
                                <a href="home" class="btn btn-primary mt-3">Quay lại trang chủ</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="product" items="${requestScope.searchResults}">
                                <div class="col-xl-3 col-lg-4 col-md-6 mb-4 wow fadeInUp" data-wow-delay="0.1s">
                                    <div class="product-item bg-light rounded shadow-sm overflow-hidden position-relative">
                                        <div class="position-relative overflow-hidden product-image-container">
                                            <img class="img-fluid w-100" src="${product.image}" alt="${product.name}" style="object-fit: cover; height: 250px;">
                                            <%-- Bạn có thể thêm tag "New" hoặc "Sale" ở đây nếu product có thuộc tính tương ứng --%>

                                            <div class="product-overlay">
                                                <a class="btn btn-primary" href="viewdetail?productId=${product.product_id}">View Detail</a>
                                                <a class="btn btn-primary" href="addtocart?productId=${product.getProduct_id()}&quantity=1">Add to Cart</a>
                                            </div>
                                        </div>

                                        <div class="text-center p-4">
                                            <span class="text-primary me-1" style="color: #007bff; font-size: 1.2rem; font-weight: bold;">$${product.price}</span>
                                            <a class="d-block h5 mb-2 text-truncate" href="viewdetail?productId=${product.product_id}"
                                               style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: #333; font-weight: 500; font-size: 1.1rem; text-decoration: none;">
                                                ${product.name}
                                            </a>
                                        </div>
                                        <div class="d-flex border-top">
                                            <small class="w-50 text-center py-2">
                                                <a class="text-body" href="viewdetail?productId=${product.product_id}" style="text-decoration: none;">
                                                    <i class="fa fa-eye text-primary me-2"></i>View Detail
                                                </a>
                                            </small>
                                            <small class="w-50 text-center py-2">
                                                <a class="text-body" href="addtocart?productId=${product.getProduct_id()}&quantity=1" style="text-decoration: none;">
                                                    <i class="fa fa-shopping-bag text-primary me-2"></i>Add to Cart
                                                </a>
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <%-- Footer (đảm bảo các CSS/JS liên quan đến footer cũng được bao gồm nếu cần) --%>
        <div class="container-fluid bg-dark footer mt-5 pt-5 wow fadeIn" data-wow-delay="0.1s">
            <div class="container py-5">
                <div class="row g-5">
                    <div class="col-lg-3 col-md-6">
                        <h1 class="fw-bold text-light mb-4">Em<span class="text-primary">Ty</span>Shop</h1>
                        <p class="text-light">Your one-stop shop for trendy clothing and accessories. We offer a wide variety of products for both men and women, ensuring style and quality.</p>
                        <div class="d-flex pt-2">
                            <a class="btn btn-square btn-outline-light rounded-circle me-1" href=""><i class="fab fa-twitter"></i></a>
                            <a class="btn btn-square btn-outline-light rounded-circle me-1" href=""><i class="fab fa-facebook-f"></i></a>
                            <a class="btn btn-square btn-outline-light rounded-circle me-1" href=""><i class="fab fa-youtube"></i></a>
                            <a class="btn btn-square btn-outline-light rounded-circle me-0" href=""><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h4 class="text-light mb-4">Contact Us</h4>
                        <p class="text-light"><i class="fa fa-map-marker-alt me-3"></i>123 Street, New York, USA</p>
                        <p class="text-light"><i class="fa fa-phone-alt me-3"></i>+012 345 67890</p>
                        <p class="text-light"><i class="fa fa-envelope me-3"></i>support@emtyshop.com</p>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h4 class="text-light mb-4">Quick Links</h4>
                        <a class="btn btn-link text-light" href="#">Home</a>
                        <a class="btn btn-link text-light" href="#">Shop</a>
                        <a class="btn btn-link text-light" href="#">About Us</a>
                        <a class="btn btn-link text-light" href="#">Contact</a>
                        <a class="btn btn-link text-light" href="#">Terms & Conditions</a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h4 class="text-light mb-4">Newsletter</h4>
                        <p class="text-light">Stay updated with the latest products and offers. Subscribe to our newsletter!</p>
                        <div class="position-relative mx-auto" style="max-width: 400px;">
                            <input class="form-control bg-transparent text-light w-100 py-3 ps-4 pe-5" type="email" placeholder="Your email" required>
                            <button type="button" class="btn btn-primary py-2 position-absolute top-0 end-0 mt-2 me-2">SignUp</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="container-fluid copyright">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                            &copy; <a href="#" class="text-light">EmTyShop</a>, All Right Reserved.
                        </div>
                        <div class="col-md-6 text-center text-md-end">
                            Designed By <a href="https://htmlcodex.com" class="text-light">HTML Codex</a>
                            <br>Distributed By: <a href="https://themewagon.com" target="_blank" class="text-light">ThemeWagon</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>