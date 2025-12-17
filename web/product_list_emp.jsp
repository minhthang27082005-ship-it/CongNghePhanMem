<%-- product_list_emp.jsp (CÂN CHỈNH CỘT) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* CSS nội tuyến để điều chỉnh kích thước chữ và thêm đường viền cột */
    
    /* 1. Kích thước chữ 1.3 lần */
    .product-table-section table {
        font-size: 1.3rem;
    }
    
    /* 2. Thêm đường phân cách dọc */
    .product-table-section table, 
    .product-table-section th, 
    .product-table-section td {
        border: 1px solid #dee2e6;
    }

    .product-table-section th {
        padding: 15px;
        font-size: 1.05rem; 
        background-color: #343a40;
        color: white;
        text-align: center; /* CĂN GIỮA TIÊU ĐỀ */
    }
    
    .product-table-section td {
        padding: 12px 10px;
        vertical-align: middle;
    }
    .product-table-section .table-striped > tbody > tr:nth-of-type(odd) > * {
        background-color: #f7f7f7 !important;
    }
    .product-table-section .badge {
        font-size: 1rem; 
        padding: 0.5em 0.8em;
    }
    .product-table-section img {
        width: 60px !important;
        height: 60px !important; 
        object-fit: cover;
    }
    /* Căn chỉnh nội dung cột */
    .col-id { width: 5%; text-align: center; }
    .col-stock { width: 10%; text-align: center; }
    .col-img { width: 10%; text-align: center; }
</style>

<div class="container-fluid mt-4">
    <h3 class="mb-4"><i class="fas fa-boxes"></i> Danh Sách Tồn Kho</h3>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">${sessionScope.successMessage}</div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="product-table-section table-responsive">
        <table class="table table-striped"> 
            <thead>
                <tr>
                    <th class="col-id">ID</th>
                    <th style="width: 25%;">Tên Sản Phẩm</th>
                    <th style="width: 10%;">Giá</th>
                    <th class="col-stock">Tồn Kho</th>
                    <th style="width: 40%;">Mô tả</th>
                    <th class="col-img">Hình ảnh</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${requestScope.listProduct}">
                    <tr>
                        <td class="col-id">${p.product_id}</td>
                        <td>${p.name}</td>
                        <td><fmt:formatNumber value="${p.price}" pattern="#,##0"/> VNĐ</td>
                        <td class="col-stock">
                            <span class="badge ${p.stock < 10 ? 'bg-warning' : 'bg-success'}">
                                ${p.stock}
                            </span>
                        </td>
                        <td>${p.description}</td>
                        <td class="col-img"><img src="${p.image}" alt="${p.name}"></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>