<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>여행 취향 선택 - AI NaviGo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

    <style>
        :root {
            --primary-color: #5468ff;
            --primary-hover: #4152e3;
            --secondary-color: #f6f8ff;
            --text-primary: #2c3256;
            --text-secondary: #6b7280;
            --border-color: #e2e8f0;
            --white: #ffffff;
            --box-shadow: 0 10px 30px rgba(84, 104, 255, 0.08);
            --font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f8faff 0%, #f0f4ff 100%);
            font-family: var(--font-family);
            color: var(--text-primary);
            min-height: 100vh;
        }

        .page-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: calc(100vh - 180px);
            padding: 40px 20px;
        }

        .preference-container {
            width: 100%;
            max-width: 1200px;
            background: var(--white);
            border-radius: 20px;
            box-shadow: var(--box-shadow);
            position: relative;
            overflow: hidden;
            padding: 48px;
            margin: 0 auto;
            animation: fadeIn 0.5s ease-out;
        }

        .preference-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, var(--primary-color), #9f7aea);
        }

        .preference-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .preference-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 8px;
            background: linear-gradient(to right, var(--primary-color), #9f7aea);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -0.5px;
        }

        .preference-subtitle {
            color: var(--text-secondary);
            font-size: 15px;
            font-weight: 400;
        }

        .card {
            height: 100%;
            border: 2px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: var(--white);
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, var(--primary-color), #9f7aea);
            opacity: 0;
            transition: all 0.3s ease;
            z-index: 1;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(84, 104, 255, 0.15);
            border-color: var(--primary-color);
        }

        .card-body {
            position: relative;
            z-index: 2;
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 12px;
            transition: all 0.3s ease;
        }

        .card-text {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.5;
            transition: all 0.3s ease;
        }

        .card.selected-card {
            background: linear-gradient(45deg, var(--primary-color), #9f7aea);
            border-color: transparent;
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(84, 104, 255, 0.2);
        }

        .card.selected-card .card-title,
        .card.selected-card .card-text {
            color: var(--white);
        }

        .card-icon {
            font-size: 32px;
            margin-bottom: 16px;
            color: var(--primary-color);
            transition: all 0.3s ease;
        }

        .selected-card .card-icon {
            color: var(--white);
        }

        .btn {
            height: 54px;
            font-weight: 600;
            font-size: 15px;
            border-radius: 12px;
            letter-spacing: 0.3px;
            padding: 0 32px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary-color), #6977ff);
            border: none;
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(to right, #4a59e5, #5c6aff);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25);
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            color: var(--primary-color);
            border: none;
        }

        .btn-secondary:hover {
            background-color: #ebeffe;
            color: var(--primary-hover);
            transform: translateY(-2px);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 768px) {
            .preference-container {
                padding: 32px 24px;
            }

            .card {
                margin-bottom: 16px;
            }
        }
    </style>
</head>
<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="page-wrapper">
    <div class="preference-container">
        <div class="preference-header">
            <h1 class="preference-title">여행 취향 선택</h1>
            <p class="preference-subtitle">선호하는 여행 스타일을 선택하여 맞춤형 추천을 받아보세요</p>
        </div>

        <div class="row g-4">
            <div class="col-12 col-md-6 col-lg-3">
                <div class="card" onclick="selectCategory('산', this)">
                    <div class="card-body text-center">
                        <i class="fas fa-mountain card-icon"></i>
                        <h5 class="card-title">산</h5>
                        <p class="card-text">자연 속에서의 여행을 원하시면 선택하세요.</p>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <div class="card" onclick="selectCategory('해안 절경', this)">
                    <div class="card-body text-center">
                        <i class="fas fa-water card-icon"></i>
                        <h5 class="card-title">해안 절경</h5>
                        <p class="card-text">바다와 해안의 아름다움을 경험하고 싶다면 선택하세요.</p>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <div class="card" onclick="selectCategory('온천/욕장/스파', this)">
                    <div class="card-body text-center">
                        <i class="fas fa-hot-tub card-icon"></i>
                        <h5 class="card-title">온천/욕장/스파</h5>
                        <p class="card-text">몸과 마음을 힐링할 수 있는 온천 및 스파 여행을 원하시면 선택하세요.</p>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <div class="card" onclick="selectCategory('카페/전통찻집', this)">
                    <div class="card-body text-center">
                        <i class="fas fa-coffee card-icon"></i>
                        <h5 class="card-title">카페/전통찻집</h5>
                        <p class="card-text">아늑한 분위기에서 커피와 차를 즐기고 싶다면 선택하세요.</p>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <div class="card" onclick="selectCategory('복합 레포츠', this)">
                    <div class="card-body text-center">
                        <i class="fas fa-running card-icon"></i>
                        <h5 class="card-title">복합 레포츠</h5>
                        <p class="card-text">다양한 레포츠를 한 번에 즐기고 싶다면 선택하세요.</p>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <div class="card" onclick="selectCategory('야영장,오토캠핑장', this)">
                    <div class="card-body text-center">
                        <i class="fas fa-campground card-icon"></i>
                        <h5 class="card-title">야영장,오토캠핑장</h5>
                        <p class="card-text">자연 속에서 캠핑과 야영을 즐기고 싶다면 선택하세요.</p>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <div class="card" onclick="selectCategory('문화관광축제', this)">
                    <div class="card-body text-center">
                        <i class="fas fa-theater-masks card-icon"></i>
                        <h5 class="card-title">문화관광축제</h5>
                        <p class="card-text">다채로운 문화와 축제의 분위기를 경험하고 싶다면 선택하세요.</p>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-6 col-lg-3">
                <div class="card" onclick="selectCategory('박물관', this)">
                    <div class="card-body text-center">
                        <i class="fas fa-landmark card-icon"></i>
                        <h5 class="card-title">박물관</h5>
                        <p class="card-text">역사와 문화, 예술을 감상하고 싶다면 이 카드를 선택하세요.</p>
                    </div>
                </div>
            </div>
        </div>

        <form id="categoryForm" action="/auth/sign_card_result" method="POST" style="display: none;">
            <input type="hidden" name="selectedCategory" id="selectedCategoryInput">
        </form>

        <div class="d-flex justify-content-between mt-5">
            <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                <i class="fas fa-arrow-left me-2"></i>이전
            </button>
            <button type="button" class="btn btn-primary" id="nextBtn">
                가입하기<i class="fas fa-arrow-right ms-2"></i>
            </button>
        </div>
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

    // 폼 제출 함수
    function submitForm() {
        document.getElementById('categoryForm').submit();
    }

    document.getElementById('nextBtn').addEventListener('click', function() {
        if (selectedCard) {
            document.getElementById('selectedCategoryInput').value = localStorage.getItem('selectedCategory');
            // 모달 표시
            new bootstrap.Modal(document.getElementById('completionModal')).show();
        } else {
            alert("여행 분야를 선택해주세요.");
        }
    });

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- 모달 추가 (body 태그 닫기 직전에) -->
<div class="modal fade" id="completionModal" tabindex="-1" aria-labelledby="completionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="completionModalLabel">가입 완료</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                회원가입이 완료되었습니다.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="submitForm()">확인</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
