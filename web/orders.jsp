<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách Đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

        <style>
            /* --- CSS Styles (Thống nhất) --- */
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
                background-color: #343a40; /* Cùng màu nền */
                padding: 15px 20px;
                font-size: 1.5rem;
                font-weight: 700;
                border-bottom: 1px solid #495057;
            }
            .menu.closed {
                transform: translateX(-100%);
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

            /* CSS RIÊNG CỦA QUẢN LÝ ĐƠN HÀNG */
            .main-content-wrapper {
                margin-left: 250px;
                width: calc(100% - 250px);
                transition: margin-left 0.3s ease, width 0.3s ease;
                padding: 20px;
            }
            .main-content-wrapper.menu-closed {
                margin-left: 0;
                width: 100%;
            }
            .navbar-custom {
                background-color: #ffffff;
                border-bottom: 1px solid #dee2e6;
                padding: 15px 20px;
                margin-bottom: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,.05);
            }
            .order-table-container {
                background-color: #ffffff;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .order-table-container h5 {
                margin-bottom: 15px;
                color: #343a40;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .id-input-group.edit-mode #order_id {
                background-color: #e9ecef;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body>
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
                <a href="${pageContext.request.contextPath}/orderlist" class="list-group-item list-group-item-action active">
                    <i class="bi bi-journal-text"></i> Quản lý Đơn Hàng
                </a>
                <a href="${pageContext.request.contextPath}/supplierlist" class="list-group-item list-group-item-action">
                    <i class="bi bi-truck"></i> Quản lý Nhà Cung Cấp
                </a>
                <a href="${pageContext.request.contextPath}/voucherslist" class="list-group-item list-group-item-action">
                    <i class="bi bi-gift-fill"></i> Quản lý Mã Giảm Giá
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="list-group-item list-group-item-action">
                    <i class="fas fa-sign-out-alt"></i> Đăng Xuất
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

            <%-- Nội dung chính: Danh sách đơn hàng --%>
            <div class="order-table-container">
                <h2 class="mb-3"><i class="bi bi-cart-fill"></i> Quản Lý Đơn Hàng</h2>
                <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#orderModal" id="btnAddOrder">
                    <i class="bi bi-plus-circle"></i> Thêm Đơn hàng mới
                </button>
                <p>Tổng số đơn hàng: ${requestScope.orders.size()}</p>

                <table class="table table-striped table-hover" id="orderTable">
                    <thead>
                        <tr>
                            <th>ID Đơn hàng</th>
                            <th>ID Khách hàng</th>
                            <th>Ngày đặt hàng</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:choose>
                            <c:when test="${not empty requestScope.orders}">
                                <c:forEach var="order" items="${requestScope.orders}">
                                    <tr>
                                        <td>${order.order_id}</td>
                                        <td>${order.user_id}</td>
                                        <td>${order.order_date.toLocalDate()}</td> 
                                        <td>${order.total_amount}</td>
                                        <td>${order.status.dbValue}</td> 
                                        <td class="text-center action-buttons">
                                            <button type="button" class="btn btn-warning btn-sm btn-edit-order"
                                                    data-bs-toggle="modal" data-bs-target="#orderModal"
                                                    data-id="${order.order_id}"
                                                    data-customer-id="${order.user_id}"
                                                    data-order-date="${order.order_date.toLocalDate()}"
                                                    data-total-amount="${order.total_amount}"
                                                    data-status="${order.status.name()}"
                                                    title="Sửa">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm btn-delete-order"
                                                    data-bs-toggle="modal" data-bs-target="#deleteConfirmModal"
                                                    data-id="${order.order_id}" title="Xóa">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="no-data">Không có đơn hàng nào trong hệ thống.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>



        </div>

        <%-- Order Modal (Form for Add/Edit) --%>
        <div class="modal fade" id="orderModal" tabindex="-1" aria-labelledby="orderModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="orderModalLabel">Thêm Đơn hàng mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="orderForm" method="post">
                        <div class="modal-body">

                            <div class="mb-3 id-input-group">
                                <label for="order_id" class="col-form-label">ID Đơn hàng (*):</label>
                                <input type="number" class="form-control" id="order_id" name="order_id" required>
                                <small class="form-text text-danger" id="idHelpText" style="display: none;">ID này đã tồn tại. Vui lòng chọn ID khác.</small>
                            </div>

                            <div class="mb-3">
                                <label for="customer_id" class="col-form-label">ID Khách hàng (*):</label>
                                <input type="number" class="form-control" id="customer_id" name="customer_id" required>
                            </div>

                            <div class="mb-3">
                                <label for="order_date" class="col-form-label">Ngày đặt hàng (*):</label>
                                <input type="date" class="form-control" id="order_date" name="order_date" required>
                            </div>

                            <div class="mb-3">
                                <label for="total_amount" class="col-form-label">Tổng tiền (*):</label>
                                <input type="number" step="0.01" class="form-control" id="total_amount" name="total_amount" required>
                            </div>

                            <div class="mb-3">
                                <label for="status" class="col-form-label">Trạng thái (*):</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="PHE_DUYET">Phê duyệt</option>
                                    <option value="DANG_GIAO">Đang giao</option>
                                    <option value="HOAN_THANH">Hoàn thành</option>
                                    <option value="HUY">Hủy</option>
                                </select>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary" id="saveOrderBtn">Lưu</button>
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
                        Bạn có chắc chắn muốn xóa đơn hàng này?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <form id="deleteOrderForm" method="post" action="${pageContext.request.contextPath}/delete-order" style="display:inline;">
                            <input type="hidden" name="id" id="deleteOrderId">
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

                // Active menu item on load based on current URL
                var currentPath = window.location.pathname;
                $('.menu .list-group-item').each(function () {
                    var linkHref = $(this).attr('href');
                    if (linkHref && currentPath.includes('${pageContext.request.contextPath}/orderlist')) {
                        if (linkHref.endsWith('/orderlist')) {
                            $('.menu .list-group-item').removeClass('active');
                            $(this).addClass('active');
                        }
                    }
                });

                // Reset form when modal is hidden
                $('#orderModal').on('hidden.bs.modal', function () {
                    $('#orderForm')[0].reset();
                    $('#order_id').val('');
                    $('#orderModalLabel').text('Thêm Đơn hàng mới');
                    $('#orderForm').attr('action', '${pageContext.request.contextPath}/add-order');
                    $('#order_id').prop('readonly', false).removeClass('form-control-plaintext').addClass('form-control');
                    $('.id-input-group').removeClass('edit-mode');
                    $('#idHelpText').hide();
                });

                // Handle "Add New Order" button click
                $('#btnAddOrder').click(function () {
                    $('#orderForm')[0].reset();
                    $('#order_id').val('');
                    $('#orderModalLabel').text('Thêm Đơn hàng mới');
                    $('#orderForm').attr('action', '${pageContext.request.contextPath}/add-order');
                    $('#order_id').prop('readonly', false).removeClass('form-control-plaintext').addClass('form-control');
                    $('.id-input-group').removeClass('edit-mode');
                    $('#idHelpText').hide();
                });

                // Handle "Edit Order" button click (Sử dụng data attributes)
                $('.btn-edit-order').click(function () {
                    var orderId = $(this).data('id');
                    var customerId = $(this).data('customer-id');
                    var orderDate = $(this).data('order-date');
                    var totalAmount = $(this).data('total-amount');
                    var status = $(this).data('status');

                    $('#orderModalLabel').text('Sửa thông tin Đơn hàng');
                    $('#orderForm').attr('action', '${pageContext.request.contextPath}/update-order');

                    $('#order_id').val(orderId).prop('readonly', true).removeClass('form-control').addClass('form-control-plaintext');
                    $('.id-input-group').addClass('edit-mode');

                    $('#customer_id').val(customerId);
                    $('#order_date').val(orderDate);
                    $('#total_amount').val(totalAmount);
                    $('#status').val(status);
                });

                // Handle "Delete Order" button click (open confirmation modal)
                $('.btn-delete-order').click(function () {
                    var orderIdToDelete = $(this).data('id');
                    $('#deleteOrderId').val(orderIdToDelete);
                });

                // (Tùy chọn) Thêm kiểm tra trùng ID khi thêm mới (Client-side check)
                $('#order_id').on('input', function () {
                    var inputId = $(this).val();
                    var exists = false;

                    if ($('#orderForm').attr('action').endsWith('/add-order')) {
                        $('#orderTable tbody tr').each(function () {
                            var tableId = $(this).find('td:first').text();
                            if (inputId === tableId) {
                                exists = true;
                                return false;
                            }
                        });
                    }

                    if (exists) {
                        $('#idHelpText').show();
                        $('#saveOrderBtn').prop('disabled', true);
                    } else {
                        $('#idHelpText').hide();
                        $('#saveOrderBtn').prop('disabled', false);
                    }
                });
            });
        </script>
    </body>
</html>