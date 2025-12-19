<%-- customer_management_emp.jsp (PHIÊN BẢN HOÀN CHỈNH TÍCH HỢP THÊM MỚI) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .customer-table-section table {
        font-size: 1.2rem;
    }
    /* Đã sửa màu nền th */
    .customer-table-section th {
        background-color: #007bff; /* Màu xanh dương */
        color: white;
        padding: 15px;
        text-align: center;
    }
    .customer-table-section td, .customer-table-section th {
        border: 1px solid #ddd;
        vertical-align: middle;
        padding: 10px 15px;
        text-align: center;
    }
    .customer-table-section td:nth-child(2), /* Tên */
    .customer-table-section td:nth-child(3), /* Email */
    .customer-table-section td:nth-child(5) /* Địa chỉ */
    {
        text-align: left; /* Căn trái cho các trường văn bản dài */
    }
</style>

<div class="container-fluid mt-4">
    <h3 class="mb-4"><i class="fas fa-search"></i> Tìm kiếm Khách hàng</h3>

    <%-- Hiển thị thông báo LỖI (session scope) --%>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show">
            ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    
    <%-- Hiển thị thông báo THÀNH CÔNG (session scope) --%>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show">
            ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <%-- Hiển thị thông báo CẢNH BÁO (request scope từ Flash Session) --%>
    <c:if test="${not empty requestScope.warningMessage}">
        <div class="alert alert-warning">${requestScope.warningMessage}</div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <%-- NÚT THÊM MỚI NGƯỜI DÙNG --%>
        <button type="button" class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
            <i class="fas fa-user-plus me-2"></i>Thêm Khách Hàng Mới
        </button>
    </div>

    <%-- Form Tìm kiếm Khách hàng --%>
    <div class="card shadow mb-4">
        <div class="card-body">
            <form method="GET" action="${pageContext.request.contextPath}/employee/customers" class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label for="searchType" class="form-label">Tìm kiếm theo:</label>
                    <select id="searchType" name="searchType" class="form-select" required>
                        <option value="phone" ${requestScope.currentSearchType == 'phone' ? 'selected' : ''}>Số điện thoại (QLKH_01)</option>
                        <option value="name" ${requestScope.currentSearchType == 'name' ? 'selected' : ''}>Tên Khách hàng (QLKH_02)</option>
                    </select>
                </div>
                <div class="col-md-5">
                    <label for="keyword" class="form-label">Từ khóa:</label>
                    <input type="text" class="form-control" id="keyword" name="keyword" value="${requestScope.currentKeyword}" required>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-success w-100"><i class="fas fa-search"></i> Tìm Kiếm</button>
                </div>
            </form>
        </div>
    </div>
    
    <%-- Hiển thị Danh sách Khách hàng --%>
    <c:if test="${not empty requestScope.customerList}">
        <h4 class="mt-5"><i class="fas fa-address-book"></i> Kết quả tìm kiếm</h4>
        <div class="customer-table-section table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th style="width: 5%;">ID</th>
                        <th style="width: 25%;">Tên Khách hàng</th>
                        <th style="width: 20%;">Email</th>
                        <th style="width: 15%;">Số ĐT</th>
                        <th style="width: 25%;">Địa chỉ</th>
                        <th style="width: 10%;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="customer" items="${requestScope.customerList}">
                        <tr>
                            <td>${customer.user_id}</td>
                            <td>${customer.name}</td>
                            <td>${customer.email}</td>
                            <td>${customer.phone}</td>
                            <td>${customer.address}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/employee/customer-history?userId=${customer.user_id}" class="btn btn-sm btn-info" title="Xem lịch sử mua hàng">
                                    <i class="fas fa-history"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <%-- MODAL THÊM MỚI KHÁCH HÀNG --%>
    <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/add-customer" method="POST">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="addCustomerModalLabel"><i class="fas fa-user-plus me-2"></i>Thêm Khách Hàng Mới</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mã số ID (*):</label>
                            <input type="number" name="id" class="form-control" placeholder="Nhập ID (Ví dụ: 105)" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Họ và tên (*):</label>
                            <input type="text" name="name" class="form-control" placeholder="Nhập tên khách hàng" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Email (*):</label>
                            <input type="email" name="email" class="form-control" placeholder="example@mail.com" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mật khẩu (*):</label>
                            <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu mặc định" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Số điện thoại:</label>
                            <input type="text" name="phone" class="form-control" placeholder="Nhập SĐT">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Địa chỉ:</label>
                            <textarea name="address" class="form-control" rows="2" placeholder="Nhập địa chỉ"></textarea>
                        </div>
                        <%-- Mặc định vai trò là customer --%>
                        <input type="hidden" name="role" value="customer">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-primary px-4">Lưu thông tin</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- JAVASCRIPT KHẮC PHỤC LỖI DUY TRÌ KEYWORD KHI THAY ĐỔI LOẠI TÌM KIẾM --%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const searchTypeSelect = document.getElementById('searchType');
            const keywordInput = document.getElementById('keyword');
            
            // Lắng nghe sự kiện thay đổi của dropdown Tìm kiếm theo
            searchTypeSelect.addEventListener('change', function() {
                // Xóa nội dung của ô input keyword khi người dùng thay đổi loại tìm kiếm
                keywordInput.value = '';
                
                // Tùy chọn: Đặt focus vào ô input để người dùng bắt đầu nhập ngay
                keywordInput.focus();
            });
        });
    </script>
</div>