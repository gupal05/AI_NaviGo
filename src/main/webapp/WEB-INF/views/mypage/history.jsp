<%--
  Created by IntelliJ IDEA.
  User: yebin
  Date: 25. 2. 7.
  Time: 오전 11:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <style>
        .container {
            margin: 10px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2{
            font-weight: bold;
        }
    </style>
    <title>나의 여행</title>
</head>

<body>

<div class="container">
    <h2>나의 여행 일정</h2>
    </br>
    <!-- 여행일정 확인 -->
    <form action="${pageContext.request.contextPath}/mypage/history" method="post">

</div>


<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
