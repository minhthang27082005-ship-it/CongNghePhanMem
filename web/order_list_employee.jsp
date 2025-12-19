<%-- order_list_employee.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Đơn Hàng & Thanh Toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* ===== TABLE STYLE ===== */
        .order-list-table { width: 100%; border: 1px solid #dee2e6; border-collapse: collapse; }
        .order-list-table th { 
            background-color: #343a40 !important; color: #fff !important; 
            text-transform: uppercase; padding: 12px; font-size: 0.8rem; 
            text-align: left; vertical-align: middle; 
        }
        .order-list-table td { padding: 12px; vertical-align: middle; border-top: 1px solid #dee2e6; }

        /* ĐỊA CHỈ DÀI */
        .address-col { 
            max-width: 220px; white-space: nowrap; overflow: hidden; 
            text-overflow: ellipsis; display: block; 
        }
        .address-col:hover { 
            white-space: normal; position: absolute; background: #fff; 
            z-index: 100; border: 1px solid #0d6efd; padding: 6px; border-radius: 4px; 
        }

        /* STATUS BADGE */
        .status-badge { 
            font-weight: 500; padding: 0.45em 0.8em; border-radius: 4px; 
            min-width: 90px; display: inline-block; text-align: center; 
        }
        .status-phe-duyet { background-color: #ffc107; color: #000; }
        .status-dang-giao { background-color: #0dcaf0; color: #000; }
        .status-hoan-thanh { background-color: #198754; color: #fff; }
        .status-huy { background-color: #dc3545; color: #fff; }

        /* BUTTON CẬP NHẬT */
        .btn-update-submit { 
            background-color: #0d6efd; color: #fff; border: none; border-radius: 6px; 
            width: 36px; height: 36px; display: inline-flex; align-items: center; 
            justify-content: center; transition: background-color 0.2s ease; 
        }
        .btn-update-submit:hover { background-color: #0a58ca; }
    </style>
</head>
<body>

<div class="container-fluid mt-4">
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="card shadow-sm mb-4 border-primary">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0"><i class="fas fa-cash-register me-2"></i>Tra Cứu & Xử Lý Thanh Toán</h5>
        </div>
        <div class="card-body">
            <form method="GET" action="${pageContext.request.contextPath}/employee/orders" class="row g-3">
                <div class="col-md-5">
                    <label class="form-label fw-bold">Tìm đơn hàng để xuất hóa đơn:</label>
                    <div class="input-group">
                        <span class="input-group-text">ID #</span>
                        <input type="number" class="form-control" name="orderIdSearch" 
                               placeholder="Nhập mã đơn hàng..." value="${param.orderIdSearch}">
                        <button class="btn btn-primary" type="submit">Tìm Kiếm</button>
                    </div>
                </div>
            </form>

            <%-- Chi tiết xử lý (Chỉ hiện khi tìm thấy đơn hàng cụ thể) --%>
            <c:if test="${requestScope.selectedOrder != null}">
                <div class="mt-4 p-3 border rounded bg-light">
                    <c:set var="order" value="${requestScope.selectedOrder}"/>
                    <c:set var="payment" value="${requestScope.payment}"/>
                    
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h6 class="text-primary">Đang chọn: Đơn hàng #${order.order_id}</h6>
                            <p class="mb-1">Khách hàng: <strong>${order.phone_number}</strong></p>
                            <p class="mb-0">Số tiền cần thu: <span class="text-danger fw-bold fs-5"><fmt:formatNumber value="${order.total_amount}" pattern="#,##0"/> VNĐ</span></p>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <c:choose>
                                <c:when test="${payment != null}">
                                    <div class="mb-2">
                                        <span class="badge bg-success p-2"><i class="bi bi-check2-all me-1"></i>ĐÃ THANH TOÁN (${payment.payment_method})</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/payment_process?action=export_pdf&orderId=${order.order_id}" class="btn btn-dark">
                                        <i class="fas fa-file-pdf me-1"></i>Xuất Hóa Đơn PDF (QLĐH_11)
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <form method="POST" action="${pageContext.request.contextPath}/payment_process" class="row g-2 justify-content-end">
                                        <input type="hidden" name="action" value="confirm_payment">
                                        <input type="hidden" name="orderId" value="${order.order_id}">
                                        <input type="hidden" name="requiredAmount" value="${order.total_amount}">
                                        <div class="col-auto">
                                            <input type="number" step="0.01" class="form-control" name="amountReceived" placeholder="Số tiền khách đưa..." required>
                                        </div>
                                        <div class="col-auto">
                                            <button type="submit" class="btn btn-success">Xác Nhận Tiền Mặt</button>
                                        </div>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <div class="bg-white p-4 rounded shadow-sm border">
        <h4 class="mb-4 text-dark"><i class="bi bi-list-stars me-2"></i>DANH SÁCH TẤT CẢ ĐƠN HÀNG</h4>
        <div class="table-responsive">
            <table class="table table-hover align-middle order-list-table">
                <thead>
                    <tr>
                        <th style="width: 5%">ID</th>
                        <th style="width: 25%">Địa chỉ giao hàng</th>
                        <th style="width: 10%">SĐT</th>
                        <th style="width: 10%">Ngày đặt</th>
                        <th style="width: 12%">Tổng tiền</th>
                        <th style="width: 12%">Trạng thái</th>
                        <th style="width: 18%">Cập nhật nhanh</th>
                        <th style="width: 8%">Tác vụ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ord" items="${requestScope.orderList}">
                        <tr>
                            <td class="fw-bold text-center">${ord.order_id}</td>
                            <td><span class="address-col" title="${ord.shipping_address}">${ord.shipping_address}</span></td>
                            <td>${ord.phone_number}</td>
                            <td>${ord.order_date.toLocalDate()}</td>
                            <td class="text-end fw-bold text-danger"><fmt:formatNumber value="${ord.total_amount}" pattern="#,##0"/>đ</td>
                            <td class="text-center">
                                <c:set var="stClass" value=""/>
                                <c:choose>
                                    <c:when test="${ord.status.name() eq 'PHE_DUYET'}"><c:set var="stClass" value="status-phe-duyet"/></c:when>
                                    <c:when test="${ord.status.name() eq 'DANG_GIAO'}"><c:set var="stClass" value="status-dang-giao"/></c:when>
                                    <c:when test="${ord.status.name() eq 'HOAN_THANH'}"><c:set var="stClass" value="status-hoan-thanh"/></c:when>
                                    <c:when test="${ord.status.name() eq 'HUY'}"><c:set var="stClass" value="status-huy"/></c:when>
                                </c:choose>
                                <span class="status-badge ${stClass}">${ord.status.dbValue}</span>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/employee/update-status" 
                                      class="d-flex align-items-center gap-1 justify-content-center">
                                    <input type="hidden" name="orderId" value="${ord.order_id}">
                                    <select name="newStatus" class="form-select form-select-sm" style="width: 115px; font-size: 0.8rem;">
                                        <option value="DANG_GIAO">Đang giao</option>
                                        <option value="HOAN_THANH">Hoàn thành</option>
                                        <option value="HUY">Hủy đơn</option>
                                    </select>
                                    <button type="submit" class="btn-update-submit" title="Lưu trạng thái"><i class="bi bi-send-fill"></i></button>
                                </form>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/employee/orders?orderIdSearch=${ord.order_id}" 
                                   class="btn btn-sm btn-outline-primary" title="Xử lý thanh toán/Hóa đơn">
                                    <i class="fas fa-eye"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>