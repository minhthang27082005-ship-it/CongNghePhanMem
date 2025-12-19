<%-- inventory_management.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .inventory-card { border-radius: 15px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
    .nav-tabs-custom .nav-link { border: none; color: #6c757d; font-weight: 600; padding: 12px 25px; font-size: 1.1rem; }
    .nav-tabs-custom .nav-link.active { color: #0d6efd; border-bottom: 3px solid #0d6efd; background: none; }
    .table-custom { font-size: 1.1rem; }
    .table-custom th { background-color: #f8f9fa; }
    .badge-stock { padding: 8px 12px; border-radius: 8px; font-size: 0.9rem; }
</style>

<div class="container-fluid mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-dark"><i class="bi bi-box-seam me-2"></i>Quản Lý Kho Hàng</h2>
    </div>

    <%-- Thông báo --%>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <%-- Thanh Tab điều hướng --%>
    <ul class="nav nav-tabs nav-tabs-custom mb-4" id="inventoryTab" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" id="stock-tab" data-bs-toggle="tab" data-bs-target="#stock" type="button">
                <i class="bi bi-list-ul me-2"></i>Tồn Kho
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="import-tab" data-bs-toggle="tab" data-bs-target="#import" type="button">
                <i class="bi bi-plus-circle me-2"></i>Nhập Kho
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="export-tab" data-bs-toggle="tab" data-bs-target="#export" type="button">
                <i class="bi bi-dash-circle me-2"></i>Xuất Kho
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button">
                <i class="bi bi-clock-history me-2"></i>Lịch Sử
            </button>
        </li>
    </ul>

    <div class="tab-content mt-3" id="inventoryTabContent">
        
        <%-- TAB 1: KIỂM TRA TỒN KHO --%>
        <div class="tab-pane fade show active" id="stock" role="tabpanel">
            <div class="card inventory-card">
                <div class="card-body">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Sản Phẩm</th>
                                <th>Giá Bán</th>
                                <th class="text-center">Số Lượng Tồn</th>
                                <th>Mô Tả</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${requestScope.listProduct}">
                                <tr>
                                    <td><strong>#${p.product_id}</strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${p.image}" class="rounded me-3" style="width: 50px; height: 50px; object-fit: cover;">
                                            <span class="fw-bold">${p.name}</span>
                                        </div>
                                    </td>
                                    <td><fmt:formatNumber value="${p.price}" pattern="#,##0"/> VNĐ</td>
                                    <td class="text-center">
                                        <span class="badge badge-stock ${p.stock < 10 ? 'bg-danger' : 'bg-success'}">
                                            ${p.stock} sản phẩm
                                        </span>
                                    </td>
                                    <td class="text-muted small">${p.description}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%-- TAB 2 & 3: NHẬP VÀ XUẤT KHO (Dùng chung cấu trúc Grid) --%>
        <div class="tab-pane fade" id="import" role="tabpanel">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card inventory-card border-top border-danger border-4">
                        <div class="card-body p-4">
                            <h4 class="fw-bold text-danger mb-4"><i class="bi bi-box-arrow-in-down me-2"></i>Phiếu Nhập Kho</h4>
                            <form action="${pageContext.request.contextPath}/nhapkho" method="POST">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Chọn Sản Phẩm (ID):</label>
                                    <input type="number" name="productId" class="form-control form-control-lg" required placeholder="Nhập ID sản phẩm">
                                </div>
                                <div class="mb-4">
                                    <label class="form-label fw-bold">Số Lượng Nhập:</label>
                                    <input type="number" name="quantity" class="form-control form-control-lg" required min="1" placeholder="Số lượng > 0">
                                </div>
                                <button type="submit" class="btn btn-danger btn-lg w-100 shadow-sm">Xác Nhận Nhập</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="export" role="tabpanel">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card inventory-card border-top border-primary border-4">
                        <div class="card-body p-4">
                            <h4 class="fw-bold text-primary mb-4"><i class="bi bi-box-arrow-up me-2"></i>Phiếu Xuất Kho</h4>
                            <form action="${pageContext.request.contextPath}/xuatkho" method="POST">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Chọn Sản Phẩm (ID):</label>
                                    <input type="number" name="productId" class="form-control form-control-lg" required placeholder="Nhập ID sản phẩm">
                                </div>
                                <div class="mb-4">
                                    <label class="form-label fw-bold">Số Lượng Xuất:</label>
                                    <input type="number" name="quantity" class="form-control form-control-lg" required min="1">
                                </div>
                                <button type="submit" class="btn btn-primary btn-lg w-100 shadow-sm">Xác Nhận Xuất</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- TAB 4: LỊCH SỬ --%>
        <div class="tab-pane fade" id="history" role="tabpanel">
            <div class="card inventory-card">
                <div class="card-body">
                    <form method="GET" action="${pageContext.request.contextPath}/quanlykho" class="row g-3 mb-4">
                        <input type="hidden" name="tab" value="history">
                        <div class="col-md-4">
                            <label class="form-label small fw-bold">Từ ngày</label>
                            <input type="date" name="startDate" class="form-control" value="${param.startDate}">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold">Đến ngày</label>
                            <input type="date" name="endDate" class="form-control" value="${param.endDate}">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-dark w-100"><i class="bi bi-filter"></i> Lọc</button>
                        </div>
                    </form>
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>ID Giao Dịch</th>
                                <th>Sản Phẩm</th>
                                <th>Thời Gian</th>
                                <th>Loại</th>
                                <th>Số Lượng</th>
                                <th>Nhân Viên</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${requestScope.historyList}">
                                <tr>
                                    <td>#${item.transactionId}</td>
                                    <td>ID: ${item.productId}</td>
                                    <td>${item.transactionDate}</td>
                                    <td>
                                        <span class="badge ${item.type == 'NHAP' ? 'bg-danger' : 'bg-success'} text-uppercase">
                                            ${item.type == 'NHAP' ? 'Nhập' : 'Xuất'}
                                        </span>
                                    </td>
                                    <td class="fw-bold text-center">${item.quantity}</td>
                                    <td>${item.employeeName}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Giữ cho Tab hiện tại không bị mất khi Load lại trang hoặc Lọc lịch sử
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const tab = urlParams.get('tab');
        if (tab) {
            const triggerEl = document.querySelector('#' + tab + '-tab');
            if (triggerEl) bootstrap.Tab.getOrCreateInstance(triggerEl).show();
        }
    });
</script>