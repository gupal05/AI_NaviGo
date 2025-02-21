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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
    <a href="/tourplan" class="btn-cta">국내 여행지 생성!</a>
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

<!-- 푸터 포함 -->
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<!-- javascript -->


<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
