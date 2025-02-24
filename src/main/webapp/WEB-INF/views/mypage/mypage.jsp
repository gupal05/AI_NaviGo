<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Page</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        :root {
            --primary-color: #5468ff;
            --primary-hover: #4152e3;
            --secondary-color: #f6f8ff;
            --text-primary: #2c3256;
            --text-secondary: #6b7280;
            --border-color: #e2e8f0;
            --success-color: #10b981;
            --white: #ffffff;
            --box-shadow: 0 10px 30px rgba(84, 104, 255, 0.08);
        }

        /* 전체 페이지 스타일 */
        body {
            background: linear-gradient(135deg, #f8faff 0%, #f0f4ff 100%);
            min-height: 100vh;
            color: var(--text-primary);
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

        /* 사이드바 스타일 */
        .sidebar {
            flex: 0 0 280px;
            background: var(--white);
            border-radius: 16px;
            padding: 25px;
            box-shadow: var(--box-shadow);
            height: fit-content;
            position: relative;
            overflow: hidden;
        }

        .sidebar::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, var(--primary-color), #9f7aea);
        }

        .sidebar .nav-item {
            margin-bottom: 12px;
        }

        .sidebar button.nav-link {
            cursor: pointer;
            font-size: 15px;
            padding: 16px 20px;
            color: var(--text-primary) !important;
            display: block;
            text-decoration: none;
            transition: all 0.3s ease;
            background: var(--secondary-color);
            border: none;
            width: 100%;
            text-align: left;
            border-radius: 12px;
            font-weight: 600;
        }

        .sidebar button.nav-link:hover,
        .sidebar button.nav-link:active {
            background: linear-gradient(to right, var(--primary-color), #6977ff) !important;
            color: white !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25);
        }

        /* form 태그 스타일 초기화 */
        .sidebar form {
            margin: 0;
            padding: 0;
        }

        /* 콘텐츠 영역 스타일 */
        .content {
            flex: 1;
            background: var(--white);
            border-radius: 16px;
            padding: 40px;
            box-shadow: var(--box-shadow);
            position: relative;
            overflow: hidden;
        }

        .content::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, var(--primary-color), #9f7aea);
        }

        /* 활성화된 메뉴 스타일 */
        .sidebar button.nav-link.active {
            background: linear-gradient(to right, var(--primary-color), #6977ff) !important;
            color: white !important;
            box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25);
        }

        /* 애니메이션 */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .mypage-container {
                flex-direction: column;
            }

            .sidebar {
                flex: none;
                width: 100%;
            }

            .content {
                padding: 30px 20px;
            }

            .sidebar button.nav-link:hover {
                transform: none;
            }
        }
    </style>
</head>
<body>

<!-- 헤더 포함 -->
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<!-- 마이페이지 메인 컨테이너 -->
<div class="mypage-container container">
    <!-- 사이드바 메뉴 -->
    <div class="sidebar">
        <ul class="nav flex-column">
            <li class="nav-item">
                <form action="/mypage/history" method="post">
                    <button type="submit" class="nav-link">나의 여행 일정</button>
                </form>
            </li>
            <li class="nav-item">
                <form action="/mypage/changePw" method="post">
                    <button type="submit" class="nav-link">비밀번호 변경</button>
                </form>
            </li>
            <li class="nav-item">
                <form action="/mypage/preference" method="post">
                    <button type="submit" class="nav-link">여행 취향 수정</button>
                </form>
            </li>
        </ul>
    </div>

    <!-- 본문 영역 -->
    <div class="content">
        <c:choose>
            <c:when test="${section == 'history'}">
                <jsp:include page="history.jsp" />
            </c:when>
            <c:when test="${section == 'preference'}">
                <jsp:include page="preference.jsp" />
            </c:when>
            <c:when test="${section == 'changePw'}">
                <jsp:include page="changePw.jsp" />
            </c:when>
            <c:otherwise>
                <p>유효하지 않은 섹션입니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>



<%--<!-- 푸터 포함 -->--%>
<%--<footer id="bottom-footer">--%>
<%--    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />--%>
<%--</footer>--%>

<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />

<!-- JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 현재 URL에 따라 해당하는 메뉴 활성화
        const currentPath = window.location.pathname;
        const buttons = document.querySelectorAll('.sidebar button.nav-link');

        buttons.forEach(button => {
            const form = button.closest('form');
            if (form && form.action.includes(currentPath)) {
                button.classList.add('active');
            }

            // 클릭 시 로딩 표시 추가
            button.addEventListener('click', function() {
                this.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Loading...';
            });
        });
    });
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
