<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Giỏ hàng - WorkFitShop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #007bff;
                --bg-body: #f4f7f6;
            }
            body {
                background-color: var(--bg-body);
                font-family: 'Segoe UI', sans-serif;
            }
            .product-name-link {
                text-decoration: none;
                color: #2c3e50;
                font-weight: 600;
            }
            .product-name-link:hover {
                color: var(--primary-color);
                text-decoration: underline;
            }
            .quantity-display {
                display: inline-block;
                padding: 0 10px;
                font-weight: bold;
            }
            .table th {
                background-color: #f8f9fa !important;
                text-transform: uppercase;
                font-size: 0.8rem;
                color: #7f8c8d;
                border: none !important;
                padding: 15px !important;
            }
            .table td {
                vertical-align: middle;
                padding: 20px !important;
                border-bottom: 1px solid #eee;
            }
            .btn-qty {
                width: 35px;
                height: 35px;
                border-radius: 8px;
                font-weight: bold;
            }
            .summary-section {
                margin-top: 30px;
            }
            .btn-checkout-main {
                width: 100%;
                font-weight: bold;
                text-transform: uppercase;
                padding: 12px;
            }
        </style>
    </head>
    <body>
        <%@include file="menu_horizontal.jsp" %>

        <div class="shopping-cart py-5">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 p-5 bg-white rounded shadow-sm mb-5">
                        <h4 class="mb-4 fw-bold"><i class="fas fa-shopping-basket me-2 text-primary"></i>Chi tiết giỏ hàng</h4>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th scope="col">Hình Ảnh</th>
                                        <th scope="col">Sản Phẩm</th>
                                        <th scope="col">Đơn Giá</th>
                                        <th scope="col" class="text-center">Số Lượng</th>
                                        <th scope="col">Xóa</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty ListItemCart}">
                                            <tr><td colspan="5" class="text-center py-5 text-muted">Giỏ hàng của bạn đang trống [cite: 23]</td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${ListItemCart}" var="entry">
                                                <tr>
                                                    <td><img src="${entry.value.product.image}" width="80" class="img-fluid rounded border"></td>
                                                    <td><h5 class="mb-0"><a href="#" class="product-name-link">${entry.value.product.name}</a></h5></td>
                                                    <td><span class="fw-bold text-primary"><fmt:formatNumber value="${entry.value.product.price * entry.value.quantity}" pattern="#,###"/> VNĐ</span></td>
                                                    <td class="text-center">
                                                        <div class="d-flex align-items-center justify-content-center">
                                                            <a href="updatecart?productId=${entry.value.product.product_id}&quantity=-1" class="btn btn-warning btn-qty">-</a>
                                                            <span class="quantity-display">${entry.value.quantity}</span>
                                                            <a href="updatecart?productId=${entry.value.product.product_id}&quantity=1" class="btn btn-success btn-qty">+</a>
                                                        </div>
                                                    </td>
                                                    <td><a href="deletecart?productId=${entry.value.product.product_id}" class="btn btn-outline-danger border-0"><i class="fas fa-trash-alt"></i></a></td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="row py-5 p-4 bg-white rounded shadow-sm summary-section">
                    <div class="col-lg-6">
                        <div class="bg-light rounded-pill px-4 py-3 text-uppercase fw-bold"><i class="fas fa-ticket-alt me-2"></i>Voucher</div>
                        <div class="p-4">
                            <form action="${pageContext.request.contextPath}/applyvoucher" method="post">
                                <div class="input-group mb-2 border rounded-pill p-2 shadow-sm bg-white">
                                    <input type="text" placeholder="Nhập mã giảm giá..." class="form-control border-0 px-3 shadow-none" name="voucherCode" 
                                           value="${sessionScope.appliedVoucher.code}">
                                    <div class="input-group-append">
                                        <button type="submit" class="btn btn-dark px-4 rounded-pill fw-bold">Sử dụng </button>
                                    </div>
                                </div>
                            </form>

                            <%-- Hiển thị thông báo Voucher từ Session --%>
                            <c:if test="${not empty sessionScope.voucherMessage}">
                                <div class="alert alert-${sessionScope.voucherMessageStatus == 'success' ? 'success' : (sessionScope.voucherMessageStatus == 'error' ? 'danger' : 'info')} mt-3">
                                    <i class="fas fa-info-circle me-1"></i> ${sessionScope.voucherMessage} 
                                </div>
                                <%-- Xóa message sau khi hiển thị để tránh lặp lại khi load trang --%>
                                <c:remove var="voucherMessage" scope="session" />
                                <c:remove var="voucherMessageStatus" scope="session" />
                            </c:if>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="bg-light rounded-pill px-4 py-3 text-uppercase fw-bold"><i class="fas fa-calculator me-2"></i>Thành tiền</div> 
                        <div class="p-4">
                            <c:set var="totalAmount" value="${totalPrice != null ? totalPrice : 0}" /> 
                            <c:set var="discount" value="${sessionScope.discountAmount != null ? sessionScope.discountAmount : 0}" /> 

                            <%-- Tính phí ship mặc định 20% --%>
                            <c:set var="shippingFee" value="${totalAmount * 0.1}" /> 

                            <%-- Tính tổng cuối: Tiền hàng + Phí ship - Giảm giá --%>
                            <c:set var="finalTotal" value="${totalAmount + shippingFee - discount}" /> 
                            <c:if test="${finalTotal < 0}"><c:set var="finalTotal" value="0" /></c:if> 

                                <ul class="list-unstyled mb-4"> 
                                    <li class="d-flex justify-content-between py-3 border-bottom">
                                        <span class="text-muted">Tổng tiền hàng</span>
                                        <span class="fw-bold"><fmt:formatNumber value="${totalAmount}" pattern="#,###"/> VNĐ</span> 
                                </li>
                                <li class="d-flex justify-content-between py-3 border-bottom">
                                    <span class="text-muted">Phí vận chuyển (20%)</span>
                                    <span class="fw-bold"><fmt:formatNumber value="${shippingFee}" pattern="#,###"/> VNĐ</span> 
                                </li>
                                <c:if test="${discount > 0}"> 
                                    <li class="d-flex justify-content-between py-3 border-bottom text-danger">
                                        <span>Giảm giá Voucher (${sessionScope.appliedVoucher.code})</span> 
                                        <span class="fw-bold">- <fmt:formatNumber value="${discount}" pattern="#,###"/> VNĐ</span> 
                                    </li>
                                </c:if>
                                <li class="d-flex justify-content-between py-4 border-bottom">
                                    <strong class="text-dark h5 mb-0">Tổng thanh toán</strong> 
                                    <h4 class="fw-bold text-primary mb-0"><fmt:formatNumber value="${finalTotal}" pattern="#,###"/> VNĐ</h4> 
                                </li>
                            </ul>
                            <form action="${pageContext.request.contextPath}/payment" method="get">
                                <button type="submit" class="btn btn-primary rounded-pill btn-checkout-main shadow">Tiến hành thanh toán <i class="fas fa-chevron-right ms-2"></i></button> 
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>