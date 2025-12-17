<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết Đơn hàng #${requestScope.order.order_id}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            /* CSS giữ nguyên */
            .detail-card {
                padding: 30px;
                margin-top: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                background-color: #ffffff;
            }
            .order-status {
                font-size: 1.1em;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        
        <jsp:include page="menu_horizontal.jsp" /> 

        <div class="container">
            <div class="detail-card">
                <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-secondary mb-4">
                    <i class="fa fa-arrow-left"></i> Quay lại
                </a>
                
                <h2 class="mb-4">Chi tiết Đơn hàng <span class="text-primary">#${requestScope.order.order_id}</span></h2>

                <%-- PHẦN THÔNG TIN CHUNG & TRẠNG THÁI --%>
                <div class="row mb-5">
                    <div class="col-md-6">
                        <h4><i class="fa fa-info-circle"></i> Tóm tắt Đơn hàng</h4>
                        <p><strong>Ngày đặt:</strong> ${requestScope.order.order_date.toLocalDate()}</p>
                        <p><strong>Tổng tiền (bao gồm VAT/Voucher):</strong> 
                           <span class="text-danger fs-5">
                               <fmt:formatNumber value="${requestScope.order.total_amount}" pattern="#,##0"/> VNĐ
                           </span>
                        </p>
                        <p><strong>Mã giảm giá đã dùng:</strong> 
                            <c:choose>
                                <c:when test="${requestScope.voucher != null}">#${requestScope.voucher.code}</c:when>
                                <c:otherwise>Không áp dụng</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="col-md-6">
                        <h4><i class="fa fa-truck"></i> Thông tin Giao hàng</h4>
                        <p><strong>Người nhận:</strong> ${sessionScope.user.name}</p>
                        <p><strong>Địa chỉ:</strong> ${requestScope.order.shipping_address}</p>
                        <p><strong>Điện thoại:</strong> ${requestScope.order.phone_number}</p>
                        <p><strong>Trạng thái:</strong> 
                            <span class="order-status text-success">${requestScope.order.status.dbValue}</span>
                        </p>
                        <%-- Thông tin thanh toán (bổ sung từ Controller) --%>
                    </div>
                </div>

                <%-- PHẦN CHI TIẾT SẢN PHẨM --%>
                <h3 class="mb-3"><i class="fa fa-shopping-basket"></i> Danh sách Sản phẩm</h3>
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <%-- ĐÃ BỎ <th>Ảnh</th> --%>
                            <th>Sản phẩm</th>
                            <th class="text-center">Số lượng</th>
                            <th class="text-end">Đơn giá</th>
                            <th class="text-end">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="detail" items="${requestScope.details}">
                            <tr>
                                <%-- CỘT SẢN PHẨM --%>
                                <td class="align-middle">
                                    <h5 class="mb-0">
                                        <strong class="text-dark d-inline-block">${detail.product_name}</strong>
                                    </h5>
                                </td>
                                
                                <%-- CỘT SỐ LƯỢNG --%>
                                <td class="text-center align-middle">${detail.quantity}</td>
                                
                                <%-- CỘT ĐƠN GIÁ --%>
                                <td class="text-end align-middle">
                                    <fmt:formatNumber value="${detail.unit_price}" pattern="#,##0"/> VNĐ
                                </td>
                                
                                <%-- CỘT THÀNH TIỀN --%>
                                <td class="text-end text-danger align-middle">
                                    <c:set var="subTotal" value="${detail.unit_price * detail.quantity}" />
                                    <fmt:formatNumber value="${subTotal}" pattern="#,##0"/> VNĐ
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>