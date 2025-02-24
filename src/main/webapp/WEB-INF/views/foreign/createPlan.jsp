<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>해외 여행 일정 만들기</title>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Google Places API -->
    <script src="https://maps.googleapis.com/maps/api/js?key=${apikey}&libraries=places"></script>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>

    <style>
        :root {
            --primary-color: #6e78ff;
            --secondary-color: #a777e3;
            --light-bg: #f8faff;
            --dark-text: #333333;
            --light-text: #ffffff;
            --gray-text: #6e6e6e;
            --border-radius: 12px;
            --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        body {
            font-family: 'Poppins', 'Noto Sans KR', sans-serif;
            background-color: var(--light-bg);
            color: var(--dark-text);
            line-height: 1.6;
        }

        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 30px;
            box-shadow: var(--box-shadow);
            border-radius: var(--border-radius);
            background-color: white;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: var(--dark-text);
            font-weight: 600;
            position: relative;
            padding-bottom: 15px;
        }

        h2:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 3px;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark-text);
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(110, 120, 255, 0.2);
            outline: none;
            background-color: white;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
        }

        .form-row > div {
            flex: 1;
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 14px 20px;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            width: 100%;
            font-size: 18px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(110, 120, 255, 0.3);
            letter-spacing: 0.5px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(110, 120, 255, 0.4);
            background: linear-gradient(135deg, #5d67ff, #9566d3);
        }

        .error-message {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        /* Custom Styling for Date Input */
        input[type="date"] {
            appearance: none;
            -webkit-appearance: none;
            color: var(--dark-text);
            padding: 12px 15px;
            border: 1px solid #ddd;
            background: #f9f9f9;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        input[type="date"]:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(110, 120, 255, 0.2);
            outline: none;
            background-color: white;
        }

        /* Placeholder text styling */
        ::placeholder {
            color: #aaa;
            opacity: 1;
        }

        /* Top header spacing */
        #top-header {
            margin-bottom: 20px;
        }

        /* Google Places Autocomplete Styling */
        .pac-container {
            border-radius: 8px;
            margin-top: 5px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border: none;
        }

        .pac-item {
            padding: 8px 12px;
            cursor: pointer;
        }

        .pac-item:hover {
            background-color: rgba(110, 120, 255, 0.1);
        }

        .pac-item-query {
            font-size: 15px;
            color: var(--dark-text);
        }

        .pac-matched {
            font-weight: 600;
            color: var(--primary-color);
        }

        /* Form Group with Icon Adjustment */
        .form-group.with-icon {
            position: relative;
        }

        .form-group.with-icon .icon-prefix {
            position: absolute;
            left: 15px;
            top: 47px; /* 조정된 위치: 라벨 아래, 인풋 중앙에 맞춤 */
            color: var(--gray-text);
            z-index: 1;
        }

        .form-group.with-icon .form-control.with-icon {
            padding-left: 40px;
        }

        /* 테마 선택기 스타일 */
        .custom-theme-selector {
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
            padding: 10px;
        }

        .theme-options {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .theme-tag {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 8px 15px;
            background-color: white;
            border: 1px solid #e0e0e0;
            border-radius: 50px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s ease;
            position: relative;
        }

        .theme-tag:hover {
            background-color: #f0f0f0;
        }

        .theme-tag.selected {
            background-color: rgba(110, 120, 255, 0.1);
            border-color: rgba(110, 120, 255, 0.3);
            color: #6e78ff;
            font-weight: 500;
            padding-right: 35px;
        }

        .theme-tag.selected::after {
            content: '×';
            position: absolute;
            right: 12px;
            font-size: 16px;
            font-weight: normal;
        }

        /* 로딩 오버레이 스타일 */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.9);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s, visibility 0.3s;
        }

        .loading-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .loading-spinner {
            text-align: center;
        }

        .spinner {
            width: 50px;
            height: 50px;
            margin: 0 auto 15px;
            border: 4px solid rgba(110, 120, 255, 0.2);
            border-top: 4px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        .loading-spinner p {
            color: var(--primary-color);
            font-weight: 500;
            margin-top: 15px;
            font-size: 16px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* 반응형 Styling */
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 15px;
            }

            .container {
                padding: 20px;
                margin: 20px 15px;
            }

            .form-control,
            input[type="date"] {
                padding: 10px 12px;
            }

            .btn-submit {
                padding: 12px 15px;
                font-size: 16px;
            }

            .theme-options {
                gap: 8px;
            }

            .theme-tag {
                padding: 6px 12px;
                font-size: 13px;
            }
        }
    </style>
</head>
<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>
<div class="container">
    <h2>해외 여행 일정 만들기</h2>

    <form id="travelPlanForm">
        <!-- 여행지 검색 -->
        <div class="form-group with-icon">
            <label for="locationSearch">여행지 선택</label>
            <i class="bi bi-geo-alt icon-prefix"></i>
            <input type="text" id="locationSearch" class="form-control with-icon" placeholder="도시를 검색하세요 (예: 도쿄, 파리)">
            <div id="locationError" class="error-message">여행지를 선택해주세요.</div>
            <input type="hidden" id="destinationName">
            <input type="hidden" id="destinationLat">
            <input type="hidden" id="destinationLng">
        </div>

        <!-- 여행 날짜 선택 -->
        <div class="form-row">
            <div class="form-group with-icon">
                <label for="startDate">여행 시작일</label>
                <input type="date" id="startDate" class="form-control" required>
                <div id="dateError" class="error-message">시작일을 선택해주세요.</div>
            </div>
            <div class="form-group">
                <label for="duration">여행 기간</label>
                <select id="duration" class="form-control" required>
                    <c:forEach begin="1" end="14" var="day">
                        <option value="${day}">${day}일</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <!-- 여행 테마 -->
        <div class="form-group">
            <label>여행 테마 (최대 3개 선택)</label>
            <div class="custom-theme-selector">
                <div class="theme-options">
                    <div class="theme-tag">박물관</div>
                    <div class="theme-tag">미술관</div>
                    <div class="theme-tag">문화/역사</div>
                    <div class="theme-tag">관광명소</div>
                    <div class="theme-tag">자연/아웃도어</div>
                    <div class="theme-tag">음식/맛집</div>
                    <div class="theme-tag">쇼핑</div>
                    <div class="theme-tag">휴양/힐링</div>
                </div>
            </div>
            <div id="themeError" class="error-message">최소 1개의 테마를 선택해주세요.</div>
            <input type="hidden" id="themes" name="themes">
        </div>

        <!-- 여행자 정보 -->
        <div class="form-row">
            <div class="form-group">
                <label for="travellerType">여행 타입</label>
                <select id="travellerType" class="form-control">
                    <option value="solo">혼자</option>
                    <option value="couple">커플</option>
                    <option value="family">가족</option>
                    <option value="friend">친구</option>
                </select>
            </div>
            <div class="form-group">
                <label for="travellerCount">인원</label>
                <select id="travellerCount" class="form-control">
                    <c:forEach begin="1" end="10" var="count">
                        <option value="${count}">${count}명</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <button type="submit" class="btn-submit">
            <i class="bi bi-calendar-plus me-2"></i>일정 생성하기
        </button>
    </form>

    <!-- 로딩 오버레이 -->
    <div id="loading-overlay" class="loading-overlay">
        <div class="loading-spinner">
            <div class="spinner"></div>
            <p>일정을 생성 중입니다...</p>
        </div>
    </div>
</div>

<script>
    // Google Places Autocomplete 초기화
    function initPlacesAutocomplete() {
        const input = document.getElementById('locationSearch');
        const autocomplete = new google.maps.places.Autocomplete(input, {
            types: ['(cities)']
        });

        autocomplete.addListener('place_changed', function() {
            const place = autocomplete.getPlace();
            if (place.geometry) {
                const locationData = {
                    name: place.name,
                    lat: place.geometry.location.lat(),
                    lng: place.geometry.location.lng()
                };

                // 세션 스토리지에 저장
                sessionStorage.setItem('selectedDestination', JSON.stringify(locationData));

                document.getElementById('destinationName').value = place.name;
                document.getElementById('destinationLat').value = place.geometry.location.lat();
                document.getElementById('destinationLng').value = place.geometry.location.lng();
                $('#locationError').hide();
            }
        });
    }

    $(document).ready(function() {
        // 테마 선택 관련 변수
        const themeOptions = document.querySelectorAll('.theme-tag');
        const themesInput = document.getElementById('themes');
        const maxThemes = 3;
        const selectedThemes = [];

        // 테마 항목 클릭 이벤트
        themeOptions.forEach(option => {
            option.addEventListener('click', function() {
                const theme = this.textContent.trim();

                // 이미 선택된 테마인 경우 제거
                if (this.classList.contains('selected')) {
                    this.classList.remove('selected');
                    removeSelectedTheme(theme);
                    return;
                }

                // 최대 3개까지만 선택 가능
                if (selectedThemes.length >= maxThemes) {
                    return;
                }

                // 테마 선택
                this.classList.add('selected');
                addSelectedTheme(theme);
            });
        });

        // 선택된 테마 추가
        function addSelectedTheme(theme) {
            if (selectedThemes.includes(theme)) return;

            selectedThemes.push(theme);
            updateHiddenInput();
            $('#themeError').hide();
        }

        // 선택된 테마 제거
        function removeSelectedTheme(theme) {
            const index = selectedThemes.indexOf(theme);
            if (index !== -1) {
                selectedThemes.splice(index, 1);
                updateHiddenInput();
            }
        }

        // 숨겨진 input 업데이트
        function updateHiddenInput() {
            themesInput.value = JSON.stringify(selectedThemes);
        }

        // Google Places Autocomplete 초기화
        initPlacesAutocomplete();

        // 시작일 최소값을 오늘로 설정
        const today = new Date().toISOString().split('T')[0];
        $('#startDate').attr('min', today);

        // 여행자 타입에 따른 인원 수 제한
        $('#travellerType').change(function() {
            const type = $(this).val();
            const countSelect = $('#travellerCount');
            countSelect.empty();

            let maxCount = 10;
            let startCount = 1;

            switch(type) {
                case 'solo':
                    maxCount = 1;
                    break;
                case 'couple':
                    startCount = 2;
                    maxCount = 2;
                    break;
                case 'family':
                case 'friend':
                    startCount = 2;
                    break;
            }

            for(let i = startCount; i <= maxCount; i++) {
                countSelect.append($('<option></option>').val(i).text(i + '명'));
            }
        }).trigger('change');

        // 폼 제출
        $('#travelPlanForm').on('submit', function(e) {
            e.preventDefault();

            // 즉시 로딩 표시 (유효성 검사 전에)
            document.getElementById('loading-overlay').classList.add('active');

            let isValid = true;

            // 여행지 검증
            if (!$('#destinationLat').val() || !$('#destinationLng').val()) {
                $('#locationError').show();
                isValid = false;
            }

            // 날짜 검증
            if (!$('#startDate').val()) {
                $('#dateError').show();
                isValid = false;
            }

            // 테마 검증
            if (selectedThemes.length === 0) {
                $('#themeError').show();
                isValid = false;
            }

            // 유효성 검사 실패 시 로딩 숨김
            if (!isValid) {
                document.getElementById('loading-overlay').classList.remove('active');
                return;
            }

            if (isValid) {
                // 세션 스토리지에서 위치 정보 가져오기
                const storedLocation = JSON.parse(sessionStorage.getItem('selectedDestination'));

                // 시작일과 종료일 계산
                const startDate = new Date($('#startDate').val());
                const duration = parseInt($('#duration').val());
                const endDate = new Date(startDate);
                endDate.setDate(endDate.getDate() + duration - 1);

                const formData = {
                    destination: storedLocation.name,
                    destinationDetail: {
                        name: storedLocation.name,
                        lat: storedLocation.lat,
                        lng: storedLocation.lng
                    },
                    startDate: $('#startDate').val(),
                    endDate: endDate.toISOString().split('T')[0],
                    themes: selectedThemes,
                    travelers: {
                        count: parseInt($('#travellerCount').val()),
                        type: $('#travellerType').val()
                    }
                };

                // AJAX 요청
                $.ajax({
                    url: '/foreign/create',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(formData),
                    success: function(response) {
                        if (response.success) {
                            window.location.href = '/foreign/plan/' + response.planId;
                        } else {
                            // 에러 시 로딩 오버레이 숨김
                            document.getElementById('loading-overlay').classList.remove('active');
                            alert('일정 생성에 실패했습니다: ' + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        // 에러 시 로딩 오버레이 숨김
                        document.getElementById('loading-overlay').classList.remove('active');
                        alert('일정 생성 중 오류가 발생했습니다.');
                    }
                });
            }
        });
    });
</script>
<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />
</body>
</html>