<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt Hàng Thành Công</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; text-align: center; }
        .success-box { max-width: 500px; margin: 50px auto; padding: 30px; border: 2px solid #28a745; border-radius: 10px; background-color: #f0fff0; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        h2 { color: #28a745; font-size: 2em; }
        .order-id { font-size: 1.2em; margin-top: 15px; }
        .back-button { margin-top: 20px; background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; display: inline-block; transition: background-color 0.3s; }
        .back-button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<div class="success-box">
    <h2>✅ ĐẶT HÀNG THÀNH CÔNG!</h2>
    <p>${paymentStatus}</p>
    
    <c:if test="${not empty orderId}">
        <p class="order-id">Mã đơn hàng của bạn là: <strong>${orderId}</strong></p>
    </c:if>
    
    <p>Cảm ơn bạn đã tin tưởng và mua sắm tại cửa hàng chúng tôi.</p>
    
    <a href="${pageContext.request.contextPath}/home" class="back-button">Quay lại trang chủ</a>
</div>
</body>
</html>