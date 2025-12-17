<%-- customer_history_emp.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .history-card {
        padding: 30px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        border-radius: 8px;
        background-color: #fff;
    }
    .order-history-table th {
        background-color: #007bff;
        color: white;
    }
    .order-history-table td {
        font-size: 1.1rem;
    }
</style>

<div class="container-fluid mt-4">
    
    <c:if test="${requestScope.customer != null}">
        <h3 class="mb-4"><i class="fas fa-clipboard-list"></i> Lịch sử mua hàng của ${requestScope.customer.name}</h3>
        
        <div class="history-card mb-4">
            <h5>Thông tin Khách hàng</h5>
            <p><strong>ID:</strong> ${requestScope.customer.user_id}</p>
            <p><strong>Số điện thoại:</strong> ${requestScope.customer.phone}</p>
            <p><strong>Địa chỉ:</strong> ${requestScope.customer.address}</p>
        </div>

        <h4>Các Đơn hàng đã đặt</h4>
        <c:choose>
            <c:when test="${not empty requestScope.orderHistory}">
                <div class="table-responsive">
                    <table class="table table-bordered order-history-table">
                        <thead>
                            <tr>
                                <th>ID Đơn hàng</th>
                                <th>Ngày đặt</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${requestScope.orderHistory}">
                                <tr>
                                    <td>${order.order_id}</td>
                                    <td>${order.order_date.toString().replace('T', ' ')}</td>
                                    <td><fmt:formatNumber value="${order.total_amount}" pattern="#,##0"/> VNĐ</td>
                                    <td><span class="badge bg-primary">${order.status.dbValue}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">Khách hàng này chưa có đơn hàng nào.</div>
            </c:otherwise>
        </c:choose>
    </c:if>
    
    <a href="${pageContext.request.contextPath}/employee/customers" class="btn btn-secondary mt-3">
        <i class="fas fa-arrow-left"></i> Quay lại tìm kiếm
    </a>
</div>