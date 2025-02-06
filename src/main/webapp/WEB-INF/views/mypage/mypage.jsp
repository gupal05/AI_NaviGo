<%--
  Created by IntelliJ IDEA.
  User: yebin
  Date: 25. 2. 5.
  Time: 오전 10:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html  lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>my page</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        .google-btn {
            background-color: white;
            border: 2px solid #ccc;
            color: black;
        }
        .google-btn:hover {
            border-color: #888;
        }
        .custom-divider {
            margin: 8px 0;
        }
        .sign-up-divider {
            margin: 24px 0;
        }
        .mypage-container {
            display: flex;
            flex-wrap: nowrap; /* 줄바꿈 방지 */
            align-items: stretch; /* 높이를 맞춰주기 */
        }
        .mypage-container .content {
            width: calc(100% - 220px);
            min-height: 1200px;
            background-color: #e9ecef
        }
        .mypage-container > .content, .mypage-container > .sidebar {
            padding: 20px;
            border: 1px solid #ccc
        }
        .mypage-container .content p, .mypage-container .sidebar p {
            font-size: 18px;
            line-height: 1.8
        }
        .mypage-container .sidebar {
            position: sticky;
            top: 20px;
            width: 200px;
            height: 100vh; /* 전체 높이 고정 */
            margin-left: 20px; /* 왼쪽에 위치 */
            background-color: #ccc;
        }
        .mypage-container .content {
            flex-grow: 1; /* 나머지 영역을 차지하도록 설정 */
            min-height: 1200px;
            background-color: #e9ecef;
            padding: 30px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>

<!-- 헤더 포함 -->
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>
<!-- 본문 영역 -->
<div class="mypage-container">
    <h2>나의 정보</h2>

    <!-- 사이드바 메뉴 -->
    <div class="sidebar">
        <ul class="nav flex-column">
            <li class="nav-item">
                <span class="nav-link active">개인정보 수정</span>
            </li>
            <li class="nav-item">
                <span class="nav-link">나의 히스토리</span>
            </li>
        </ul>
    </div>

    <!-- 본문 -->
    <div class="content">
        <p>Content area</p>
    </div>


</div>

<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />

<!-- 푸터 포함 -->
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>
