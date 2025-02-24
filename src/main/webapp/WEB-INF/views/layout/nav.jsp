<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- nav.jsp -->
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container-fluid">
        <!-- 로고 포함 -->
        <div class="navbar-brand">
            <jsp:include page="/WEB-INF/views/layout/header.jsp" />
        </div>

        <!-- 토글 버튼 (햄버거 메뉴) -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- 실제 메뉴 -->
        <div class="collapse navbar-collapse justify-content-center" id="mainNavbar">
            <!-- 중앙 메뉴 아이템 -->
            <ul class="navbar-nav mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="/imageRecommendation">
                        <i class="bi bi-image"></i> 이미지
                    </a>
                </li>
                <!-- 추천 여행지: 드롭다운 -->
                <li class="nav-item dropdown" id="recommendDropdown">
                    <a class="nav-link dropdown-toggle" id="recommendDropdownLink" role="button">
                        <i class="bi bi-compass"></i> 추천 여행지
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="recommendDropdownLink">
                        <li><a class="dropdown-item" href="/main/recommended?menu=ai">AI 여행지 추천</a></li>
                        <li><a class="dropdown-item" href="/main/recommended?menu=festival">문화 축제</a></li>
                        <li><a class="dropdown-item" href="/main/recommended?menu=popular">인기 여행지</a></li>
                        <li><a class="dropdown-item" href="/main/recommended?menu=course">여행코스 추천</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/tourplan">
                        <i class="bi bi-map"></i> 국내 여행지 생성
                    </a>
                <!-- 해외 여행지 생성 -->
                <li class="nav-item">
                    <a class="nav-link" href="#" id="foreignCreate">
                        <i class="bi bi-globe"></i> 해외 여행지 생성
                    </a>
                </li>
            </ul>

            <!-- 오른쪽 인증 메뉴 -->
            <div class="auth-menu">
                <%-- session에 memberInfo가 있으면 마이 페이지와 Logout 버튼 표시 --%>
                <% if (session.getAttribute("memberInfo") != null) { %>
                <a class="nav-link d-inline-block" href="/mypage">
                    <i class="bi bi-person"></i> 마이 페이지
                </a>
                <form action="/logout" method="get" class="d-inline-block">
                    <button class="btn logout-btn" type="submit">Logout</button>
                </form>
                <% } else { %>
                <%-- session에 memberInfo가 없으면 Sign In 버튼만 표시 --%>
                <form action="/auth/login" method="get" class="d-inline-block" id="loginForm">
                    <button class="btn login-btn" type="submit">Sign In</button>
                </form>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- 로그인 상태 확인을 위한 hidden input -->
<input type="hidden" id="isLoggedIn" value="<%= session.getAttribute("memberInfo") != null %>" />

<!-- Bootstrap Icons CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

<style>
    /* 기본 스타일 설정 */
    body {
        font-family: 'Poppins', 'Noto Sans KR', sans-serif;
    }

    /* 네비게이션 바 기본 스타일 */
    .navbar {
        background: linear-gradient(135deg, #4a9fff, #a777e3);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        padding: 0.8rem 1rem;
        border-radius: 0 0 16px 16px;
        position: relative;
    }

    .container-fluid {
        display: flex;
        justify-content: center;
    }

    /* 네비게이션 링크 스타일 */
    .nav-link {
        color: rgba(255, 255, 255, 0.9) !important;
        font-weight: 500;
        margin: 0 8px;
        padding: 0.6rem 1.2rem;
        border-radius: 8px;
        transition: all 0.3s ease;
        letter-spacing: 0.2px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .nav-link:hover {
        color: #ffffff !important;
        background-color: rgba(255, 255, 255, 0.15);
        transform: translateY(-2px);
    }

    /* 아이콘 스타일 */
    .nav-link i {
        font-size: 1.1rem;
    }

    /* 활성화된 링크 */
    .nav-link.active {
        color: #ffffff !important;
        background-color: rgba(255, 255, 255, 0.2);
        font-weight: 600;
    }

    /* 드롭다운 메뉴 스타일링 */
    .dropdown-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        min-width: 12rem;
        border: none;
        border-radius: 12px;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
        background-color: rgba(255, 255, 255, 0.95);
        padding: 0.8rem 0.5rem;
        z-index: 1000;
        margin-top: 8px;
    }

    .dropdown-item {
        color: #6e6e6e;
        padding: 0.7rem 1.2rem;
        border-radius: 8px;
        transition: all 0.2s ease;
        font-weight: 500;
        margin: 2px 0;
    }

    .dropdown-item:hover {
        color: #574b90;
        font-weight: 600;
        background-color: rgba(110, 142, 251, 0.1);
        transform: translateX(3px);
    }

    /* 인증 메뉴 */
    .auth-menu {
        display: flex;
        align-items: center;
        position: absolute;
        right: 15px;
    }

    /* 버튼 스타일링 */
    .login-btn, .logout-btn {
        background-color: rgba(255, 255, 255, 0.15);
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.3);
        padding: 0.5rem 1.5rem;
        border-radius: 50px;
        transition: all 0.3s ease;
        font-weight: 600;
        letter-spacing: 0.5px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .login-btn:hover, .logout-btn:hover {
        background-color: rgba(255, 255, 255, 0.25);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        transform: translateY(-2px);
        color: white;
    }

    .logout-btn {
        background-color: rgba(231, 76, 60, 0.15);
        border: 1px solid rgba(231, 76, 60, 0.3);
    }

    .logout-btn:hover {
        background-color: rgba(231, 76, 60, 0.25);
    }

    /* 반응형 설정 */
    @media (max-width: 992px) {
        .navbar-nav {
            padding: 1rem 0;
            margin: 0 auto;
        }

        .nav-link {
            padding: 0.8rem 1rem;
            margin: 0.3rem 0;
            justify-content: flex-start;
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%; /* 부모 요소 바로 아래에 위치 */
            left: 0;
            min-width: 12rem;
            border: none;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
            background-color: rgba(255, 255, 255, 0.95);
            padding: 0.8rem 0.5rem;
            z-index: 1000;
            margin-top: 0; /* 기존 margin-top 제거 */
        }

        .dropdown-item {
            color: rgba(255, 255, 255, 0.8);
        }

        .dropdown-item:hover {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.1);
        }

        .auth-menu {
            position: static;
            margin-top: 1rem;
            justify-content: center;
            width: 100%;
        }
    }
</style>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const foreignCreateBtn = document.getElementById("foreignCreate");
        const isLoggedIn = document.getElementById("isLoggedIn").value === "true";
        const loginForm = document.getElementById("loginForm");

        foreignCreateBtn.addEventListener("click", function(event) {
            event.preventDefault(); // 기본 링크 동작 막기

            if (isLoggedIn) {
                // 로그인 상태면 원래 링크로 이동
                window.location.href = "/foreign/create";
            } else {
                // 로그인 안 되어 있으면 경고창 띄운 후 로그인 폼 제출
                alert("로그인 후 이용할 수 있습니다.");
                loginForm.submit();
            }
        });
    });

    $(document).ready(function() {
        // 추천 여행지 메뉴 호버 효과
        $(document).ready(function() {
            let hideTimer; // slideUp 지연용 타이머 변수

            $("#recommendDropdown").hover(
                function () {
                    clearTimeout(hideTimer); // 마우스가 들어오면 이전 타이머 클리어
                    $(this).find(".dropdown-menu").stop(true, true).slideDown(200);
                    $(this).find(".nav-link").addClass("active");
                },
                function () {
                    // 마우스가 벗어났을 때 100ms 후 slideUp 실행
                    hideTimer = setTimeout(() => {
                        $(this).find(".dropdown-menu").stop(true, true).slideUp(200);
                        if (!$(this).find(".nav-link").hasClass("current")) {
                            $(this).find(".nav-link").removeClass("active");
                        }
                    }, 100);
                }
            );
        });

        // 현재 활성화된 메뉴 표시
        const currentPath = window.location.pathname;
        $(".nav-link").each(function() {
            const href = $(this).attr("href");
            if (href && currentPath.startsWith(href)) {
                $(this).addClass("active current");
            }
        });
    });
</script>
