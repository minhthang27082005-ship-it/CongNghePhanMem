<%-- inventory_history.jsp (ĐÃ RÚT GỌN) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid mt-4">
    <h3 class="mb-4"><i class="fas fa-history"></i> Lịch Sử Nhập/Xuất Kho</h3>

    <%-- Hiển thị thông báo (Session Flash Message) --%>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">${sessionScope.successMessage}</div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <%-- Form Lọc theo Ngày (QLK_08) --%>
    <form method="GET" action="${pageContext.request.contextPath}/lichsukho" class="row mb-4 align-items-end">
        <div class="col-md-4">
            <label for="startDate" class="form-label">Từ Ngày:</label>
            <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
        </div>
        <div class="col-md-4">
            <label for="endDate" class="form-label">Đến Ngày:</label>
            <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
        </div>
        <div class="col-md-4">
            <button type="submit" class="btn btn-secondary"><i class="fas fa-filter"></i> Lọc </button>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID Giao Dịch</th>
                    <th>ID Sản Phẩm</th>
                    <th>Thời Gian</th>
                    <th>Loại</th>
                    <th>Số Lượng</th>
                    <th>Nhân Viên</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty requestScope.historyList}">
                        <c:forEach var="item" items="${requestScope.historyList}">
                            <tr>
                                <td>${item.transactionId}</td>
                                <td>${item.productId}</td>
                                <td>${item.transactionDate}</td>
                                <td>
                                    <span class="badge ${item.type == 'NHAP' ? 'bg-danger' : 'bg-success'}">
                                        ${item.type == 'NHAP' ? 'NHẬP' : 'XUẤT'}
                                    </span>
                                </td>
                                <td>${item.quantity}</td>
                                <td>${item.employeeName}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center">Không tìm thấy lịch sử giao dịch nào.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>