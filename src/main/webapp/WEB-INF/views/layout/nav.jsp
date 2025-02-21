<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- nav.jsp -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color: #e8f1fa;">
    <div class="container-fluid">
        <!-- 로고 포함 -->
        <jsp:include page="/WEB-INF/views/layout/header.jsp" />

        <!-- 토글 버튼 (햄버거 메뉴) -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- 실제 메뉴 -->
        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="/imageRecommendation">이미지</a>
                </li>
                <!-- 2) 추천 여행지: 드롭다운으로 수정된 부분 -->
                <!-- hover 시 서브 메뉴("AI맞춤 여행지 추천", "문화축제", "인기여행지")가 슬라이드 다운됨 -->
                <li class="nav-item dropdown" id="recommendDropdown">
                    <a class="nav-link dropdown-toggle" <%-- href="/main/recommended" --%> id="recommendDropdownLink" role="button">
                        추천 여행지
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="recommendDropdownLink">
                        <li><a class="dropdown-item" href="/main/recommended?menu=ai">AI 여행지 추천</a></li>
                        <li><a class="dropdown-item" href="/main/recommended?menu=festival">문화 축제</a></li>
                        <li><a class="dropdown-item" href="/main/recommended?menu=popular">인기 여행지</a></li>
                        <li><a class="dropdown-item" href="/main/recommended?menu=course">여행코스 추천</a></li>
                    </ul>
                </li>
                <li>
<%--                <li class="nav-item">--%>
<%--                    <a class="nav-link" href="main/recommended">추천 여행지</a>--%>
<%--                </li>--%>
<%--                <li class="nav-item">--%>
                    <a class="nav-link" href="/tourplan">국내 여행지 생성</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/foreign/create">해외 여행지 생성</a>
                </li>

                <%-- session에 memberInfo가 있으면 마이 페이지와 Logout 버튼 표시 --%>
                <% if (session.getAttribute("memberInfo") != null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="/mypage">마이 페이지</a>
                </li>
                <li class="nav-item">
                    <form action="/logout" method="get">
                        <button class="btn btn-primary ms-2" data-bs-toggle="modal" type="submit">Logout</button>
                    </form>
                </li>
                <% } else { %>
                <%-- session에 memberInfo가 없으면 Sign In 버튼만 표시 --%>
                <li class="nav-item">
                    <form action="/auth/login" method="get">
                        <button class="btn btn-primary ms-2" type="submit">Sign In</button>
                    </form>
                </li>
                <% } %>
            </ul>
        </div>
    </div>

</nav>

<!-- Dropdown & Login JS -->
<style>
    /*
       Bootstrap에서는 기본적으로 .show 클래스를 붙여/떼서 드롭다운을 제어하지만,
       jQuery로 slideDown/Up을 쓰므로, 초기 display:none으로 처리
    */
    .dropdown-menu {
        display: none;         /* 초기 상태: 숨김 */
        position: absolute;    /* 부모(nav-item) 안에서 절대 위치 */
        top: 100%;             /* nav-item 아래 시작 */
        left: 0;
        min-width: 10rem;      /* 드롭다운 너비 (원하시는 대로 조정) */
        /* 필요하다면 배경색, 테두리, 그림자 등을 추가 */
    }

    /* ▼ 새로 추가한 부분 ▼ */
    .dropdown-item:hover {
        font-weight: bold; /* 마우스 올린 항목을 볼드 처리 */
    }
</style>
<script>
    $(document).ready(function() {
        // 1. 추천 여행지 메뉴 hover -> slideDown & mouseleave -> slideUp
        $("#recommendDropdown").hover(
            function () {
                //마우스가 추천여행지 위로 올라갔을 때
                $(this).find(".dropdown-menu").stop(true, true).slideDown(200);
            },
            function () {
                // 마우스가 영역을 벗어낫을때
                $(this).find(".dropdown-menu").stop(true, true).slideUp(200);
            }
        );


    });
</script>
