<%-- inventory_export.jsp (ĐÃ RÚT GỌN) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid mt-4">
    
    <%-- LOGIC HIỂN THỊ THÔNG BÁO TỪ SESSION --%>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <h3 class="mb-4"><i class="fas fa-sign-out-alt"></i> Xuất Kho</h3>
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Thực Hiện Xuất Kho</h4>
                </div>
                <div class="card-body">
                    
                    <form method="POST" action="${pageContext.request.contextPath}/xuatkho">
                        <div class="mb-3">
                            <label for="productId" class="form-label">ID Sản Phẩm:</label>
                            <input type="number" class="form-control" id="productId" name="productId" required min="1">
                        </div>
                        <div class="mb-3">
                            <label for="quantity" class="form-label">Số Lượng Xuất:</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" required min="1">
                        </div>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-truck-loading"></i> Xác Nhận Xuất Kho</button>
                        <p class="mt-3 text-danger">Lưu ý: Hệ thống sẽ kiểm tra tồn kho trước khi xuất.</p>
                    </form>
                    
                </div>
            </div>
        </div>
    </div>
</div>