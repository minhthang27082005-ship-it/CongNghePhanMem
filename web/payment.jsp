<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- Import java.math.BigDecimal --%>
<%@ page import="java.math.BigDecimal" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác nhận Thanh toán</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&family=Open+Sans:wght=400;600&display=swap" rel="stylesheet">

        <%-- Custom CSS (giữ nguyên của bạn) --%>
        <style>
            body {
                font-family: 'Open Sans', sans-serif;
                background-color: #f0f2f5;
                color: #333;
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            .header-custom {
                background: linear-gradient(to right, #007bff, #0056b3);
                color: white;
                padding: 25px 0;
                text-align: center;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .header-custom h1 {
                font-family: 'Poppins', sans-serif;
                font-weight: 600;
                margin-bottom: 15px;
                font-size: 2.5rem;
            }
            .header-custom nav a {
                color: #e9ecef;
                text-decoration: none;
                margin: 0 15px;
                font-weight: 400;
                transition: color 0.3s ease;
            }
            .header-custom nav a:hover {
                color: #ffffff;
                text-decoration: underline;
            }

            .main-container {
                flex: 1;
                padding: 40px 0;
            }
            .card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
            }
            .card-header {
                background-color: #f8f9fa;
                border-bottom: 1px solid #e9ecef;
                padding: 20px;
                font-size: 1.3rem;
                font-weight: 600;
                color: #495057;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
                display: flex;
                align-items: center;
            }
            .card-header .bi {
                margin-right: 10px;
                font-size: 1.5rem;
                color: #007bff;
            }
            .card-body {
                padding: 30px;
            }

            .table-order-details th {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
                font-weight: 600;
            }
            .table-order-details tbody tr:nth-child(even) {
                background-color: #f8f9fa;
            }
            .table-order-details tbody tr:hover {
                background-color: #e2e6ea;
                transform: translateY(-2px);
                transition: all 0.2s ease;
            }
            .table-order-details td, .table-order-details th {
                vertical-align: middle;
                padding: 12px;
            }

            .card-shipping .form-control {
                border-radius: 8px;
            }

            .form-payment .form-label {
                font-weight: 600;
                color: #495057;
                margin-bottom: 8px;
            }
            .form-payment .form-control,
            .form-payment .form-select {
                border-radius: 8px;
                padding: 10px 15px;
                border: 1px solid #ced4da;
            }
            .form-payment .form-control:focus,
            .form-payment .form-select:focus {
                border-color: #80bdff;
                box-shadow: 0 0 0 0.25rem rgba(0, 123, 255, 0.25);
            }
            .btn-checkout {
                background-color: #28a745;
                border-color: #28a745;
                padding: 12px 30px;
                font-size: 1.1rem;
                font-weight: 600;
                border-radius: 8px;
                transition: background-color 0.3s ease, border-color 0.3s ease, transform 0.2s ease;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .btn-checkout .bi {
                margin-right: 8px;
            }
            .btn-checkout:hover {
                background-color: #218838;
                border-color: #1e7e34;
                transform: translateY(-2px);
            }

            .alert-custom {
                margin-top: 25px;
                border-radius: 8px;
                font-size: 1.05rem;
                padding: 18px 25px;
                display: flex;
                align-items: center;
            }
            .alert-custom .bi {
                font-size: 1.5rem;
                margin-right: 10px;
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border-color: #c3e6cb;
            }
            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border-color: #f5c6cb;
            }
            .alert-info {
                background-color: #d1ecf1;
                color: #0c5460;
                border-color: #bee5eb;
            }

            .footer-custom {
                background-color: #343a40;
                color: #adb5bd;
                text-align: center;
                padding: 25px 0;
                margin-top: auto;
                box-shadow: 0 -4px 8px rgba(0, 0, 0, 0.1);
                font-size: 0.95rem;
            }
        </style>
    </head>
    <body>

        <header class="header-custom">
            <div class="container">
                <h1><i class="bi bi-cart-check-fill"></i> Xác nhận và Thanh toán</h1>
                <nav>
                    <a href="${pageContext.request.contextPath}/home"><i class="bi bi-house-door-fill"></i> Trang chủ</a> |
                    <a href="${pageContext.request.contextPath}/cartdetail"><i class="bi bi-cart-fill"></i> Giỏ hàng</a> |
                    <a href="${pageContext.request.contextPath}/my-orders"><i class="bi bi-receipt"></i> Lịch sử Đơn hàng</a>
                </nav>
            </div>
        </header>

        <div class="container main-container">
            <div class="row">

                <%-- Cột Thông tin giao hàng và Nút Thanh toán --%>
                <div class="col-lg-6 col-md-12">

                    <%-- Hiển thị thông báo lỗi/thành công --%>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-custom" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <%-- FORM ĐẶT HÀNG - ACTION ĐÃ SỬA THÀNH /payment --%>
                    <form action="${pageContext.request.contextPath}/payment" method="post" class="form-payment">

                        <%-- THÔNG TIN GIAO HÀNG (BẮT BUỘC CHO SERVLET) --%>
                        <div class="card mb-4 card-shipping">
                            <div class="card-header">
                                <i class="bi bi-truck"></i> Thông tin Giao hàng
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="shipping_address" class="form-label">Địa chỉ nhận hàng (*):</label>
                                    <textarea id="shipping_address" name="shipping_address" class="form-control" rows="3" required placeholder="Nhập địa chỉ chi tiết (số nhà, đường, phường/xã)"></textarea>
                                </div>
                                <div class="mb-3">
                                    <label for="phone_number" class="form-label">Số điện thoại (*):</label>
                                    <input type="tel" id="phone_number" name="phone_number" class="form-control" required pattern="[0-9]{10,12}" title="Số điện thoại phải có 10-12 chữ số" placeholder="09xxxxxxxx">
                                </div>
                            </div>
                        </div>

                        <%-- PHƯƠNG THỨC THANH TOÁN --%>
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="bi bi-credit-card"></i> Phương thức Thanh toán
                            </div>
                            <div class="card-body">
                                <div class="mb-4">
                                    <label for="paymentMethod" class="form-label">Chọn phương thức thanh toán:</label>
                                    <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                        <option value="CASH_ON_DELIVERY" selected>Thanh toán khi nhận hàng (COD)</option>
                                        <option value="CREDIT_CARD">Thẻ tín dụng (VISA/Master)</option>
                                        <option value="PAYPAL">PayPal</option>
                                    </select>
                                </div>

                                <%-- Thông tin thẻ tín dụng (Chỉ hiện khi chọn CREDIT_CARD) --%>
                                <div id="creditCardInfo" style="display: none;">
                                    <div class="mb-3">
                                        <label for="cardNumber" class="form-label">Số thẻ tín dụng:</label>
                                        <input type="text" class="form-control" id="cardNumber" name="cardNumber" pattern="[0-9\s]{13,19}" title="Số thẻ phải có từ 13 đến 19 chữ số." placeholder="XXXX XXXX XXXX XXXX" autocomplete="cc-number">
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="expirationDate" class="form-label">Ngày hết hạn (MM/YY):</label>
                                            <input type="text" class="form-control" id="expirationDate" name="expirationDate" placeholder="MM/YY" autocomplete="cc-exp">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="cvv" class="form-label">CVV:</label>
                                            <input type="text" class="form-control" id="cvv" name="cvv" pattern="[0-9]{3,4}" title="CVV phải có 3 hoặc 4 chữ số." placeholder="XXX" autocomplete="cc-csc">
                                        </div>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-checkout w-100 mt-3">
                                    <i class="bi bi-cash-coin"></i> **HOÀN TẤT ĐẶT HÀNG**
                                </button>

                            </div>
                        </div>
                    </form>

                </div>

                <%-- Cột Tóm tắt Đơn hàng (Hiển thị dữ liệu động) --%>
                <div class="col-lg-6 col-md-12">
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="bi bi-list-check"></i> Tóm Tắt Đơn Hàng
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover table-order-details">
                                    <thead>
                                        <tr>
                                            <th style="width: 50%;">Sản phẩm</th>
                                            <th style="width: 15%;">SL</th>
                                            <th style="width: 35%;" class="text-end">Tổng tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%-- Lặp qua giỏ hàng (giả định object Cart tên 'cart' trong session) --%>
                                        <c:choose>
                                            <c:when test="${not empty cart.listItems}">
                                                <c:forEach var="itemEntry" items="${cart.listItems}">
                                                    <tr>
                                                        <td>${itemEntry.value.product.name}</td>
                                                        <td>${itemEntry.value.quantity}</td>
                                                        <td class="text-end">
                                                            <%-- Giả định CartItem có getTotalPrice() trả về double --%>
                                                            <fmt:formatNumber value="${itemEntry.value.totalPrice}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="3" class="text-center text-danger">Giỏ hàng trống. Vui lòng quay lại giỏ hàng.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <hr>

                            <%-- HIỂN THỊ TẠM TÍNH --%>
                            <div class="row">
                                <div class="col-6 text-start">Tạm tính (Tiền hàng):</div>
                                <div class="col-6 text-end">
                                    <c:set var="totalAmount" value="${requestScope.totalAmount != null ? requestScope.totalAmount : 0}" />
                                    <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                                </div>
                            </div>

                            <%-- THÊM DÒNG PHÍ VẬN CHUYỂN 10% --%>
                            <div class="row mt-2">
                                <div class="col-6 text-start text-muted">Phí vận chuyển (10%):</div>
                                <div class="col-6 text-end">
                                    <c:set var="shippingFee" value="${totalAmount * 0.1}" />
                                    <fmt:formatNumber value="${shippingFee}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                                </div>
                            </div>

                            <%-- HIỂN THỊ GIẢM GIÁ VOUCHER --%>
                            <c:set var="discountAmount" value="${sessionScope.discountAmount != null ? sessionScope.discountAmount : 0}" />
                            <c:if test="${discountAmount > 0}">
                                <div class="row mt-2 text-danger">
                                    <div class="col-6 text-start">Giảm giá Voucher:</div>
                                    <div class="col-6 text-end">- 
                                        <fmt:formatNumber value="${discountAmount}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                                    </div>
                                </div>
                            </c:if>

                            <hr>

                            <%-- TÍNH TỔNG THANH TOÁN CUỐI CÙNG --%>
                            <div class="row mt-3">
                                <div class="col-6 text-start h5"><strong>TỔNG THANH TOÁN:</strong></div>
                                <div class="col-6 text-end">
                                    <span class="text-primary fs-4">
                                        <%-- Công thức mới: Tiền hàng + Phí ship (10%) - Giảm giá --%>
                                        <c:set var="totalPayable" value="${totalAmount + shippingFee - discountAmount}" />
                                        <c:if test="${totalPayable < 0}">
                                            <c:set var="totalPayable" value="0" />
                                        </c:if>
                                        <fmt:formatNumber value="${totalPayable}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                                    </span>
                                </div>
                            </div>

                            <p class="text-muted text-end mt-2"><small>Thời gian hiện tại: <fmt:formatDate value="<%= new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm:ss"/></small></p>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <footer class="footer-custom">
            <div class="container">
                <p>&copy; 2024 Thang IT Plus. Tất cả các quyền được bảo lưu.</p>
            </div>
        </footer>

        <%-- Bootstrap 5.3 JS và Custom Script --%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eE+R7Yk+2bNnF-6C6hJmFcB0" crossorigin="anonymous"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var paymentMethodSelect = document.getElementById("paymentMethod");
                var creditCardInfoDiv = document.getElementById("creditCardInfo");
                var cardInputs = document.querySelectorAll('#creditCardInfo input');

                function toggleCreditCardFields() {
                    if (paymentMethodSelect.value === "CREDIT_CARD") {
                        creditCardInfoDiv.style.display = "block";
                        cardInputs.forEach(input => input.setAttribute("required", "required"));
                    } else {
                        creditCardInfoDiv.style.display = "none";
                        cardInputs.forEach(input => input.removeAttribute("required"));
                    }
                }

                paymentMethodSelect.addEventListener("change", toggleCreditCardFields);
                toggleCreditCardFields();

                // Script định dạng số thẻ tín dụng và ngày hết hạn
                var cardNumberInput = document.getElementById("cardNumber");
                var expirationDateInput = document.getElementById("expirationDate");

                if (cardNumberInput) {
                    cardNumberInput.addEventListener('input', function (e) {
                        var target = e.target;
                        var value = target.value.replace(/\s+/g, '').replace(/\D/g, ''); // Remove all spaces and non-digits
                        var formattedValue = '';
                        for (var i = 0; i < value.length; i++) {
                            if (i > 0 && i % 4 === 0) {
                                formattedValue += ' ';
                            }
                            formattedValue += value[i];
                        }
                        target.value = formattedValue.trim();
                    });
                }

                if (expirationDateInput) {
                    expirationDateInput.addEventListener('input', function (e) {
                        var target = e.target;
                        var value = target.value.replace(/\D/g, ''); // Chỉ giữ lại số

                        if (value.length > 2) {
                            // Chèn dấu gạch chéo
                            value = value.substring(0, 2) + '/' + value.substring(2, 4);
                        }
                        target.value = value.substring(0, 5); // Giới hạn MM/YY
                    });
                }
            });
        </script>
    </body>
</html>