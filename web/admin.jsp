<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard | Tổng quan</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                left: 0;
                bottom: 0;
                background: #343a40;
                color: #f8f9fa;
                z-index: 1000;
                padding-top: 0;
                overflow-y: auto;
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

            /* CSS RIÊNG CỦA DASHBOARD */
            #contentSection {
                margin-left: 250px;
                padding: 20px;
                flex-grow: 1;
            }
            .top-bar {
                background-color: #ffffff;
                padding: 15px 20px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-radius: 8px;
            }
            .top-bar .btn-logout {
                color: #dc3545;
                text-decoration: none;
                font-weight: 600;
                transition: color 0.3s;
            }
            .dashboard-section {
                background-color: #ffffff;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
            }
            .info-card {
                background-color: #e9ecef;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s;
                height: 100%;
            }
            .info-card h4 {
                margin-top: 15px;
                font-size: 1.2rem;
                font-weight: 600;
            }
            .info-card p {
                font-size: 1.5rem; /* Giảm từ 2rem xuống 1.5rem để chứa được số dài */
                font-weight: 700;
                color: #343a40;
                word-break: break-all; /* Tự động xuống dòng nếu số vẫn quá dài */
            }
            .info-card .icon {
                font-size: 3rem;
                color: #007bff;
            }
            .info-card.orders .icon {
                color: #28a745;
            }
            .info-card.users .icon {
                color: #dc3545;
            }
            .info-card.products .icon {
                color: #6c757d;
            }
            .info-card.revenue .icon {
                color: #007bff;
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
                <a href="${pageContext.request.contextPath}/orderlist" class="list-group-item list-group-item-action">
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
        </div>

        <div id="contentSection">
            <div class="top-bar">
                <h4>Xin chào, <c:out value="${loggedInAdmin.name}" default="Admin"/>!</h4>
                <a href="${pageContext.request.contextPath}/home" class="btn-logout"><i class="bi bi-box-arrow-right"></i> Trang chủ</a>
            </div>

            <div id="dashboardSection" class="dashboard-section">
                <h5><i class="bi bi-speedometer2"></i> Tổng quan hệ thống</h5>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        ${errorMessage}
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="info-card bg-light text-dark">
                            <i class="bi bi-person-circle icon text-primary"></i>
                            <h4>Thông tin Quản trị viên</h4>
                            <hr class="w-75 mx-auto">
                            <c:if test="${not empty loggedInAdmin}">
                                <div class="text-center">
                                    <p class="mb-2 fs-5"><strong>Tên tài khoản:</strong> <c:out value="${loggedInAdmin.email}"/></p>
                                    <p class="mb-2 fs-5"><strong>Họ và tên:</strong> <c:out value="${loggedInAdmin.name}"/></p>
                                    <p class="mb-2 fs-5"><strong>Email:</strong> <c:out value="${loggedInAdmin.email}"/></p>

                                </div>
                            </c:if>
                            <c:if test="${empty loggedInAdmin}">
                                <p class="text-muted">Không có thông tin quản trị viên.</p>
                            </c:if>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="info-card orders">
                            <i class="bi bi-cart-check-fill icon"></i>
                            <h4>Tổng số Đơn hàng</h4>
                            <p>
                                <c:out value="${totalOrders}" default="0"/>
                            </p>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="info-card users">
                            <i class="bi bi-person-badge-fill icon" style="color: #ffc107;"></i>
                            <h4>Tổng số Nhân viên</h4>
                            <p>
                                <c:out value="${totalEmployees}" default="0"/>
                            </p>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="info-card products">
                            <i class="bi bi-box-seam-fill icon"></i>
                            <h4>Tổng số Sản phẩm</h4> 
                            <p>
                                <c:out value="${totalProducts}" default="0"/>
                            </p>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="info-card revenue">
                            <i class="bi bi-currency-dollar icon"></i>
                            <h4>Tổng Doanh thu (Hoàn thành)</h4>
                            <p>
                                <fmt:formatNumber value="${totalRevenue}" pattern="#,###" var="formattedRevenue"/>
                                <c:out value="${formattedRevenue}" default="0"/> VNĐ
                            </p>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="info-card users">
                            <i class="bi bi-people-fill icon"></i>
                            <h4>Tổng số Khách hàng</h4> 
                            <p>
                                <c:out value="${totalCustomers}" default="0"/>
                            </p> 
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-6 mb-4">
                        <div class="dashboard-section">
                            <h5>Doanh thu theo tháng (12 tháng gần nhất)</h5>
                            <div style="height: 350px; position: relative;">
                                <canvas id="monthlyRevenueChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6 mb-4">
                        <div class="dashboard-section">
                            <h5>Số lượng sản phẩm theo Danh mục</h5> 
                            <div style="height: 350px; position: relative;">
                                <canvas id="categoryChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6Z+rpa4q5i/2fR4E2K7lP6W1A6t04rR7fT5+7S2i5F5x7s2t+3e0g5u3o5m5y0m5n7o7g7l7p7o7r7s7u7v7w7x7y7z7" crossorigin="anonymous"></script>

        <script>
            // --- HÀM PHÂN TÍCH DỮ LIỆU TỪ JSTL (QUAN TRỌNG ĐỂ BIỂU ĐỒ HOẠT ĐỘNG) ---
            function parseJSTLList(jstlListString) {
                if (!jstlListString || jstlListString.trim() === "" || jstlListString === "[]") {
                    return [];
                }
                const cleanString = jstlListString.replace(/[\[\]]/g, '').trim();
                if (cleanString === "")
                    return []; // Kiểm tra chuỗi rỗng sau khi xóa ngoặc

                return cleanString.split(',').map(item => {
                    let val = item.trim().replace(/^["']|["']$/g, '');
                    // Kiểm tra val có thực sự là số không trước khi parseFloat
                    return (val !== "" && !isNaN(val)) ? parseFloat(val) : val;
                }).filter(item => item !== ""); // Loại bỏ các phần tử rỗng
            }

            // --- CHUYỂN DỮ LIỆU ĐỘNG TỪ JSP SANG JAVASCRIPT ---

            var parsedMonthlyLabels = parseJSTLList('<c:out value="${monthlyLabels}" escapeXml="false"/>');
            var parsedMonthlyData = parseJSTLList('<c:out value="${monthlyData}" escapeXml="false"/>');

            var parsedCategoryLabels = parseJSTLList('<c:out value="${categoryLabels}" escapeXml="false"/>');
            var parsedCategoryData = parseJSTLList('<c:out value="${categoryData}" escapeXml="false"/>');

            // --- DỮ LIỆU DỰ PHÒNG (FALLBACK) ---
            const fallbackMonthlyLabels = ['Thg 1', 'Thg 2', 'Thg 3', 'Thg 4', 'Thg 5', 'Thg 6', 'Thg 7', 'Thg 8'];
            const fallbackMonthlyData = [50000000, 60000000, 45000000, 75000000, 80000000, 65000000, 70000000, 90000000];
            const fallbackCategoryLabels = ['Áo Thun', 'Quần Jeans', 'Váy Đầm', 'Phụ kiện', 'Áo Khoác'];
            const fallbackCategoryData = [120, 70, 60, 40, 30];

            const backgroundColors = [
                'rgba(255, 99, 132, 0.7)', 'rgba(54, 162, 235, 0.7)',
                'rgba(255, 206, 86, 0.7)', 'rgba(75, 192, 192, 0.7)',
                'rgba(153, 102, 255, 0.7)', 'rgba(255, 159, 64, 0.7)',
                'rgba(199, 199, 199, 0.7)', 'rgba(83, 102, 255, 0.7)'
            ];
            const borderColors = [
                'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)', 'rgba(255, 159, 64, 1)',
                'rgba(199, 199, 199, 1)', 'rgba(83, 102, 255, 1)'
            ];

            document.addEventListener('DOMContentLoaded', function () {

                // 1. BIỂU ĐỒ DOANH THU THEO THÁNG
                var monthlyRevenueCtx = document.getElementById('monthlyRevenueChart').getContext('2d');
                new Chart(monthlyRevenueCtx, {
                    type: 'bar',
                    data: {
                        labels: parsedMonthlyLabels.length > 0 ? parsedMonthlyLabels : fallbackMonthlyLabels,
                        datasets: [{
                                label: 'Doanh thu (VNĐ)',
                                data: parsedMonthlyData.length > 0 ? parsedMonthlyData : fallbackMonthlyData,
                                backgroundColor: 'rgba(0, 123, 255, 0.7)',
                                borderColor: 'rgba(0, 123, 255, 1)',
                                borderWidth: 1
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        layout: {
                            padding: {
                                left: 25, // Tăng khoảng trống bên trái để nhãn "Tỷ VNĐ" không bị mất
                                right: 25
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function (value) {
                                        // Logic rút gọn số liệu để nhãn ngắn gọn hơn [cite: 174-177]
                                        if (value >= 1e9)
                                            return (value / 1e9).toFixed(1) + ' Tỷ';
                                        if (value >= 1e6)
                                            return (value / 1e6).toFixed(1) + ' Tr';
                                        if (value >= 1e3)
                                            return (value / 1e3).toFixed(0) + ' K';
                                        return value;
                                    }
                                }
                            },
                            x: {
                                display: false, // Thêm dòng này để ẩn hoàn toàn trục X và nhãn DEC/2025 [cite: 185, 186]
                                ticks: {
                                    maxRotation: 45,
                                    minRotation: 45
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND', maximumFractionDigits: 0}).format(context.parsed.y);
                                    }
                                }
                            }
                        }
                    }
                });

                // 2. BIỂU ĐỒ SỐ LƯỢNG SẢN PHẨM THEO DANH MỤC
                var categoryProductCtx = document.getElementById('categoryChart').getContext('2d');
                new Chart(categoryProductCtx, {
                    type: 'pie', // Đã đổi thành 'pie' cho đúng mục đích
                    data: {
                        labels: parsedCategoryLabels.length > 0 ? parsedCategoryLabels : fallbackCategoryLabels,
                        datasets: [{
                                data: parsedCategoryData.length > 0 ? parsedCategoryData : fallbackCategoryData,
                                backgroundColor: backgroundColors,
                                borderColor: borderColors,
                                borderWidth: 1
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'top',
                            },
                            tooltip: {
                                callbacks: {
                                    label: function (tooltipItem) {
                                        return tooltipItem.label + ': ' + tooltipItem.raw + ' sản phẩm';
                                    }
                                }
                            }
                        }
                    }
                });
            });
        </script>
    </body>
</html>