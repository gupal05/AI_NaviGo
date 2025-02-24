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

<%--<!-- AI 기반 여행 일정 생성 서비스 설명 -->--%>
<%--<section class="feature-description">--%>
<%--    <h2>AI 기반 여행 일정 생성 서비스</h2>--%>
<%--    <p>--%>
<%--        이 웹사이트는 사용자가 여행 날짜, 방문하고 싶은 지역, 인원수 등 다양한 정보를 입력하면, <br>--%>
<%--        최신 AI 기술을 활용하여 최적의 여행 일정을 자동으로 생성해 드립니다. <br>--%>
<%--        생성된 일정에는 세부 코스, 추천 관광지, 지도 정보 등이 포함되어 있어 <br>--%>
<%--        사용자가 편리하게 여행 계획을 수립할 수 있습니다.--%>
<%--    </p>--%>
<%--</section>--%>

<!-- 일정 섹션 -->
<section class="sample-itinerary">
    <img src="${pageContext.request.contextPath}/img/main_image1.jpg" alt="로고이미지" />
</section>



<!-- 푸터 포함 -->
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>