<%-- order_list_employee.jsp (CÂN CHỈNH CỘT) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* CSS được giữ lại để định dạng bảng và cỡ chữ (1.3x) */
    .container-fluid {
        font-size: 1.3rem;
    }
    /* ... (CSS cũ) ... */
    
    /* ⭐ THÊM ĐƯỜNG VIỀN CHO CỘT VÀ HÀNG */
    .order-list-table,
    .order-list-table th, 
    .order-list-table td {
        border: 1px solid #dee2e6;
    }
    
    .order-list-table th {
        background-color: #007bff; 
        color: white;
        text-transform: uppercase;
        padding: 15px;
        font-size: 1.05rem; 
        text-align: center !important; /* CĂN GIỮA TIÊU ĐỀ */
    }
    
    .order-list-table td {
        vertical-align: middle;
        font-size: 1.3rem;
        padding: 15px 10px; 
    }
    /* Căn chỉnh nội dung cột */
    .col-id { width: 5%; text-align: center; }
    .col-date { width: 20%; text-align: center; }
    .col-amount { width: 15%; text-align: right; }
    .col-status { width: 15%; text-align: center; }
    .col-actions { width: 45%; text-align: center; }
    
    /* ... (CSS cũ) ... */
</style>

<div class="container-fluid mt-4"> 
    <div class="order-list-box">
        <h3><i class="fas fa-list-alt"></i> Danh Sách Đơn Hàng Cần Xử Lý (QLĐH)</h3>
        
        <%-- Hiển thị thông báo (Session Flash Message) --%>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <div class="table-responsive">
            <table class="table table-hover order-list-table">
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-date">Ngày đặt</th>
                        <th class="col-amount">Tổng tiền</th>
                        <th class="col-status">Trạng thái</th>
                        <th class="col-actions">Hành động</th>
                    </tr>
                </thead>
                
                <tbody>
                    <c:forEach var="order" items="${requestScope.orderList}">
                        <tr>
                            <td class="col-id text-primary fw-bold">${order.order_id}</td>
                            
                            <td class="col-date">${order.order_date.toString().replace('T', ' ')}</td>

                            <td class="col-amount text-danger">
                                <fmt:formatNumber value="${order.total_amount}" pattern="#,##0"/> VNĐ
                            </td>
                         
                            <td class="col-status">
                                <span class="badge 
                                    <c:choose>
                                        <c:when test="${order.status.name() eq 'DANG_GIAO'}">bg-warning text-dark</c:when>
                                        <c:when test="${order.status.name() eq 'HOAN_THANH'}">bg-success</c:when>
                                        <c:when test="${order.status.name() eq 'HUY'}">bg-danger</c:when>
                                        <c:when test="${order.status.name() eq 'APPROVED'}">bg-primary</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>
                                ">${order.status.dbValue}</span>
                            </td>
                            
                            <td class="col-actions">
                                <div class="action-group justify-content-center">
                                    
                                    <form method="post" action="${pageContext.request.contextPath}/employee/update-status" class="d-flex align-items-center gap-2">
                                        <input type="hidden" name="orderId" value="${order.order_id}">
                                        
                                        <select name="newStatus" class="form-select form-select-sm" required>
                                            <option value="" disabled selected>Cập nhật trạng thái</option>
                                            <option value="DANG_GIAO">Đang giao</option>
                                            <option value="HOAN_THANH">Hoàn thành</option>
                                            <option value="HUY">Hủy</option>
                                        </select>
                                        
                                        <button type="submit" class="btn btn-sm btn-primary">Cập nhật</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>  