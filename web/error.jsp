<%--
    Document   : error
    Created on : May 22, 2025
    Author     : YourName
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lỗi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8d7da; /* Màu nền đỏ nhạt cho trang lỗi */
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                text-align: center;
            }
            .error-container {
                background-color: #ffffff;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                max-width: 500px;
                width: 100%;
            }
            .error-container h1 {
                color: #dc3545; /* Màu đỏ */
                margin-bottom: 20px;
            }
            .error-container p {
                color: #6c757d;
                margin-bottom: 30px;
            }
            .btn-back {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                transition: background-color 0.3s ease;
            }
            .btn-back:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <h1>Oops! Có lỗi xảy ra</h1>
            <p>
                <c:choose>
                    <c:when test="${not empty requestScope.errorMessage}">
                        ${requestScope.errorMessage}
                    </c:when>
                    <c:otherwise>
                        Đã có vấn đề xảy ra trong quá trình xử lý yêu cầu của bạn. Vui lòng thử lại.
                    </c:otherwise>
                </c:choose>
            </p>
            <a href="/WebApplication1/home" class="btn btn-back">Quay lại Trang Chủ</a>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>