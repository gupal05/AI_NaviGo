<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AI NaviGo</title>
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
    </style>
</head>
<body>
<!-- 헤더와 네비를 감싸는 공통 컨테이너 -->
<header id="top-header">
    <%-- <jsp:include page="/WEB-INF/views/layout/header.jsp" /> --%>
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<!-- Hero 섹션 -->
<section class="hero">
    <h1>이제 여행도 AI와 함께 하세요! <span>AI NaviGo</span></h1>
    <p>당신의 관심사와 예산에 맞춰 일정표를 만들어주는 개인 맞춤형 여행 플래너</p>
    <a href="#" class="btn-cta">무료 서비스 이용</a>
</section>

<!-- 일정 섹션 -->
<section class="sample-itinerary">
    <div class="itinerary-info">
        <h2>4 Days trip in Melbourne, Victoria, Australia</h2>
        <p>1000 - 2500 USD | Sightseeing | Shopping | Food Exploration</p>
        <p>
            Melbourne is a vibrant city located in the state of Victoria, Australia.
            It is known for its cosmopolitan atmosphere, thriving arts scene, and
            diverse culinary offerings...
        </p>
    </div>
    <div class="itinerary-map">
        지도/이미지 자리
    </div>
</section>

<!-- Sign In 모달 -->
<div class="modal fade" id="signInModal" tabindex="-1" aria-labelledby="signInModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="signInModalLabel">Sign In</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="/auth/sign_in" method="post">
                    <div class="mb-3">
                        <label for="id" class="form-label">ID</label>
                        <input type="text" class="form-control" id="id" name="id" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Login</button>
                </form>

                <!-- 구분선 -->
                <div class="text-center custom-divider">or</div>

                <!-- 구글 로그인 버튼 -->
                <button class="btn google-btn w-100">
                    <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Logo" style="width: 20px; margin-right: 10px;"> Google Login
                </button>

                <!-- 구분선 -->
                <hr class="sign-up-divider">

                <!-- 회원가입 버튼 -->
                <button class="btn btn-secondary w-100" onclick="location.href='#'">Sign Up</button>
            </div>
        </div>
    </div>
</div>

<!-- 푸터 포함 -->
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
