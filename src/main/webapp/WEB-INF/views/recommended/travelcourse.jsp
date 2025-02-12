<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container mt-5 text-center">
    <h2 class="fw-bold">여행코스 추천</h2>
    <p class="text-muted">아래 버튼을 눌러 원하는 코스를 선택하세요.</p>
    <!-- 필터 버튼 영역 -->
    <div>
        <a href="${pageContext.request.contextPath}/main/recommended?tc=C01120001" class="btn btn-outline-primary filter-btn">가족코스</a>
        <a href="${pageContext.request.contextPath}/main/recommended?tc=C01130001" class="btn btn-outline-primary filter-btn">나홀로코스</a>
        <a href="${pageContext.request.contextPath}/main/recommended?tc=C01140001" class="btn btn-outline-primary filter-btn">힐링코스</a>
        <a href="${pageContext.request.contextPath}/main/recommended?tc=C01150001" class="btn btn-outline-primary filter-btn">도보코스</a>
        <a href="${pageContext.request.contextPath}/main/recommended?tc=C01160001" class="btn btn-outline-primary filter-btn">캠핑코스</a>
        <a href="${pageContext.request.contextPath}/main/recommended?tc=C01170001" class="btn btn-outline-primary filter-btn">맛코스</a>
    </div>
</div>
<br>
<div class="container">
    <!-- courseSection 영역: AJAX로 업데이트할 부분 -->
    <div id="courseSection">
        <jsp:include page="/WEB-INF/views/recommended/courseSection.jsp" />
    </div>
</div>

<!-- AJAX를 통한 동적 콘텐츠 업데이트 스크립트 -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const filterButtons = document.querySelectorAll(".filter-btn");
        filterButtons.forEach(function(btn) {
            btn.addEventListener("click", function(event) {
                event.preventDefault();  // 기본 페이지 이동 막기
                const url = this.getAttribute("href");
                fetch(url, {
                    headers: { "X-Requested-With": "XMLHttpRequest" }
                })
                    .then(response => response.text())
                    .then(html => {
                        // 서버에서 반환된 여행코스 목록만 courseSection 영역에 삽입
                        document.getElementById("courseSection").innerHTML = html;
                    })
                    .catch(error => console.error("AJAX 요청 오류:", error));
            });
        });
    });
</script>

<style>
    .card-img-custom {
        width: 100%;
        height: 212px;
        object-fit: cover;
    }
    .card-link {
        color: inherit;
        text-decoration: none;
    }
    .filter-btn {
        margin: 5px;
    }
</style>
