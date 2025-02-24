<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navigo AI 여행 플래너</title>
    <link rel="stylesheet" href="/static/css/layout/style.css">
    <link rel="stylesheet" href="/static/css/main/main.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
</head>
<body>

<!-- ✅ 네비게이션 바 -->
<jsp:include page="/WEB-INF/views/layout/nav.jsp" />

<!-- ✅ Hero Section -->
<div class="hero text-center">
    <h1><span>AI Navigo</span> 여행 플래너</h1>
    <p>당신만을 위한 맞춤 여행을 AI가 추천해드립니다.</p>
</div>

<!-- ✅ 여행 생성 폼 -->
<section class="container mt-5">
    <form action="/generate-plan" method="post">
        <div class="row g-3">
            <!-- 🚀 여행 지역 선택 -->
            <div class="col-md-6">
                <label for="region" class="form-label">여행 지역</label>
                <select id="region" name="region" class="form-select">
                    <option value="">지역 선택</option>
                    <option value="서울">서울</option>
                    <option value="인천">인천</option>
                    <option value="대전">대전</option>
                    <option value="대구">대구</option>
                    <option value="광주">광주</option>
                    <option value="부산">부산</option>
                    <option value="울산">울산</option>
                    <option value="세종시특별자치도">세종시특별자치도</option>
                    <option value="경기도">경기도</option>
                    <option value="강원특별자치도">강원특별자치도</option>
                    <option value="충청북도">충청북도</option>
                    <option value="충청남도">충청남도</option>
                    <option value="경상북도">경상북도</option>
                    <option value="경상남도">경상남도</option>
                    <option value="전북특별자치도">전북특별자치도</option>
                    <option value="전라남도">전라남도</option>
                    <option value="제주도">제주도</option>
                </select>
            </div>

            <!-- 🚀 시군구 선택 -->
            <div class="col-md-6">
                <label for="district" class="form-label">시군구</label>
                <select id="district" name="district" class="form-select">
                    <option value="">시군구 선택</option>
                </select>
            </div>
        </div>

        <!-- 🚀 여행 테마 선택 -->
        <div class="mt-4">
            <label class="form-label">여행 테마</label>
            <div class="d-flex flex-wrap gap-2">
                <button type="button" class="btn theme-btn" data-value="자연">자연</button>
                <button type="button" class="btn theme-btn" data-value="역사">역사</button>
                <button type="button" class="btn theme-btn" data-value="맛집">맛집</button>
                <button type="button" class="btn theme-btn" data-value="힐링">힐링</button>
                <button type="button" class="btn theme-btn" data-value="쇼핑">쇼핑</button>
            </div>
            <input type="hidden" name="themes" id="selectedThemes">
        </div>

        <!-- 🚀 동행자 유형 선택 -->
        <div class="mt-4">
            <label class="form-label">동행자 유형</label>
            <div class="d-flex flex-wrap gap-2">
                <button type="button" class="btn companion-btn" data-value="혼자">혼자</button>
                <button type="button" class="btn companion-btn" data-value="연인">연인</button>
                <button type="button" class="btn companion-btn" data-value="친구">친구</button>
                <button type="button" class="btn companion-btn" data-value="가족">가족</button>
                <button type="button" class="btn companion-btn" data-value="반려동물">반려동물</button>
            </div>
            <input type="hidden" name="companion_type" id="selectedCompanion">
        </div>

        <!-- 🚀 여행 날짜 선택 -->
        <div class="row mt-4">
            <div class="col-md-6">
                <label for="start_date" class="form-label">여행 시작일</label>
                <input type="date" id="start_date" name="start_date" class="form-control" required>
            </div>
            <div class="col-md-6">
                <label for="end_date" class="form-label">여행 종료일</label>
                <input type="date" id="end_date" name="end_date" class="form-control" required>
            </div>
        </div>

        <!-- ✅ 여행 계획 생성 버튼 -->
        <button type="submit" class="btn btn-cta w-100 mt-4">여행 일정 생성</button>
    </form>
</section>

<!-- ✅ 푸터 -->
<footer class="text-center mt-5">
    <p>&copy; 2025 Navigo AI. All Rights Reserved.</p>
</footer>

<script>
    $(document).ready(function() {
        const districtData = {
            "경기도": ["가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시", "안성시", "안양시", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"],
            "강원특별자치도": ["강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군"],
            "충청북도": ["괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "진천군", "청주시", "충주시", "증평군"],
            "충청남도": ["공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군", "아산시", "예산군", "천안시", "청양군", "태안군", "홍성군"],
            "경상북도": ["경산시", "경주시", "고령군", "구미시", "김천시", "문경시", "봉화군", "상주시", "성주군", "안동시", "영덕군", "영양군", "영주시", "영천시", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시"],
            "경상남도": ["거제시", "거창군", "고성군", "김해시", "남해군", "마산시", "밀양시", "사천시", "산청군", "양산시", "의령군", "진주시", "창녕군", "창원시", "통영시", "하동군", "함안군", "함양군"],
            "전북특별자치도": ["고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군", "익산시", "임실군", "장수군", "전주시", "정읍시", "진안군"],
            "전라남도": ["강진군", "고흥군", "곡성군", "광양시", "구례군", "나주시", "담양군", "목포시", "무안군", "보성군", "순천시", "신안군", "여수시", "영광군", "완도군", "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"]
        };

        $("#region").change(function() {
            const selectedRegion = $(this).val();
            console.log(`🔥 선택한 지역: '${selectedRegion}'`);
            const districtSelect = $("#district");

            // 기존 옵션 초기화
            districtSelect.empty().append('<option value="">시군구 선택</option>');

            // 선택한 지역이 districtData에 존재하면 옵션 추가
            if (districtData[selectedRegion]) {
                districtData[selectedRegion].forEach(function(districtName) {
                    let option = $("<option></option>").val(districtName).text(districtName);
                    districtSelect.append(option);
                });
            } else {
                console.error(`🚨 선택한 지역(${selectedRegion})에 대한 시군구 데이터가 없습니다.`);
            }

            console.log(`✅ 선택한 지역: ${selectedRegion}`);
            console.log(`✅ 추가된 시군구 목록:`, districtData[selectedRegion] || "없음");
        });

        $(".theme-btn").click(function() {
            $(this).toggleClass("btn-primary");
            $("#selectedThemes").val($(".theme-btn.btn-primary").map(function() { return $(this).data("value"); }).get().join(","));
        });

        $(".companion-btn").click(function() {
            $(".companion-btn").removeClass("btn-primary");
            $(this).addClass("btn-primary");
            $("#selectedCompanion").val($(this).data("value"));
        });
    });


</script>
<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />
</body>
</html>
