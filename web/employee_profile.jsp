<%-- employee_profile.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .profile-card {
        padding: 30px;
        margin-top: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        border-radius: 8px;
    }
    .profile-card p {
        font-size: 1.2rem;
    }
    .profile-info-divider {
        border-left: 1px solid #ddd;
        padding-left: 30px;
        height: 100%;
    }
    .profile-card h5 {
        color: #007bff;
        font-size: 1.5rem;
    }
    .profile-card h2 {
        font-size: 2rem;
    }
</style>

<div class="container-fluid">
    <h2 class="mb-4"><i class="fas fa-user-circle"></i> Hồ sơ cá nhân</h2>
    
    <div class="profile-card bg-white rounded">
        
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${requestScope.employeeProfile != null}">
            <c:set var="emp" value="${requestScope.employeeProfile}"/>

            <div class="row">
                <div class="col-md-6">
                    <h5>Thông tin cơ bản</h5>
                    <hr>
                    <p><strong>ID Nhân viên:</strong> ${emp.employee_id}</p>
                    <p><strong>Tên:</strong> ${emp.name}</p>
                    <p><strong>Email:</strong> ${emp.email}</p>
                    <p><strong>Điện thoại:</strong> ${emp.phone}</p>
                    <p><strong>Địa chỉ:</strong> ${emp.address}</p>
                </div>
                
                <div class="col-md-6 profile-info-divider">
                    <h5>Thông tin công việc</h5>
                    <hr>
                    <p><strong>Vị trí:</strong> ${emp.position}</p>
                    <p><strong>Mức lương:</strong> <fmt:formatNumber value="${emp.salary}" pattern="#,##0"/> VNĐ</p>
                    <p><strong>Ngày thuê:</strong> <fmt:formatDate value="${emp.hireDate}" pattern="yyyy-MM-dd"/></p>
                    <p><strong>Trạng thái:</strong> 
                        <span class="badge 
                            <c:choose>
                                <c:when test="${emp.status == 'Active'}">bg-success</c:when>
                                <c:when test="${emp.status == 'On Leave'}">bg-warning text-dark</c:when>
                                <c:otherwise>bg-danger</c:otherwise>
                            </c:choose>
                        ">${emp.status}</span>
                    </p>
                </div>
            </div>

            <div class="mt-4 text-end">
                <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                    <i class="fas fa-pencil-alt"></i> Chỉnh sửa thông tin
                </button>
            </div>

        </c:if>
        <c:if test="${requestScope.employeeProfile == null}">
            <div class="alert alert-warning">Không tìm thấy hồ sơ cá nhân của bạn.</div>
        </c:if>
    </div>

    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="profileForm" method="post" action="${pageContext.request.contextPath}/update-profile"> 
                    <div class="modal-header">
                        <h5 class="modal-title" id="editProfileModalLabel">Chỉnh sửa Hồ sơ Cá nhân</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="employee_id" value="${emp.employee_id}">
                        <input type="hidden" name="user_id" value="${emp.user_id}">

                        <div class="mb-3">
                            <label for="inputName" class="form-label">Tên:</label>
                            <input type="text" class="form-control" id="inputName" name="name" value="${emp.name}" required>
                        </div>
                        <div class="mb-3">
                            <label for="inputEmail" class="form-label">Email:</label>
                            <input type="email" class="form-control" id="inputEmail" name="email" value="${emp.email}" required>
                        </div>
                        <div class="mb-3">
                            <label for="inputPhone" class="form-label">Số điện thoại:</label>
                            <input type="text" class="form-control" id="inputPhone" name="phone" value="${emp.phone}">
                        </div>
                        <div class="mb-3">
                            <label for="inputAddress" class="form-label">Địa chỉ:</label>
                            <textarea class="form-control" id="inputAddress" name="address">${emp.address}</textarea>
                        </div>

                        <hr>
                        <h6 class="text-primary fw-bold">Thay đổi mật khẩu (Để trống nếu không đổi)</h6>
                        <div class="mb-3">
                            <label for="inputPassword" class="form-label">Mật khẩu mới:</label>
                            <input type="password" class="form-control" id="inputPassword" name="password" placeholder="Nhập mật khẩu mới">
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu:</label>
                            <input type="password" class="form-control" id="confirmPassword" placeholder="Nhập lại mật khẩu mới">
                            <small id="passwordHelp" class="text-danger d-none">Mật khẩu xác nhận không khớp!</small>
                        </div>

                        <div class="alert alert-info mt-3">
                            Thông tin vị trí, lương và trạng thái do Quản trị viên quản lý.
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('profileForm').addEventListener('submit', function(e) {
        const password = document.getElementById('inputPassword').value;
        const confirm = document.getElementById('confirmPassword').value;
        const helpText = document.getElementById('passwordHelp');

        if (password !== "" && password !== confirm) {
            e.preventDefault();
            helpText.classList.remove('d-none');
            alert("Mật khẩu xác nhận không khớp!");
        } else {
            helpText.classList.add('d-none');
        }
    });
</script>