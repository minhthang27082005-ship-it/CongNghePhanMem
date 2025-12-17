<%-- employee_sidebar_menu.jsp (ĐÃ HOÀN THIỆN) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .sidebar {
        height: 100vh;
        width: 250px;
        position: fixed;
        top: 0;
        left: 0;
        background-color: #343a40;
        padding-top: 0; /* KHÔNG CẦN CHỖ TRỐNG CHO MENU NGANG NỮA */
        color: white;
        overflow-y: auto;
    }
    .sidebar a {
        padding: 15px 10px 15px 20px;
        text-decoration: none;
        font-size: 1rem;
        color: #adb5bd;
        display: block;
        transition: 0.3s;
    }
    .sidebar a:hover {
        color: white;
        background-color: #495057;
    }
    .sidebar .active {
        color: white;
        background-color: #007bff;
    }
    .content-area {
        margin-left: 250px;
        padding: 20px;
    }
    /* Điều chỉnh header Sidebar để trông giống Admin hơn */
    .sidebar-header {
        padding: 15px 20px;
        font-size: 1.2rem;
        font-weight: bold;
        color: #ffffff;
        background-color: #212529; /* Màu tối hơn */
    }
    /* Style cho các header QL Kho, QL Đơn hàng */
    .menu-section-header {
        padding: 15px 20px 5px 20px;
        font-size: 0.8rem;
        font-weight: bold;
        color: #adb5bd; /* Màu chữ nhạt */
        text-transform: uppercase;
    }
</style>

<div class="sidebar">
    <div class="sidebar-header">
        <i class="fas fa-user-tie"></i> Chức Năng Nhân Viên
    </div>

    <c:set var="currentPath" value="${requestScope['jakarta.servlet.forward.servlet_path']}"/>

    <%-- ⭐ HỒ SƠ CÁ NHÂN (Trang Tổng Quan Mặc Định) --%>
    <a href="${pageContext.request.contextPath}/employee/profile" class="${currentPath eq '/employee/profile' || currentPath eq '/update-profile' || currentPath eq '/change-password' ? 'active' : ''}">
        <i class="fas fa-user-cog"></i> Hồ Sơ Cá Nhân
    </a>
    <a href="${pageContext.request.contextPath}/employee/customers" class="${currentPath eq '/employee/customers' || currentPath eq '/employee/customer-history' ? 'active' : ''}">
        <i class="fas fa-user-friends"></i> Quản lý Khách hàng
    </a>

    <a href="${pageContext.request.contextPath}/employee/products" class="${currentPath eq '/employee/products' ? 'active' : ''}">
        <i class="fas fa-list"></i> Kiểm Tra Tồn Kho
    </a>

    <a href="${pageContext.request.contextPath}/nhapkho" class="${currentPath eq '/nhapkho' ? 'active' : ''}">
        <i class="fas fa-box-open"></i> Nhập Kho
    </a>
    <a href="${pageContext.request.contextPath}/xuatkho" class="${currentPath eq '/xuatkho' ? 'active' : ''}">
        <i class="fas fa-truck-loading"></i> Xuất Kho
    </a>
    <a href="${pageContext.request.contextPath}/lichsukho" class="${currentPath eq '/lichsukho' ? 'active' : ''}">
        <i class="fas fa-history"></i> Lịch Sử Kho
    </a>

    <a href="${pageContext.request.contextPath}/employee/orders" class="${currentPath eq '/employee/orders' ? 'active' : ''}">
        <i class="fas fa-clipboard-list"></i> Danh Sách Đơn Hàng
    </a>
    <a href="${pageContext.request.contextPath}/payment_process" class="${currentPath eq '/payment_process' ? 'active' : ''}">
        <i class="fas fa-money-check-alt"></i> Xác Nhận & Hóa Đơn
    </a>

    <%-- ⭐ ĐÃ XÓA LIÊN KẾT 'Trang chủ' gây lỗi 404 hoặc không cần thiết --%>

    <a href="${pageContext.request.contextPath}/logout">
        <i class="fas fa-sign-out-alt"></i> Đăng Xuất
    </a>
</div>