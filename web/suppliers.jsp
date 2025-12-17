<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách Nhà cung cấp</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

        <style>
            /* CSS THỐNG NHẤT */
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
                padding-top: 0;
                overflow-y: auto;
                z-index: 1030;
            }
            .menu .text-white {
                background-color: #212529;
            }
            .list-group-item {
                background-color: #343a40;
                color: #adb5bd;
                border: none;
                padding: 12px 20px;
                display: block;
                text-decoration: none;
                transition: background-color 0.3s;
            }
            .list-group-item:hover,
            .list-group-item.active {
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
            /* HẾT CSS THỐNG NHẤT */

            /* CSS RIÊNG CỦA QUẢN LÝ NHÀ CUNG CẤP */
            .main-content-wrapper {
                margin-left: 250px;
                width: calc(100% - 250px);
                padding: 20px;
            }
            .navbar-custom {
                background-color: #ffffff;
                border-bottom: 1px solid #dee2e6;
                padding: 15px 20px;
                margin-bottom: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,.05);
            }
            .supplier-table-container {
                background-color: #ffffff;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .id-input-group.edit-mode #supplier_id {
                background-color: #e9ecef;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body>
        <div class="menu" id="menu">
            <div class="text-white text-center py-3 mb-3" style="background-color: #212529;">
                <h4>Admin Panel</h4>
            </div>

            <div class="list-group">
                <a href="${pageContext.request.contextPath}/admin" class="list-group-item list-group-item-action active">
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
                <a href="${pageContext.request.contextPath}/voucherslist" class="list-group-item list-group-item-action">
                    <i class="bi bi-gift-fill"></i> Quản lý Mã Giảm Giá
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="list-group-item list-group-item-action">
                    <i class="bi bi-box-arrow-right"></i> Đăng Xuất
                </a>
            </div>
        </div>


        <div class="main-content-wrapper" id="mainContentWrapper">


            <%-- Thông báo thành công/lỗi --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <%-- Nội dung chính: Danh sách nhà cung cấp --%>
            <div class="supplier-table-container">
                <h2 class="mb-3"><i class="bi bi-truck"></i> Quản Lý Nhà Cung Cấp</h2>
                <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#supplierModal" id="btnAddSupplier">
                    <i class="bi bi-plus-circle"></i> Thêm Nhà cung cấp mới
                </button>
                <p>Tổng số nhà cung cấp: ${requestScope.suppliers.size()}</p>
                <div class="table-responsive">

                    <table class="table table-striped table-hover" id="supplierTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên Nhà cung cấp</th>
                                <th>Người liên hệ</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Thành phố</th>
                                <th class="text-center">Hành động</th>
                            </tr>
                        </thead>

                        <tbody>
                            <%-- START: DỮ LIỆU ĐỘNG SỬ DỤNG JSTL --%>
                            <c:choose>
                                <c:when test="${not empty requestScope.suppliers}">
                                    <c:forEach var="sup" items="${requestScope.suppliers}">
                                        <tr>
                                            <td>${sup.supplier_id}</td>
                                            <td>${sup.supplier_name}</td>
                                            <td>${sup.contact_name}</td> 
                                            <td>${sup.email}</td>
                                            <td>${sup.phone_number}</td>
                                            <td>${sup.city}</td>

                                            <td class="text-center action-buttons">
                                                <button type="button" class="btn btn-warning btn-sm btn-edit-supplier"
                                                        data-bs-toggle="modal" data-bs-target="#supplierModal"
                                                        data-id="${sup.supplier_id}"
                                                        data-name="${sup.supplier_name}"
                                                        data-contact="${sup.contact_name}"
                                                        data-phone="${sup.phone_number}"
                                                        data-email="${sup.email}"
                                                        data-address="${sup.address}"
                                                        data-city="${sup.city}"
                                                        data-country="${sup.country}"
                                                        title="Sửa">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>
                                                <button type="button" class="btn btn-danger btn-sm btn-delete-supplier"
                                                        data-bs-toggle="modal" data-bs-target="#deleteConfirmModal"
                                                        data-id="${sup.supplier_id}" title="Xóa">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="no-data">Không có nhà cung cấp nào trong hệ thống.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            <%-- END: DỮ LIỆU ĐỘNG SỬ DỤNG JSTL --%>
                        </tbody>
                    </table>
                </div>

            </div>

            <%-- Supplier Modal (Form for Add/Edit) --%>
            <div class="modal fade" id="supplierModal" tabindex="-1" aria-labelledby="supplierModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form id="supplierForm" method="post"> 
                            <div class="modal-header">
                                <h5 class="modal-title" id="supplierModalLabel">Thêm Nhà cung cấp mới</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">

                                <div class="mb-3 id-input-group">
                                    <label for="supplier_id" class="form-label">ID Nhà cung cấp:</label>
                                    <input type="text" class="form-control" id="supplier_id" name="supplier_id" required>
                                    <small class="form-text text-danger" id="idHelpText" style="display: none;">ID này đã tồn tại. Vui lòng chọn ID khác.</small>
                                </div>
                                <div class="mb-3">
                                    <label for="supplier_name" class="form-label">Tên Nhà cung cấp:</label>
                                    <input type="text" class="form-control" id="supplier_name" name="supplier_name" required>
                                </div>
                                <div class="mb-3">
                                    <label for="contact_name" class="form-label">Người liên hệ:</label>
                                    <input type="text" class="form-control" id="contact_name" name="contact_name">
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email:</label>
                                    <input type="email" class="form-control" id="email" name="email">
                                </div>
                                <div class="mb-3">
                                    <label for="phone_number" class="form-label">Số điện thoại:</label>
                                    <input type="text" class="form-control" id="phone_number" name="phone_number">
                                </div>
                                <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ:</label>
                                    <input type="text" class="form-control" id="address" name="address">
                                </div>
                                <div class="mb-3">
                                    <label for="city" class="form-label">Thành phố:</label>
                                    <input type="text" class="form-control" id="city" name="city">
                                </div>
                                <div class="mb-3">
                                    <label for="country" class="form-label">Quốc gia:</label>
                                    <input type="text" class="form-control" id="country" name="country">
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary" id="saveSupplierBtn">Lưu</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <%-- Delete Confirmation Modal --%>
            <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteConfirmModalLabel">Xác nhận xóa</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            Bạn có chắc chắn muốn xóa nhà cung cấp này?
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <form id="deleteSupplierForm" method="post" action="${pageContext.request.contextPath}/delete-supplier" style="display:inline;">
                                <input type="hidden" name="id" id="deleteSupplierId">
                                <button type="submit" class="btn btn-danger">Xóa</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


            <script>
                $(document).ready(function () {
                    // Toggle Menu
                    $('#btnToggle').click(function () {
                        $('.menu').toggleClass('closed');
                        $('#mainContentWrapper').toggleClass('menu-closed');
                    });

                    // Active menu item on load (Cập nhật đường dẫn cho Supplier)
                    var currentPath = window.location.pathname;
                    $('.menu .list-group-item').each(function () {
                        var linkHref = $(this).attr('href');
                        if (linkHref && currentPath.includes('${pageContext.request.contextPath}/supplierlist')) {
                            if (linkHref.endsWith('/supplierlist')) {
                                $('.menu .list-group-item').removeClass('active');
                                $(this).addClass('active');
                            }
                        }
                    });

                    // Reset form when modal is hidden
                    $('#supplierModal').on('hidden.bs.modal', function () {
                        $('#supplierForm')[0].reset();
                        $('#supplier_id').val(''); // Clear ID field
                        $('#supplierModalLabel').text('Thêm Nhà cung cấp mới');

                        $('#supplierForm').attr('action', '${pageContext.request.contextPath}/add-supplier'); // Set action to add
                        $('#supplier_id').prop('readonly', false).removeClass('form-control-plaintext').addClass('form-control');
                        $('.id-input-group').removeClass('edit-mode');
                        $('#idHelpText').hide();
                    });

                    // Handle "Add New Supplier" button click
                    $('#btnAddSupplier').click(function () {
                        $('#supplierForm')[0].reset();
                        $('#supplier_id').val('');
                        $('#supplierModalLabel').text('Thêm Nhà cung cấp mới');

                        $('#supplierForm').attr('action', '${pageContext.request.contextPath}/add-supplier'); // Set action to add
                        $('#supplier_id').prop('readonly', false).removeClass('form-control-plaintext').addClass('form-control');
                        $('.id-input-group').removeClass('edit-mode');
                        $('#idHelpText').hide();
                    });

                    // Handle "Edit Supplier" button click (Sử dụng data attributes)
                    $('.btn-edit-supplier').click(function () {
                        // Lấy dữ liệu từ data attributes của nút Sửa
                        var supId = $(this).data('id');
                        var supName = $(this).data('name');
                        var contact = $(this).data('contact');
                        var phone = $(this).data('phone');
                        var email = $(this).data('email');
                        var address = $(this).data('address');
                        var city = $(this).data('city');
                        var country = $(this).data('country');

                        $('#supplierModalLabel').text('Sửa thông tin Nhà cung cấp');
                        $('#supplierForm').attr('action', '${pageContext.request.contextPath}/update-supplier');

                        // Thiết lập các trường trong form
                        $('#supplier_id').val(supId).prop('readonly', true).removeClass('form-control').addClass('form-control-plaintext');
                        $('.id-input-group').addClass('edit-mode');

                        $('#supplier_name').val(supName);
                        $('#contact_name').val(contact);
                        $('#phone_number').val(phone);
                        $('#email').val(email);
                        $('#address').val(address);
                        $('#city').val(city);
                        $('#country').val(country);
                    });

                    // Handle "Delete Supplier" button click (open confirmation modal)
                    $('.btn-delete-supplier').click(function () {
                        var supIdToDelete = $(this).data('id');
                        $('#deleteSupplierId').val(supIdToDelete); // Set hidden input value in delete form
                    });

                    // (Tùy chọn) Thêm kiểm tra trùng ID khi thêm mới (Client-side check)
                    $('#supplier_id').on('input', function () {
                        var inputId = $(this).val();
                        var exists = false;

                        if ($('#supplierForm').attr('action').endsWith('/add-supplier')) {
                            // Lặp qua dữ liệu động hiện tại trong bảng
                            $('#supplierTable tbody tr').each(function () {
                                // Lấy ID từ cột đầu tiên của hàng 
                                var tableId = $(this).find('td:first').text();

                                if (inputId === tableId) {
                                    exists = true;
                                    return false;
                                }
                            });
                        }

                        if (exists) {
                            $('#idHelpText').show();
                            $('#saveSupplierBtn').prop('disabled', true);
                        } else {
                            $('#idHelpText').hide();
                            $('#saveSupplierBtn').prop('disabled', false);
                        }
                    });
                });
            </script>
    </body>
</html>