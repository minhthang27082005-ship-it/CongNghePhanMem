// employee_layout.jsp

<%-- employee_layout.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <%-- Kèm theo styles và cấu trúc của sidebar --%>
    <jsp:include page="employee_sidebar_menu.jsp" /> 
    
    <style>
        /* CSS bổ sung để đảm bảo body và html đủ chiều cao */
        html, body {
            height: 100%;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>

    <%-- ⭐ ĐÃ XÓA: <jsp:include page="menu_horizontal.jsp" /> --%>

    <%-- Phần nội dung động (được đẩy sang phải) --%>
    <div class="content-area">
        <jsp:include page="${contentPage}" />
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>