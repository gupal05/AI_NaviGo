<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>여행 분야 선택 - AI NaviGo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>

    <style>
        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .card {
            cursor: pointer;
        }
        .card-img-top {
            height: 200px;
            object-fit: cover;
        }
    </style>
</head>
<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="container">
    <h2 class="text-center mb-4">여행 분야 선택</h2>
    <div class="row">
        <!-- 여행 분야 카드 -->
        <div class="col-12 col-md-4 mb-4">
            <div class="card" onclick="selectCategory('nature')">
                <img src="${pageContext.request.contextPath}/images/nature.jpg" class="card-img-top" alt="자연 여행">
                <div class="card-body">
                    <h5 class="card-title">자연 여행</h5>
                    <p class="card-text">자연 속에서의 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-4 mb-4">
            <div class="card" onclick="selectCategory('adventure')">
                <img src="${pageContext.request.contextPath}/images/adventure.jpg" class="card-img-top" alt="모험 여행">
                <div class="card-body">
                    <h5 class="card-title">모험 여행</h5>
                    <p class="card-text">모험적인 활동을 즐기고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-4 mb-4">
            <div class="card" onclick="selectCategory('cultural')">
                <img src="${pageContext.request.contextPath}/images/cultural.jpg" class="card-img-top" alt="문화 여행">
                <div class="card-body">
                    <h5 class="card-title">문화 여행</h5>
                    <p class="card-text">문화와 역사를 탐방하는 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- 다음 버튼 -->
    <div class="d-flex justify-content-between mt-4">
        <button type="button" class="btn btn-secondary">취소</button>
        <button type="button" class="btn btn-primary" id="nextBtn">다음</button>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    function selectCategory(category) {
        // 선택한 여행 분야를 로컬 스토리지에 저장 (다음 단계에서 사용할 수 있도록)
        localStorage.setItem('selectedCategory', category);
    }

    document.getElementById('nextBtn').addEventListener('click', function() {
        var selectedCategory = localStorage.getItem('selectedCategory');

        if (!selectedCategory) {
            alert("여행 분야를 선택해주세요.");
            return;
        }

        // 선택한 여행 분야를 서버로 전송하거나 다음 페이지로 이동
        alert("선택한 여행 분야: " + selectedCategory);
        // 예시로 다음 페이지로 이동하는 코드
        window.location.href = "/nextStepPage"; // 여기를 실제 페이지로 변경
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
