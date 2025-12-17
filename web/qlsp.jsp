<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Sản Phẩm</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <style>
            body { display: flex; min-height: 100vh; background-color: #f8f9fa; }
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
            .main-content-wrapper { margin-left: 250px; width: calc(100% - 250px); padding: 20px; }
            .content-section { background-color: #ffffff; border-radius: 8px; padding: 20px; box-shadow: 0 0 15px rgba(0,0,0,0.1); margin-bottom: 20px; }
            .product-table-section table p { width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
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
            <div id="productManagementSection" class="container-fluid content-section">
                <h2 class="mb-3"><i class="bi bi-box-seam-fill"></i> Quản Lý Sản Phẩm</h2>

                <%-- PHẦN HIỂN THỊ THÔNG BÁO --%>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill"></i> ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="bi bi-plus-circle"></i> Thêm Sản Phẩm Mới
                </button>
                
                <p>Tổng số sản phẩm: ${requestScope.listP.size()}</p>
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <th scope="col">STT</th>
                                <th scope="col">product_id</th>
                                <th scope="col">name</th>
                                <th scope="col">description</th>
                                <th scope="col">price</th>
                                <th scope="col">stock</th>
                                <th scope="col">category_id</th>
                                <th scope="col">image</th>
                                <th scope="col">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.listP}">
                                    <c:forEach var="product" items="${requestScope.listP}" varStatus="status">
                                        <tr>
                                            <th scope="row">${status.index + 1}</th>
                                            <td>${product.getProduct_id()}</td>
                                            <td><p style="width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${product.getName()}</p></td>
                                            <td><p style="width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${product.getDescription()}</p></td>
                                            <td>${product.getPrice()}</td>
                                            <td>${product.getStock()}</td>
                                            <td>${product.getCategory_id()}</td>
                                            <td><p style="width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${product.getImage()}</p></td>
                                            <td>
                                                <button class="btn btn-danger btnDelete" data-id="${product.getProduct_id()}" data-name="${product.getName()}" data-bs-toggle="modal" data-bs-target="#deleteConfirmModal">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>&nbsp;&nbsp;&nbsp;&nbsp;
                                                <button class="btn btn-warning btnEdit"
                                                        data-id="${product.getProduct_id()}"
                                                        data-name="${product.getName()}"
                                                        data-description="${product.getDescription()}"
                                                        data-price="${product.getPrice()}"
                                                        data-stock="${product.getStock()}"
                                                        data-image="${product.getImage()}"
                                                        data-categoryid="${product.getCategory_id()}"
                                                        data-bs-toggle="modal" data-bs-target="#editModal">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="9" class="text-center">Không tìm thấy sản phẩm nào.</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
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
                    <div class="modal-header">
                        <h5 class="modal-title">Cập nhật Sản Phẩm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="updateproduct" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="productId" class="editProductId"/>
                            <div class="mb-3">
                                <label class="form-label">Tên:</label>
                                <input type="text" class="form-control" name="name" id="editProductName">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giá:</label>
                                <input type="number" step="0.01" class="form-control" name="price" id="editProductPrice">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Số lượng tồn:</label>
                                <input type="number" class="form-control" name="stock" id="editProductStock">
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
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm Sản Phẩm Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
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