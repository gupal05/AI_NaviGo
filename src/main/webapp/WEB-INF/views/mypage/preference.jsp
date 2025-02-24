<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nevigo.ai_navigo.dto.PreferenceDTO" %>

<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>선호 여행 취향 수정 - AI NaviGo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .alert {
            display: none;
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
            padding: 15px 20px;
            border-radius: 8px;
            /*box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); !* 그림자 효과 추가 *!*/
            font-size: 1.2rem; /*!* 글씨 크기 키움 */
            /*font-weight: bold; !* 글씨 진하게 *!*/
            color: #fff; /* 텍스트 색상을 흰색으로 */
            background-color: #007bff; /* 진한 파란색 */
        }
        .container {
            margin: 10px auto;
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
            display: flex;
            height: 240px; /* 높이를 고정 */
            width: 180px; /* 너비를 고정 */
            margin: 0 auto; /* 카드들 가운데 정렬 */
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
        .selected-card .card-text {
            /*background-color: #007bff; !* 진한 파란색 **!*/
            color: #fff; /* 카드 텍스트 색상 흰색으로 변경 */
        }
        h2{
            font-weight: bold;
        }
        :root {
            --primary-color: #5468ff;
            --primary-hover: #4152e3;
            --secondary-color: #f6f8ff;
            --text-primary: #2c3256;
            --text-secondary: #6b7280;
            --border-color: #e2e8f0;
            --success-color: #10b981;
            --error-color: #ef4444;
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
        /* 메인 컨테이너 스타일 */
        .mypage-container {
            display: flex;
            gap: 30px;
            padding: 40px 20px;
            margin-top: 20px;
            min-height: calc(100vh - 80px);
            animation: fadeIn 0.5s ease-out;
        }
        /* 본문 영역 스타일 */
        .content {
            flex: 1;
            background: var(--white);
            border-radius: 16px;
            padding: 40px;
            box-shadow: var(--box-shadow);
            position: relative;
            overflow: hidden;
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

        .alert {
            padding: 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 15px;
            animation: slideDown 0.3s ease-out;
        }

        .alert-danger {
            background-color: #fef2f2;
            color: var(--error-color);
            border: 1px solid #fee2e2;
        }

        #signup-btn-group {
            text-align: center;
            margin-top: 24px;
        }

        .form-group {
            margin-bottom: 24px;
            position: relative;
        }

        .form-label {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            height: 54px;
            background-color: #f9fafb;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 0 20px;
            font-size: 15px;
            color: var(--text-primary);
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: var(--white);
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(84, 104, 255, 0.1);
            outline: none;
        }

        .error-message {
            color: var(--error-color);
            font-size: 13px;
            margin-top: 6px;
            display: none;
            animation: fadeIn 0.2s ease-out;
        }

        .valid-input {
            border-color: var(--success-color) !important;
        }

        .btn {
            height: 54px;
            font-weight: 600;
            font-size: 15px;
            border-radius: 12px;
            letter-spacing: 0.3px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            padding: 0 24px;
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
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
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

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 576px) {
            .resetpw-container {
                padding: 32px 24px;
                border-radius: 12px;
            }

            .resetpw-title {
                font-size: 22px;
            }

            .form-control, .btn {
                height: 50px;
            }
        }
    </style>
</head>

<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>
<!-- 마이페이지 메인 컨테이너 -->
<div class="mypage-container container">
    <%--사이드바--%>
    <jsp:include page="/WEB-INF/views/mypage/sidebar.jsp" />
    <%--본문--%>
    <%--    <!-- 저장된 카테고리를 확인 -->--%>
<%--        <p>저장된 선호 여행 취향: ${savedCategory}</p>--%>

    <!-- 저장 성공 popup -->
    <div id="saveAlert" class="alert"></div>

    <div class="row">
        <script>
            // 선택된 선호도가 있다면 해당 값을 저장
            var selectedPreference = "${selectedCategory != null ? selectedCategory : ''}";

            // 카테고리 선택 함수
            function selectCategory(category, cardElement) {
                // 선택된 카테고리와 비교하여 선택된 카드에 스타일 적용
                if (selectedPreference === category) {
                    cardElement.classList.add('selected-card');
                } else {
                    cardElement.classList.remove('selected-card');
                }
            }
        </script>

        <!-- 여행 분야 카드 -->
        <div class="preference-container">
            <div class="preference-header">
                <h1 class="preference-title">여행 취향 수정</h1>
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

        <!-- 저장 버튼 -->
        <div class="d-flex justify-content-between mt-4">
            <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
            <button type="button" class="btn btn-primary" onclick="savePreference()">Save</button>
        </div>
</div>
<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />

<!-- JavaScript -->
<script>
    // 선택된 카테고리를 저장하는 변수
    let selectedCategory = "";

    // 서버에서 전달된 과거 저장된 값
    var savedCategory = "${savedCategory != null ? savedCategory : ''}";
    console.log("Saved Category (from DB):", savedCategory);

    // DOMContentLoaded 이벤트: 저장된 카테고리 강조 표시
    document.addEventListener("DOMContentLoaded", () => {
        if (savedCategory) {
            const cards = document.querySelectorAll('.card');
            cards.forEach(card => {
                const cardTitle = card.querySelector('.card-title').textContent.trim();
                if (cardTitle === savedCategory) {
                    card.classList.add('selected-card');
                    selectedCategory = savedCategory; // 초기 선택값 설정
                }
            });
        }
    });

    function selectCategory(category, cardElement) {
        // 이전 선택 해제
        const previousSelected = document.querySelector('.selected-card');
        if (previousSelected) {
            previousSelected.classList.remove('selected-card');
        }

        // 현재 선택 적용
        cardElement.classList.add('selected-card');

        // 선택된 카테고리를 변수에 저장
        selectedCategory = category;
    }
    // 'Save' 버튼 클릭 이벤트
    function savePreference() {
        if (!selectedCategory) {
            alert("카테고리를 선택하세요!");
            return;
        }

        //update db에 저장하는 script
        // 선택한 값을 서버로 전달
        fetch('/mypage/updatePreference', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ selectedCategory: selectedCategory  }),
        })
            .then(response => {
                if (response.ok) {
                    // 성공 팝업 표시
                    showPopup("성공적으로 저장되었습니다!", "success");
                } else {
                    console.error("Failed to update preference.");
                }
            })
            .catch(error => {
                console.error("Error during preference update:", error);
            });
    }

    // 팝업 메시지 표시 함수
    function showPopup(message, type) {
        const alertDiv = document.getElementById('saveAlert');
        alertDiv.textContent = message;
        alertDiv.className = `alert alert-` + type;
        alertDiv.style.display = 'block';
        // 3초 후 자동으로 팝업 숨김
        setTimeout(() => {
            alertDiv.style.display = 'none';
        }, 3000);
    }

</script>


<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>