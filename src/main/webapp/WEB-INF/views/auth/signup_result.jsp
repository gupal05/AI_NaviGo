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
            max-width: 1000px;
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .card {
            cursor: pointer;
            text-align: center;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }
        .card:hover {
            transform: scale(1.05);
        }
        .card-title {
            font-size: 1.2rem;
            font-weight: bold;
        }
        .card-text {
            font-size: 1rem;
            color: #666;
        }
        .selected-card {
            background-color: #f0f0f0; /* 연한 회색으로 설정 */
            color: #333; /* 텍스트 색상도 어두운 색으로 설정 */
        }
    </style>
</head>
<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="container">
    <h2 class="text-center mb-4">선호 여행 취향 선택</h2>
    <div class="row">
        <!-- 여행 분야 카드 -->
        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('산', this)">
                <div class="card-body">
                    <h5 class="card-title">산</h5>
                    <p class="card-text">자연 속에서의 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('해안 절경', this)">
                <div class="card-body">
                    <h5 class="card-title">해안 절경</h5>
                    <p class="card-text">바다와 해안의 아름다움을 경험하고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('온천/욕장/스파', this)">
                <div class="card-body">
                    <h5 class="card-title">온천/욕장/스파</h5>
                    <p class="card-text">몸과 마음을 힐링할 수 있는 온천 및 스파 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('카페/전통찻집', this)">
                <div class="card-body">
                    <h5 class="card-title">카페/전통찻집</h5>
                    <p class="card-text">아늑한 분위기에서 커피와 차를 즐기고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('복합 레포츠', this)">
                <div class="card-body">
                    <h5 class="card-title">복합 레포츠</h5>
                    <p class="card-text">다양한 레포츠를 한 번에 즐기고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('야영장,오토캠핑장', this)">
                <div class="card-body">
                    <h5 class="card-title">야영장,오토캠핑장</h5>
                    <p class="card-text">자연 속에서 캠핑과 야영을 즐기고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('문화관광축제', this)">
                <div class="card-body">
                    <h5 class="card-title">문화관광축제</h5>
                    <p class="card-text">다채로운 문화와 축제의 분위기를 경험하고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('박물관', this)">
                <div class="card-body">
                    <h5 class="card-title">박물관</h5>
                    <p class="card-text">역사와 문화, 예술을 감상하고 싶다면 이 카드를 선택하세요.</p>
                </div>
            </div>
        </div>
    </div>

    <form id="categoryForm" action="/auth/sign_card_result" method="POST" style="display: none;">
        <input type="hidden" name="selectedCategory" id="selectedCategoryInput">
    </form>

    <!-- 다음 버튼 -->
    <div class="d-flex justify-content-between mt-4">
        <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
        <button type="button" class="btn btn-primary" id="nextBtn">Sign Up</button>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    let selectedCard = null;  // 현재 선택된 카드
    let selectedCategoryTitle = '';  // 선택된 카테고리의 title

    function selectCategory(category, cardElement) {
        // 이미 선택된 카드가 있을 경우 색상 초기화
        if (selectedCard) {
            selectedCard.classList.remove('selected-card');
        }

        // 선택된 카드에 색상 추가
        cardElement.classList.add('selected-card');
        selectedCard = cardElement;

        // 선택한 여행 분야를 로컬 스토리지에 저장
        localStorage.setItem('selectedCategory', category);

        // 선택된 카드의 제목 저장
        selectedCategoryTitle = cardElement.querySelector('.card-title').innerText;
    }

    document.getElementById('nextBtn').addEventListener('click', function() {
        // 선택된 카드가 있는 경우, 선택된 카테고리의 제목을 alert로 띄움
        if (selectedCard) {
            // 선택된 카테고리를 폼에 설정
            document.getElementById('selectedCategoryInput').value = localStorage.getItem('selectedCategory');

            // 폼을 제출하여 백엔드로 데이터 전송
            document.getElementById('categoryForm').submit();
        } else {
            alert("여행 분야를 선택해주세요.");
        }
    });

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
