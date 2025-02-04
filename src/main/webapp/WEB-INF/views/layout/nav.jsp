<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- nav.jsp -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color: #e8f1fa;">
    <div class="container-fluid">
        <!-- 로고 대신 텍스트/링크, 혹은 header.jsp에서 이미 로고를 넣었다면 생략 -->
<%--        <a class="navbar-brand" href="${pageContext.request.contextPath}/">AI NaviGo</a>--%>
        <jsp:include page="/WEB-INF/views/layout/header.jsp" />
        <!-- 토글 버튼 (작은 화면에서 햄버거 메뉴) -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation"
        >
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- 실제 메뉴 -->
        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="#">추천 여행지</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">AI여행지 생성</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">마이 페이지</a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-primary ms-2" href="#">Sign In</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
