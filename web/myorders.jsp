<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đơn hàng của tôi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
             /* Thêm các CSS cần thiết từ orders.jsp hoặc CSS chung của bạn */
             .order-table-container { 
                margin-top: 50px;
                padding: 20px;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
             }
        </style>
    </head>
    <body>
        
        <%-- CHÈN MENU NGANG (menu_horizontal.jsp) VÀO ĐÂY --%>
        <jsp:include page="menu_horizontal.jsp" /> 

        <div class="container">
            <div class="order-table-container">
                <h2 class="mb-4"><i class="fa fa-list"></i> Đơn hàng của tôi</h2>
                
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="alert alert-danger">${requestScope.errorMessage}</div>
                </c:if>

                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID Đơn hàng</th>
                            <th>Ngày đặt hàng</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.orders}">
                                <c:forEach var="order" items="${requestScope.orders}">
                                    <tr>
                                        <td>${order.order_id}</td>
                                        <td>${order.order_date.toLocalDate()}</td>
                                        <td>${order.total_amount}</td>
                                        <td>${order.status.dbValue}</td> 
                                        <td>
                                            <%-- Giả định có Controller /orderdetail để xem chi tiết từng đơn hàng --%>
                                            <a href="${pageContext.request.contextPath}/orderdetail?orderId=${order.order_id}" class="btn btn-sm btn-info">
                                                Xem chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center text-muted">Bạn chưa có đơn hàng nào.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>