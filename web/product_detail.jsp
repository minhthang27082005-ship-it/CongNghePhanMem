<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><c:out value="${product.name != null ? product.name : 'Sản phẩm'}" /> - Chi tiết sản phẩm</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        
        <style>
            :root {
                --primary-color: #007bff;
                --accent-color: #28a745;
                --text-dark: #2d3436;
                --bg-soft: #f8f9fa;
            }

            body {
                background-color: var(--bg-soft);
                font-family: 'Segoe UI', Arial, sans-serif;
                color: var(--text-dark);
            }

            .product-detail-container {
                padding: 60px 20px;
                min-height: 80vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .product-detail-card {
                background: #ffffff;
                border: none;
                border-radius: 20px;
                box-shadow: 0 15px 40px rgba(0,0,0,0.08);
                overflow: hidden;
                width: 100%;
                max-width: 1000px;
                padding: 40px;
            }

            /* Hình ảnh sản phẩm */
            .image-wrapper {
                position: relative;
                overflow: hidden;
                border-radius: 15px;
                background-color: #fff;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            }

            .product-image {
                width: 100%;
                height: auto;
                object-fit: contain;
                transition: transform 0.5s ease;
            }

            .image-wrapper:hover .product-image {
                transform: scale(1.05);
            }

            /* Nội dung */
            .product-title {
                font-size: 2.2rem;
                font-weight: 800;
                color: var(--text-dark);
                margin-bottom: 10px;
                line-height: 1.2;
            }

            .product-price {
                font-size: 2rem;
                color: var(--primary-color);
                font-weight: 700;
                margin-bottom: 25px;
                display: block;
            }

            .product-description {
                font-size: 1.05rem;
                line-height: 1.7;
                color: #636e72;
                margin-bottom: 30px;
                border-left: 4px solid var(--primary-color);
                padding-left: 15px;
            }

            .rating {
                color: #ffc107;
                font-size: 0.9rem;
                font-weight: 600;
                margin-bottom: 25px;
            }

            /* Buttons */
            .action-buttons {
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
            }

            .btn-action {
                padding: 12px 30px;
                font-weight: 700;
                border-radius: 50px;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn-cart {
                background: linear-gradient(45deg, #28a745, #2ecc71);
                border: none;
                color: white;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            }

            .btn-cart:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
                color: #fff;
            }

            .btn-back-home {
                border: 2px solid var(--primary-color);
                color: var(--primary-color);
                background: transparent;
            }

            .btn-back-home:hover {
                background-color: var(--primary-color);
                color: white;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                text-decoration: none;
                color: #b2bec3;
                font-weight: 600;
                margin-bottom: 25px;
                transition: color 0.2s;
            }

            .back-link:hover {
                color: var(--primary-color);
            }

            .back-link i {
                margin-right: 8px;
            }

            /* Tag phụ */
            .product-meta {
                font-size: 0.85rem;
                text-transform: uppercase;
                color: #b2bec3;
                letter-spacing: 1px;
                margin-bottom: 5px;
                display: block;
            }
        </style>
    </head>
    <body>
        
        <jsp:include page="menu_horizontal.jsp"/>
        
        <div class="product-detail-container">
            <div class="product-detail-card">
                <a href="javascript:history.back()" class="back-link">
                    <i class="fas fa-chevron-left"></i> Quay lại trang trước
                </a>
               
                <c:if test="${product != null}">
                    <div class="row g-5">
                        <div class="col-md-5">
                            <div class="image-wrapper">
                                <img src="<c:out value="${product.image}" />" 
                                     alt="<c:out value="${product.name}" />" 
                                     class="product-image">
                            </div>
                        </div>

                        <div class="col-md-7">
                            <span class="product-meta">Chi tiết sản phẩm</span>
                            <h1 class="product-title"><c:out value="${product.name}" /></h1>
                            
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span class="ms-2 text-muted">(4.0 / 5 đánh giá từ khách hàng)</span>
                            </div>

                            <span class="product-price">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0" />
                            </span>

                            <div class="product-description">
                                <c:out value="${product.description}" />
                            </div>
                            
                            <div class="action-buttons">
                                <a href="addtocart?productId=${product.getProduct_id()}&quantity=1" class="btn btn-action btn-cart">
                                    <i class="fas fa-shopping-cart me-2"></i> Thêm vào giỏ hàng
                                </a>
                                <a href="<c:url value="/home" />" class="btn btn-action btn-back-home">
                                    <i class="fas fa-th-large me-2"></i> Xem thêm mẫu khác
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${product == null}">
                    <div class="alert alert-warning text-center p-5 rounded-3 shadow-sm" role="alert">
                        <i class="fas fa-exclamation-triangle fa-3x mb-3 d-block text-warning"></i>
                        <h4 class="alert-heading">Rất tiếc!</h4>
                        <p>Không tìm thấy sản phẩm này trong hệ thống.</p>
                        <hr>
                        <a href="<c:url value="/home" />" class="btn btn-primary rounded-pill">Quay lại trang chủ</a>
                    </div>
                </c:if>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Các hàm Javascript cũ của bạn giữ nguyên chức năng
            function toggleSearch() {
                const searchBar = document.getElementById("searchBar");
                if(searchBar) searchBar.style.display = searchBar.style.display === "none" ? "block" : "none";
            }

            function confirmLogout() {
                if (confirm("Bạn có chắc chắn muốn đăng xuất không?")) {
                    window.location.href = "/WebApplication1/logout";
                }
            }
        </script>
    </body>
</html>