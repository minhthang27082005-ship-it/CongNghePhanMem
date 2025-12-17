<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Mã Giảm Giá</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <style>
            /* --- CSS Styles Thống nhất --- */
            body {
                display: flex;
                min-height: 100vh;
                background-color: #f8f9fa;
            }
            .menu {
                width: 250px;
                position: fixed;
                top: 0;
                bottom: 0;
                left: 0;
                background: #343a40;
                color: white;
                transform: translateX(0%);
                transition: transform 0.3s ease;
                padding-top: 0;
                overflow-y: auto;
                z-index: 1030;
            }
            .menu .text-white {
                background-color: #343a40;
                padding: 15px 20px;
                font-size: 1.5rem;
                font-weight: 700;
                border-bottom: 1px solid #495057;
            }
            .list-group-item {
                background-color: #343a40;
                color: #adb5bd;
                border: none;
                padding: 12px 20px;
                display: block;
                text-decoration: none;
                transition: background-color 0.3s ease;
            }
            .list-group-item:hover, .list-group-item.active {
                background-color: #007bff;
                color: white;
            }
            .list-group-item.active {
                border-left: 5px solid white;
                padding-left: 15px;
            }
            .list-group-item i {
                margin-right: 10px;
            }
            .main-content-wrapper {
                margin-left: 250px;
                width: calc(100% - 250px);
                padding: 20px;
            }
            .content-section {
                background-color: #ffffff;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <%-- SIDEBAR MENU --%>
        <div class="menu" id="menu">
            <div class="text-white text-center py-3 mb-3">
                <h4>Admin Panel</h4>
            </div>
            <div class="list-group">
                <a href="${pageContext.request.contextPath}/admin" class="list-group-item list-group-item-action">
                    <i class="bi bi-speedometer2"></i> Tổng quan hệ thống
                </a>
                <a href="${pageContext.request.contextPath}/admin/profile" class="list-group-item list-group-item-action">
                    <i class="bi bi-person-fill"></i> Hồ sơ cá nhân
                </a>
                <a href="${pageContext.request.contextPath}/listproducts" class="list-group-item list-group-item-action">
                    <i class="bi bi-box-seam-fill"></i> Quản lý Sản Phẩm
                </a>
                <a href="${pageContext.request.contextPath}/customer-list" class="list-group-item list-group-item-action">
                    <i class="bi bi-people-fill"></i> Quản lý Khách Hàng
                </a>
                <a href="${pageContext.request.contextPath}/employeelist" class="list-group-item list-group-item-action">
                    <i class="bi bi-person-badge-fill"></i> Quản lý Nhân Viên
                </a>
                <a href="${pageContext.request.contextPath}/orderlist" class="list-group-item list-group-item-action">
                    <i class="bi bi-journal-text"></i> Quản lý Đơn Hàng
                </a>
                <a href="${pageContext.request.contextPath}/supplierlist" class="list-group-item list-group-item-action">
                    <i class="bi bi-truck"></i> Quản lý Nhà Cung Cấp
                </a>
                <a href="${pageContext.request.contextPath}/voucherslist" class="list-group-item list-group-item-action active">
                    <i class="bi bi-gift-fill"></i> Quản lý Mã Giảm Giá
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="list-group-item list-group-item-action">
                    <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                </a>
            </div>
        </div>

        <div class="main-content-wrapper" id="mainContentWrapper">
            <div id="voucherManagementSection" class="container-fluid content-section">
                <h2 class="mb-3"><i class="bi bi-ticket-fill"></i> Quản Lý Mã Giảm Giá</h2>
                <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addVoucherModal">
                    <i class="bi bi-plus-circle"></i> Thêm Mã Mới
                </button>
                <p>Tổng số mã: ${not empty requestScope.listVouchers ? requestScope.listVouchers.size() : 0}</p>
                <div class="table-responsive">

                    <%-- PHẦN HIỂN THỊ THÔNG BÁO (ĐÃ CHỈNH SỬA) --%>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill"></i> ${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="successMessage" scope="session"/>
                    </c:if>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session"/>
                    </c:if>

                    

                    <div class="table-responsive">
                        <table class="table table-striped table-bordered" id="voucherTable">
                            <thead class="table-primary">
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">MÃ CODE</th>
                                    <th scope="col">LOẠI GIẢM</th>
                                    <th scope="col">GIÁ TRỊ</th>
                                    <th scope="col">ĐƠN TỐI THIỂU</th>
                                    <th scope="col">GIỚI HẠN DÙNG</th>
                                    <th scope="col">NGÀY BẮT ĐẦU</th>
                                    <th scope="col">NGÀY HẾT HẠN</th>
                                    <th scope="col">TRẠNG THÁI</th>
                                    <th scope="col">HÀNH ĐỘNG</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.listVouchers}"> 
                                        <c:forEach var="voucher" items="${requestScope.listVouchers}">
                                            <tr>
                                                <th scope="row">${voucher.voucher_id}</th>
                                                <td><strong>${voucher.code}</strong></td>
                                                <td>${voucher.discountType}</td> 
                                                <td>${voucher.discountValue}</td> 
                                                <td>${voucher.minOrderAmount}</td> 
                                                <td>${voucher.timesUsed}/${voucher.usageLimit}</td>
                                                <td>${voucher.startDate}</td> 
                                                <td>${voucher.endDate}</td> 
                                                <td>
                                                    <span class="badge ${voucher.isActive() ? 'bg-success' : 'bg-danger'}">
                                                        ${voucher.isActive() ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-danger btn-sm" onclick="confirmDelete(${voucher.voucher_id}, '${voucher.code}')" title="Xóa">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                    &nbsp;&nbsp;
                                                    <button class="btn btn-warning btn-sm btnEditVoucher"
                                                            data-id="${voucher.voucher_id}" data-code="${voucher.code}"
                                                            data-type="${voucher.discountType}" data-value="${voucher.discountValue}"
                                                            data-minamount="${voucher.minOrderAmount}" data-limit="${voucher.usageLimit}"
                                                            data-startdate="${voucher.startDate}" data-enddate="${voucher.endDate}"
                                                            data-isactive="${voucher.isActive()}" data-bs-toggle="modal" 
                                                            data-bs-target="#editVoucherModal" title="Sửa">
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr><td colspan="10" class="text-center text-muted">Chưa có mã giảm giá nào được tạo.</td></tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <%-- Modal THÊM MỚI --%>
            <div class="modal fade" id="addVoucherModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addModalLabel">Thêm Mã Giảm Giá Mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/vouchersadd" method="post">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="addCode" class="col-form-label">Mã Code (*):</label>
                                    <input type="text" name="code" class="form-control" id="addCode" placeholder="VD: TET2026" required>
                                </div>
                                <div class="mb-3">
                                    <label for="addDiscountType" class="col-form-label">Loại Giảm (*):</label>
                                    <select class="form-select" name="discountType" id="addDiscountType" required>
                                        <option value="percentage_product">Phần trăm Sản phẩm</option>
                                        <option value="percentage_order">Phần trăm Đơn hàng</option>
                                        <option value="fixed_amount">Giảm số tiền cố định</option>
                                        <option value="free_shipping">Miễn phí Vận chuyển</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="addDiscountValue" class="col-form-label">Giá trị (%, hoặc VNĐ) (*):</label>
                                    <input type="number" step="0.01" class="form-control" name="discountValue" id="addDiscountValue" min="0" required>
                                </div>
                                <div class="mb-3">
                                    <label for="addMinOrderAmount" class="col-form-label">Đơn hàng Tối thiểu (*):</label>
                                    <input type="number" step="0.01" class="form-control" name="minOrderAmount" id="addMinOrderAmount" min="0" required>
                                </div>
                                <div class="mb-3">
                                    <label for="addUsageLimit" class="col-form-label">Giới hạn sử dụng (*):</label>
                                    <input type="number" class="form-control" name="usageLimit" id="addUsageLimit" min="1" required>
                                </div>
                                <div class="mb-3">
                                    <label for="addStartDate" class="col-form-label">Ngày Bắt đầu (*):</label>
                                    <input type="datetime-local" class="form-control" name="startDate" id="addStartDate" required>
                                </div>
                                <div class="mb-3">
                                    <label for="addEndDate" class="col-form-label">Ngày Hết hạn (*):</label>
                                    <input type="datetime-local" class="form-control" name="endDate" id="addEndDate" required>
                                </div>
                                <div class="mb-3">
                                    <label for="addIsActive" class="col-form-label">Trạng thái (*):</label>
                                    <select class="form-select" name="isActive" id="addIsActive" required>
                                        <option value="true" selected>Active</option>
                                        <option value="false">Inactive</option>
                                    </select>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                <button type="submit" class="btn btn-primary">Thêm</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <%-- Modal CẬP NHẬT --%>
            <div class="modal fade" id="editVoucherModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editModalLabel">Cập nhật Mã Giảm Giá</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/vouchersedit" method="post">
                            <div class="modal-body">
                                <input type="hidden" name="voucherId" id="editVoucherId"/> 
                                <div class="mb-3">
                                    <label for="editCode" class="col-form-label">Mã Code (*):</label>
                                    <input type="text" name="code" class="form-control" id="editCode" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editDiscountType" class="col-form-label">Loại Giảm Giá (*):</label>
                                    <select class="form-select" name="discountType" id="editDiscountType" required>
                                        <option value="percentage_product">Phần trăm Sản phẩm</option>
                                        <option value="percentage_order">Phần trăm Đơn hàng</option>
                                        <option value="fixed_amount">Giảm số tiền cố định</option>
                                        <option value="free_shipping">Miễn phí Vận chuyển</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="editDiscountValue" class="col-form-label">Giá trị (%, hoặc VNĐ) (*):</label>
                                    <input type="number" step="0.01" class="form-control" name="discountValue" id="editDiscountValue" min="0" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editMinOrderAmount" class="col-form-label">Đơn hàng Tối thiểu (*):</label>
                                    <input type="number" step="0.01" class="form-control" name="minOrderAmount" id="editMinOrderAmount" min="0" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editUsageLimit" class="col-form-label">Giới hạn sử dụng (*):</label>
                                    <input type="number" class="form-control" name="usageLimit" id="editUsageLimit" min="1" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editStartDate" class="col-form-label">Ngày Bắt đầu (*):</label>
                                    <input type="datetime-local" class="form-control" name="startDate" id="editStartDate" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editEndDate" class="col-form-label">Ngày Hết hạn (*):</label>
                                    <input type="datetime-local" class="form-control" name="endDate" id="editEndDate" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editIsActive" class="col-form-label">Trạng thái Kích hoạt (*):</label>
                                    <select class="form-select" name="isActive" id="editIsActive" required>
                                        <option value="true">Active</option>
                                        <option value="false">Inactive</option>
                                    </select>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                <button type="submit" class="btn btn-primary">Cập nhật</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <%-- Modal XÓA --%>
            <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/vouchersdelete" method="get">
                            <div class="modal-header">
                                <h5 class="modal-title" id="deleteModalLabel">Xác nhận Xóa</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <p class="text-question">Bạn có muốn xóa mã giảm giá này không?</p>
                                <input type="hidden" id="voucherIdToDelete" name="id" value="" >
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                <button type="submit" class="btn btn-danger">Xóa</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                                                        function formatTimestampForInput(timestamp) {
                                                            if (!timestamp)
                                                                return '';
                                                            let datePart = timestamp.substring(0, 10);
                                                            let timePart = timestamp.substring(11, 16);
                                                            return `${datePart}T${timePart}`;
                                                                }

                                                                $(document).ready(function () {
                                                                    // Xử lý Active Menu Item
                                                                    $('.menu .list-group-item').removeClass('active');
                                                                    $('.menu a[href*="/voucherslist"]').addClass('active');

                                                                    // Mở Modal Xóa
                                                                    window.confirmDelete = function (id, code) {
                                                                        $('#voucherIdToDelete').val(id);
                                                                        $('.text-question').text("Bạn có muốn xóa mã giảm giá \"" + code + "\" này không?");
                                                                        var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                                                                        deleteModal.show();
                                                                    }

                                                                    // Đổ dữ liệu vào Modal Sửa
                                                                    $('.btnEditVoucher').on('click', function () {
                                                                        $('#editVoucherId').val($(this).data('id'));
                                                                        $('#editCode').val($(this).data('code'));
                                                                        $('#editDiscountType').val($(this).data('type'));
                                                                        $('#editDiscountValue').val($(this).data('value'));
                                                                        $('#editMinOrderAmount').val($(this).data('minamount'));
                                                                        $('#editUsageLimit').val($(this).data('limit'));
                                                                        $('#editStartDate').val(formatTimestampForInput($(this).data('startdate')));
                                                                        $('#editEndDate').val(formatTimestampForInput($(this).data('enddate')));
                                                                        $('#editIsActive').val($(this).data('isactive').toString());
                                                                    });
                                                                });
            </script>
    </body>
</html>