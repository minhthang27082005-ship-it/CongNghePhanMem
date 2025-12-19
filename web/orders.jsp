<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

            .main-content-wrapper {
                margin-left: 250px;
                width: calc(100% - 250px);
                transition: margin-left 0.3s ease, width 0.3s ease;
                padding: 20px;
            }
            .order-table-container {
                background-color: #ffffff;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .action-buttons .btn {
                margin: 0 2px;
            }
        </style>
    </head>
    <body>
        <div class="menu">
            <div class="text-white text-center py-3 mb-3">
                <h4>Admin Panel</h4>
            </div>
            <div class="list-group">
                <a href="${pageContext.request.contextPath}/admin" class="list-group-item list-group-item-action">
                    <i class="bi bi-speedometer2"></i> Quản lý tổng quan hệ thống
                </a>
                <a href="${pageContext.request.contextPath}/admin/profile" class="list-group-item list-group-item-action">
                    <i class="bi bi-person-fill"></i> Quản lý hồ sơ cá nhân
                </a>
                <a href="${pageContext.request.contextPath}/listproducts" class="list-group-item list-group-item-action">
                    <i class="bi bi-box-seam-fill"></i> Quản lý Kho
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
                <a href="${pageContext.request.contextPath}/voucherslist" class="list-group-item list-group-item-action ">
                    <i class="bi bi-gift-fill"></i> Quản lý Mã Giảm Giá
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="list-group-item list-group-item-action">
                    <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                </a>
            </div>
        </div>

        <div class="main-content-wrapper" id="mainContentWrapper">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <div class="order-table-container">
                <h2 class="mb-3"><i class="bi bi-cart-fill"></i> Quản Lý Đơn Hàng</h2>
                <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#orderModal" id="btnAddOrder">
                    <i class="bi bi-plus-circle"></i> Thêm Đơn hàng mới
                </button>
                <p>Tổng số đơn hàng: ${requestScope.orders.size()}</p>

                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle" id="orderTable">
                        <thead class="table-dark">
                            <tr>
                                <th>ID Đơn hàng</th>
                                <th>ID Khách hàng</th>
                                <th>Địa chỉ giao hàng</th>
                                <th>Số điện thoại</th>
                                <th>Mã giảm giá</th> <th>Ngày đặt hàng</th>
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
                                            <td><c:out value="${order.shipping_address}"/></td>
                                            <td><c:out value="${order.phone_number}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty order.voucherId}">
                                                        <span class="badge bg-dark">ID: ${order.voucherId}</span>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">Không áp dụng</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${order.order_date.toLocalDate()}</td> 
                                            <td class="fw-bold">
                                                <fmt:formatNumber value="${order.total_amount}" pattern="#,##0"/> VNĐ
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.status.name() == 'PHE_DUYET'}">
                                                        <span class="badge bg-warning text-dark">${order.status.dbValue}</span>
                                                    </c:when>
                                                    <c:when test="${order.status.name() == 'DANG_GIAO'}">
                                                        <span class="badge bg-primary">${order.status.dbValue}</span>
                                                    </c:when>
                                                    <c:when test="${order.status.name() == 'HOAN_THANH'}">
                                                        <span class="badge bg-success">${order.status.dbValue}</span>
                                                    </c:when>
                                                    <c:when test="${order.status.name() == 'HUY'}">
                                                        <span class="badge bg-danger">${order.status.dbValue}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${order.status.dbValue}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td> 
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
                                        <td colspan="9" class="text-center">Không có đơn hàng nào trong hệ thống.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%-- Modal Thêm/Sửa --%>
        <div class="modal fade" id="orderModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="orderModalLabel">Thông tin Đơn hàng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="orderForm" method="post">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="order_id" class="col-form-label">ID Đơn hàng (*):</label>
                                <input type="number" class="form-control" id="order_id" name="order_id" required>
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

        <%-- Modal Xóa --%>
        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Xác nhận xóa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">Bạn có chắc chắn muốn xóa đơn hàng này?</div>
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
                $('.btn-edit-order').click(function () {
                    var orderId = $(this).data('id');
                    var customerId = $(this).data('customer-id');
                    var orderDate = $(this).data('order-date');
                    var totalAmount = $(this).data('total-amount');
                    var status = $(this).data('status');

                    $('#orderModalLabel').text('Sửa thông tin Đơn hàng');
                    $('#orderForm').attr('action', '${pageContext.request.contextPath}/update-order');
                    $('#order_id').val(orderId).prop('readonly', true).addClass('form-control-plaintext');
                    $('#customer_id').val(customerId);
                    $('#order_date').val(orderDate);
                    $('#total_amount').val(totalAmount);
                    $('#status').val(status);
                });

                $('#btnAddOrder').click(function () {
                    $('#orderForm')[0].reset();
                    $('#orderModalLabel').text('Thêm Đơn hàng mới');
                    $('#orderForm').attr('action', '${pageContext.request.contextPath}/add-order');
                    $('#order_id').prop('readonly', false).removeClass('form-control-plaintext');
                });

                $('.btn-delete-order').click(function () {
                    $('#deleteOrderId').val($(this).data('id'));
                });
            });
        </script>
    </body>
</html>