<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Sản Phẩm & Kho</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <style>
            body { display: flex; min-height: 100vh; background-color: #f8f9fa; }
            /* SIDEBAR MENU */
            .menu { 
                width: 250px; position: fixed; top: 0; bottom: 0; left: 0; 
                background: #343a40; color: white; padding-top: 0; overflow-y: auto; z-index: 1030;
            }
            .menu .text-white { background-color: #212529; }
            .list-group-item {
                background-color: #343a40; color: #adb5bd; border: none;
                padding: 12px 20px; display: block; text-decoration: none;
                transition: background-color 0.3s;
            }
            .list-group-item:hover, .list-group-item.active { background-color: #007bff; color: white; }
            .list-group-item.active { border-left: 5px solid white; padding-left: 15px; }
            .list-group-item i { margin-right: 10px; }

            /* CONTENT WRAPPER */
            .main-content-wrapper { margin-left: 250px; width: calc(100% - 250px); padding: 20px; }
            .content-section { background-color: #ffffff; border-radius: 8px; padding: 20px; box-shadow: 0 0 15px rgba(0,0,0,0.1); margin-bottom: 20px; }
            
            /* TABLE STYLES */
            .product-table-section table p { 
                width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-bottom: 0; 
            }
            .badge-nhap { background-color: #dc3545; color: white; } /* Đỏ cho Nhập kho */
            .badge-xuat { background-color: #198754; color: white; } /* Xanh cho Xuất kho */
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
                <a href="${pageContext.request.contextPath}/listproducts" class="list-group-item list-group-item-action active">
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
                    <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                </a>
            </div>
        </div>

        <div class="main-content-wrapper">
            <%-- Hiển thị thông báo thành công/lỗi --%>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle-fill"></i> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:choose>
                <%-- CHẾ ĐỘ XEM LỊCH SỬ KHO --%>
                <c:when test="${isInventoryHistoryView == true}">
                    <div class="content-section">
                        <h3 class="mb-4 text-secondary"><i class="fas fa-history"></i> Lịch Sử Nhập/Xuất Kho Gần Đây</h3>
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-info text-center">
                                    <tr>
                                        <th>ID GD</th>
                                        <th>ID Sản Phẩm</th>
                                        <th>Thời Gian Giao Dịch</th>
                                        <th>Loại</th>
                                        <th>Số Lượng</th>
                                        <th>Người Thực Hiện</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.historyList}">
                                            <c:forEach var="item" items="${requestScope.historyList}">
                                                <tr class="text-center">
                                                    <td>${item.transactionId}</td>
                                                    <td class="fw-bold text-primary">#${item.productId}</td>
                                                    <td>${item.transactionDate}</td>
                                                    <td>
                                                        <span class="badge ${item.type == 'NHAP' ? 'badge-nhap' : 'badge-xuat'}">
                                                            ${item.type == 'NHAP' ? 'NHẬP KHO' : 'XUẤT KHO'}
                                                        </span>
                                                    </td>
                                                    <td class="fw-bold">${item.quantity}</td>
                                                    <td>${item.employeeName}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="6" class="text-center py-3">Chưa có giao dịch kho nào được ghi nhận.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <a href="${pageContext.request.contextPath}/listproducts" class="btn btn-secondary mt-3">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách sản phẩm
                        </a>
                    </div>
                </c:when>

                <%-- CHẾ ĐỘ QUẢN LÝ SẢN PHẨM MẶC ĐỊNH --%>
                <c:otherwise>
                    <div class="content-section">
                        <h2 class="mb-3"><i class="bi bi-box-seam-fill text-primary"></i> Quản Lý Sản Phẩm</h2>
                        <div class="d-flex gap-2 mb-3">
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                                <i class="bi bi-plus-circle"></i> Thêm Sản Phẩm Mới
                            </button>
                            <a href="${pageContext.request.contextPath}/listproducts?mode=history" class="btn btn-info text-white">
                                <i class="fas fa-history"></i> Lịch sử nhập/xuất
                            </a>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered align-middle">
                                <thead class="table-dark text-center">
                                    <tr>
                                        <th>STT</th>
                                        <th>ID</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Giá bán</th>
                                        <th>Tồn kho</th>
                                        <th>Hình ảnh</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.listP}">
                                            <c:forEach var="product" items="${requestScope.listP}" varStatus="status">
                                                <tr>
                                                    <td class="text-center">${status.index + 1}</td>
                                                    <td class="text-center">${product.product_id}</td>
                                                    <td><p style="width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${product.name}</p></td>
                                                    <td class="text-end fw-bold">
                                                        <fmt:formatNumber value="${product.price}" pattern="#,##0"/>
                                                    </td>
                                                    <td class="text-center fw-bold text-primary">${product.stock}</td>
                                                    <td class="text-center">
                                                        <img src="${product.image}" alt="img" style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
                                                    </td>
                                                    <td class="text-center">
                                                        <button class="btn btn-warning btn-sm btnEdit"
                                                                data-id="${product.product_id}" data-name="${product.name}"
                                                                data-description="${product.description}" data-price="${product.price}"
                                                                data-stock="${product.stock}" data-image="${product.image}"
                                                                data-categoryid="${product.category_id}"
                                                                data-bs-toggle="modal" data-bs-target="#editModal">
                                                            <i class="fa-solid fa-pen-to-square"></i>
                                                        </button>
                                                        <button class="btn btn-danger btn-sm btnDelete" 
                                                                data-id="${product.product_id}" data-name="${product.name}" 
                                                                data-bs-toggle="modal" data-bs-target="#deleteConfirmModal">
                                                            <i class="fa-solid fa-trash"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="7" class="text-center">Không tìm thấy sản phẩm nào.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- Modal XÓA --%>
        <div class="modal fade" id="deleteConfirmModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="deletecontroller" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title">Thông Báo</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p class="text-question">Bạn có muốn xóa thật không?</p>
                            <input type="hidden" id="productIdToDelete" name="id">
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-danger">Xóa</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%-- Modal SỬA --%>
        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-warning">
                        <h5 class="modal-title">Cập nhật Sản Phẩm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="updateproduct" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="productId" class="editProductId"/>
                            <div class="mb-3">
                                <label class="form-label">Tên:</label>
                                <input type="text" class="form-control" name="name" id="editProductName" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giá:</label>
                                <input type="number" step="0.01" class="form-control" name="price" id="editProductPrice" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Số lượng tồn:</label>
                                <input type="number" class="form-control" name="stock" id="editProductStock" required>
                                <small class="text-muted">Ghi chú: Thay đổi số lượng sẽ tự động ghi lịch sử kho.</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Link Ảnh:</label>
                                <textarea class="form-control" name="image" id="editProductImage"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả:</label>
                                <textarea class="form-control" name="description" id="editProductDescription"></textarea>
                            </div>
                            <input type="hidden" name="categoryId" class="editCategoryId"/>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%-- Modal THÊM --%>
        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Thêm Sản Phẩm Mới</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="addproduct" method="post">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Product ID:</label>
                                <input type="text" name="productId" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Category ID:</label>
                                <input type="text" name="categoryId" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Name:</label>
                                <input type="text" class="form-control" name="name" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Price:</label>
                                <input type="number" step="0.01" class="form-control" name="price" min="0" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Stock:</label>
                                <input type="number" class="form-control" name="stock" min="0" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Image Link:</label>
                                <input type="url" class="form-control" name="image" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Description:</label>
                                <textarea class="form-control" name="description" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Add</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(document).ready(function () {
                $('.btnDelete').on('click', function () {
                    var dName = $(this).data('name');
                    var productId = $(this).data('id');
                    $('#productIdToDelete').val(productId);
                    $('.text-question').text("Bạn có muốn xóa sản phẩm \"" + dName + "\" không?");
                });

                $('.btnEdit').on('click', function () {
                    $('#editProductName').val($(this).data('name'));
                    $("#editProductPrice").val($(this).data('price'));
                    $("#editProductStock").val($(this).data('stock'));
                    $("#editProductImage").val($(this).data('image'));
                    $("#editProductDescription").val($(this).data('description'));
                    $('.editCategoryId').val($(this).data('categoryid'));
                    $('.editProductId').val($(this).data('id'));
                });
            });
        </script>
    </body>
</html>