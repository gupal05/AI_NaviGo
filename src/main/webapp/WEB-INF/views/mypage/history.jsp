<%--
  Created by IntelliJ IDEA.
  User: yebin
  Date: 25. 2. 7.
  Time: 오전 11:25
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>여행 일정 - AI NaviGo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        :root {
            --primary-color: #5468ff;
            --primary-hover: #4152e3;
            --secondary-color: #f6f8ff;
            --text-primary: #2c3256;
            --text-secondary: #6b7280;
            --border-color: #e2e8f0;
            --success-color: #10b981;
            --error-color: #ef4444;
            --white: #ffffff;
            --box-shadow: 0 10px 30px rgba(84, 104, 255, 0.08);
            --font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f8faff 0%, #f0f4ff 100%);
            font-family: var(--font-family);
            color: var(--text-primary);
            min-height: 100vh;
        }
        /* 메인 컨테이너 스타일 */
        .mypage-container {
            display: flex;
            gap: 30px;
            padding: 40px 20px;
            margin-top: 20px;
            min-height: calc(100vh - 80px);
            animation: fadeIn 0.5s ease-out;
        }
        /* 본문 영역 스타일 */
        .content {
            flex: 1;
            background: var(--white);
            border-radius: 16px;
            padding: 40px;
            box-shadow: var(--box-shadow);
            position: relative;
            overflow: hidden;
        }
        .page-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: calc(100vh - 180px);
            padding: 40px 20px;
        }

        .resetpw-container {
            width: 100%;
            max-width: 1200px;
            background: var(--white);
            border-radius: 16px;
            box-shadow: var(--box-shadow);
            position: relative;
            overflow: hidden;
            padding: 48px 40px;
            margin: 0 auto;
            animation: fadeIn 0.5s ease-out;
        }

        .resetpw-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, var(--primary-color), #9f7aea);
        }

        .resetpw-header {
            text-align: center;
            margin-bottom: 36px;
        }

        .resetpw-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 8px;
            background: linear-gradient(to right, var(--primary-color), #9f7aea);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -0.5px;
        }

        .alert {
            padding: 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 15px;
            animation: slideDown 0.3s ease-out;
        }

        .alert-danger {
            background-color: #fef2f2;
            color: var(--error-color);
            border: 1px solid #fee2e2;
        }

        #signup-btn-group {
            text-align: center;
            margin-top: 24px;
        }

        .form-group {
            margin-bottom: 24px;
            position: relative;
        }

        .form-label {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            height: 54px;
            background-color: #f9fafb;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 0 20px;
            font-size: 15px;
            color: var(--text-primary);
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: var(--white);
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(84, 104, 255, 0.1);
            outline: none;
        }

        .error-message {
            color: var(--error-color);
            font-size: 13px;
            margin-top: 6px;
            display: none;
            animation: fadeIn 0.2s ease-out;
        }

        .valid-input {
            border-color: var(--success-color) !important;
        }

        .btn {
            height: 54px;
            font-weight: 600;
            font-size: 15px;
            border-radius: 12px;
            letter-spacing: 0.3px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            padding: 0 24px;
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            color: var(--primary-color);
            border: none;
        }

        .btn-secondary:hover {
            background-color: #ebeffe;
            color: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary-color), #6977ff);
            border: none;
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, #4a59e5, #5c6aff);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 576px) {
            .resetpw-container {
                padding: 32px 24px;
                border-radius: 12px;
            }

            .resetpw-title {
                font-size: 22px;
            }

            .form-control, .btn {
                height: 50px;
            }
        }
        /* planList.css */
        .plans-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 40px;
            background-color: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(84, 104, 255, 0.08);
        }

        .plans-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
            list-style: none;
            padding: 0;
        }

        .plan-card {
            position: relative;
            background: linear-gradient(145deg, #ffffff, #f6f8ff);
            border-radius: 16px;
            border: 1px solid rgba(226, 232, 240, 0.6);
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .plan-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(to right, var(--primary-color), #9f7aea);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .plan-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(84, 104, 255, 0.15);
        }

        .plan-card:hover::before {
            opacity: 1;
        }

        .plan-card__content {
            padding: 28px;
        }

        .plan-card__destination {
            color: #2c3256;
            font-size: 22px;
            font-weight: 700;
            margin: 0 0 16px 0;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .plan-card__date {
            color: #6b7280;
            font-size: 15px;
            font-weight: 500;
            margin-bottom: 20px;
        }

        .plan-card__date-range {
            display: inline-block;
        }

        .plan-card__actions {
            display: flex;
            justify-content: flex-start;
        }

        .plan-card__view-link {
            display: inline-flex;
            align-items: center;
            padding: 10px 20px;
            background: linear-gradient(to right, var(--primary-color), #6977ff);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(84, 104, 255, 0.2);
        }

        .plan-card__view-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(84, 104, 255, 0.3);
            color: white;
        }

        @media (max-width: 768px) {
            .plans-container {
                padding: 20px;
                margin: 20px;
            }

            .plan-card__content {
                padding: 20px;
            }

            .plan-card__destination {
                font-size: 20px;
            }
        }
    </style>
    <title>나의 여행</title>
</head>

<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<!-- 마이페이지 메인 컨테이너 -->
<div class="mypage-container container">
    <!-- 사이드바 메뉴 -->
    <jsp:include page="/WEB-INF/views/mypage/sidebar.jsp" />
    <%--본문--%>
    <div class="resetpw-container">
        <div class="resetpw-header">
            <h1 class="resetpw-title">${member.memberId}님의 여행 일정 🗺</h1>
        </div>
        <!-- 여행일정 확인 -->
<%--        <form action="${pageContext.request.contextPath}/mypage/history" method="post">--%>
<%--            <p>Saved Plans: ${savedPlans}</p>--%>
        <div class="plans-container">
            <c:choose>
                <c:when test="${not empty savedPlans}">
                    <ul class="plans-list">
                        <c:forEach var="plan" items="${savedPlans}">
                            <li class="plan-card">
                                <div class="plan-card__content">
                                    <h3 class="plan-card__destination">${plan.destination}</h3>
                                    <div class="plan-card__date">
                                        <span class="plan-card__date-range">${plan.startDate} ~ ${plan.endDate}</span>
                                    </div>
                                    <div class="plan-card__actions">
                                        <a href="/foreign/plan/${plan.planId}" class="plan-card__view-link">상세 일정</a>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>저장된 여행 일정이 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        </form>
    </div>
</div>
<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />
<%--footer--%>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<script>
    // savedPlans는 객체일 경우 JSON 문자열로 변환 후 전달
    var savedPlans = ${not empty savedPlans ? savedPlans : '[]'}; // null일 경우 빈 배열로 대체
    var memberId = '${memberId}'; // memberId는 문자열이므로 따옴표로 감싸서 전달

    // 콘솔에 savedPlans와 memberId 출력
    console.log(savedPlans);
    console.log(memberId);
</script>

<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
