<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt Bàn - EmTyShop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }
            .card {
                border-radius: 10px;
            }
            .container-booking {
                margin-top: 50px;
                margin-bottom: 50px;
            }
        </style>
    </head>
    <body>
        <%-- Bao gồm menu_horizontal.jsp --%>
        <jsp:include page="menu_horizontal.jsp"/>

        <div class="container container-booking">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <div class="card shadow-lg p-4">
                        <h2 class="text-center text-primary mb-4">Form Đặt Bàn</h2>

                        <%-- Hiển thị thông báo từ Servlet, sau đó xóa khỏi session --%>
                        <c:if test="${not empty sessionScope.bookingMessage}">
                            <div class="alert alert-${sessionScope.bookingAlertType} alert-dismissible fade show" role="alert">
                                ${sessionScope.bookingMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <%-- Xóa thông báo khỏi session sau khi hiển thị --%>
                            <c:remove var="bookingMessage" scope="session"/>
                            <c:remove var="bookingAlertType" scope="session"/>
                        </c:if>

                        <c:if test="${sessionScope.user == null}">
                            <div class="alert alert-info text-center" role="alert">
                                Vui lòng <a href="/WebApplication1/login">đăng nhập</a> để đặt bàn.
                            </div>
                        </c:if>

                        <form action="/WebApplication1/bookTable" method="post">
                            <div class="mb-3">
                                <label for="bookingDate" class="form-label">Ngày đặt bàn:</label>
                                <input type="date" class="form-control" id="bookingDate" name="bookingDate" required
                                       min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                            </div>
                            <div class="mb-3">
                                <label for="bookingTime" class="form-label">Giờ đặt bàn:</label>
                                <input type="time" class="form-control" id="bookingTime" name="bookingTime" required>
                            </div>
                            <div class="mb-3">
                                <label for="numberOfPeople" class="form-label">Số lượng người:</label>
                                <input type="number" class="form-control" id="numberOfPeople" name="numberOfPeople" min="1" max="50" required>
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg"
                                        <c:if test="${sessionScope.user == null}">disabled</c:if>>
                                    Xác Nhận Đặt Bàn
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <%-- Có thể thêm các script riêng của booking.jsp nếu có --%>
    </body>
</html>