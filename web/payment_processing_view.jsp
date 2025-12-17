<%-- payment_processing_view.jsp (ĐÃ RÚT GỌN VÀ SỬA LỖI JSTL) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid mt-4">
    
    <%-- Hiển thị thông báo (Session Flash Message) --%>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">${sessionScope.successMessage}</div> 
        <c:remove var="successMessage" scope="session"/> 
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/> 
    </c:if>
    
    <h3 class="mb-4"><i class="fas fa-money-check-alt"></i> Xử Lý Thanh Toán & Xuất Hóa Đơn</h3> 

    <form method="GET" action="${pageContext.request.contextPath}/payment_process" class="row mb-4">
        <div class="col-md-4">
            <label for="orderId" class="form-label">Nhập ID Đơn Hàng:</label>
            <input type="number" class="form-control" id="orderId" name="orderId" required value="${param.orderId}"> 
        </div>
        <div class="col-md-3 d-flex align-items-end">
            <button type="submit" class="btn btn-info w-100">Xem Chi Tiết</button> 
        </div>
    </form> 

    <c:if test="${requestScope.order != null}">
        <c:set var="order" value="${requestScope.order}"/> 
        <c:set var="payment" value="${requestScope.payment}"/> 

        <div class="card shadow mt-4">
            <div class="card-header bg-warning text-dark">
                <h5>Đơn hàng #${order.order_id} - Tổng tiền: <span class="text-danger"><fmt:formatNumber value="${order.total_amount}" pattern="#,##0"/> VNĐ</span></h5> 
            </div>
            <div class="card-body">

                <p>Trạng thái: <strong>${order.status.dbValue}</strong></p> 
                <p>Tình trạng thanh toán: 
                    <c:choose> 
                        <c:when test="${payment != null}"> 
                            <span class="badge bg-success">Đã Thanh Toán</span> (${payment.payment_method}) 
                        </c:when>
                        <c:otherwise> 
                            <span class="badge bg-danger">Chưa Thanh Toán</span> (QLĐH_08) 
                        </c:otherwise>
                    </c:choose>
                </p> 

                <hr>

                <c:if test="${payment == null}"> 
                    <%-- Form Xác nhận Thanh toán (QLĐH_08, 09, 10) --%>
                    <h6 class="mt-4">Xác Nhận Tiền Mặt</h6>
                    <form method="POST" action="${pageContext.request.contextPath}/payment_process"> 
                        <input type="hidden" name="action" value="confirm_payment"> 
                        <input type="hidden" name="orderId" value="${order.order_id}"> 
                        <input type="hidden" name="requiredAmount" value="${order.total_amount}"> 

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="amountReceived" class="form-label">Số tiền nhận được:</label> 
                                <input type="number" step="0.01" class="form-control" id="amountReceived" name="amountReceived" required> 
                            </div>
                            <div class="col-md-6 mb-3 d-flex align-items-end"> 
                                <button type="submit" class="btn btn-success w-100">Xác Nhận Thanh Toán</button> 
                            </div>
                        </div> 
                    </form>
                </c:if> 

                <c:if test="${payment != null}"> 
                    <%-- Nút Xuất Hóa Đơn (QLĐH_11) --%>
                    <h6 class="mt-4">Xuất Tài Liệu</h6>
                    <a href="${pageContext.request.contextPath}/payment_process?action=export_pdf&orderId=${order.order_id}" class="btn btn-secondary"> 
                        <i class="fas fa-file-pdf"></i> Xuất Hóa Đơn PDF (QLĐH_11) 
                    </a>
                </c:if> 
            </div> 
        </div>
    </c:if>
</div>