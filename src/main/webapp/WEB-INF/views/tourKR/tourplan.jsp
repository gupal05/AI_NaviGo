<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>Navigo AI 여행 플래너</title>

    <!-- Pretendard & Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <script>
        let districtData = {};
        let coastalRegions = {};

        // 기본 하드코딩 데이터 (백업용)
        const defaultDistrictData = {
            "서울": ["전역"],
            "인천": ["전역"],
            "대전": ["전역"],
            "대구": ["전역"],
            "광주": ["전역"],
            "부산": ["전역"],
            "울산": ["전역"],
            "세종": ["전역"],
            "경기": ["가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시", "안성시", "안양시", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"],
            "강원": ["강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군"],
            "충북": ["괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "진천군", "청주시", "충주시", "증평군"],
            "충남": ["공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군", "아산시", "예산군", "천안시", "청양군", "태안군", "홍성군"],
            "경북": ["경산시", "경주시", "고령군", "구미시", "김천시", "문경시", "봉화군", "상주시", "성주군", "안동시", "영덕군", "영양군", "영주시", "영천시", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시"],
            "경남": ["거제시", "거창군", "고성군", "김해시", "남해군", "밀양시", "사천시", "산청군", "양산시", "의령군", "진주시", "창녕군", "창원시", "통영시", "하동군", "함안군", "함양군", "합천군"],
            "전북": ["고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군", "익산시", "임실군", "장수군", "전주시", "정읍시", "진안군"],
            "전남": ["강진군", "고흥군", "곡성군", "광양시", "구례군", "나주시", "담양군", "목포시", "무안군", "보성군", "순천시", "신안군", "여수시", "영광군", "완도군", "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"],
            "제주": ["전역"]
        };

        // districtMapJson 파싱
        try {
            const rawDistrictJson = '${districtMapJson}';
            console.log("Raw district JSON from controller:", rawDistrictJson);
            if (rawDistrictJson && rawDistrictJson.trim() !== '' && rawDistrictJson !== '{}' && rawDistrictJson !== 'null') {
                const escapedDistrictJson = rawDistrictJson.replace(/\\"/g, '"').replace(/\\\\/g, '\\');
                districtData = JSON.parse(escapedDistrictJson);
                console.log("Parsed districtData from server:", districtData);
            } else {
                console.warn("No valid district JSON data received from server, falling back to default districtData");
                districtData = defaultDistrictData;
            }
        } catch (e) {
            console.error("🚨 District JSON parse error:", e);
            districtData = defaultDistrictData;
        }

        // coastalRegionsJson 파싱
        try {
            const rawCoastalJson = '${coastalRegionsJson}';
            console.log("Raw coastal JSON from controller:", rawCoastalJson);
            if (rawCoastalJson && rawCoastalJson.trim() !== '' && rawCoastalJson !== '{}' && rawCoastalJson !== 'null') {
                const escapedCoastalJson = rawCoastalJson.replace(/\\"/g, '"').replace(/\\\\/g, '\\');
                coastalRegions = JSON.parse(escapedCoastalJson);
                console.log("Parsed coastalRegions from server:", coastalRegions);
            } else {
                console.warn("No valid coastal JSON data received from server, using empty object");
                coastalRegions = {};
            }
        } catch (e) {
            console.error("🚨 Coastal JSON parse error:", e);
            coastalRegions = {};
        }

        console.log("Final districtData:", districtData);
        console.log("Final coastalRegions:", coastalRegions);
    </script>

    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #3b82f6;
            --accent-color: #60a5fa;
            --text-color: #1f2937;
            --light-bg: #f3f4f6;
            --border-radius: 12px;
        }
        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
            color: var(--text-color);
            background-color: #fafafa;
        }
        .hero {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            padding: 6rem 2rem;
            color: white;
            margin-bottom: 3rem;
            border-radius: 0 0 var(--border-radius) var(--border-radius);
        }
        .form-label {
            font-weight: 600;
            color: var(--text-color);
        }
        .btn-cta {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 1rem 2rem;
            border-radius: var(--border-radius);
            border: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }
        .theme-btn, .companion-btn {
            border: 2px solid #e5e7eb;
            border-radius: var(--border-radius);
            background-color: #fff;
            padding: 0.75rem 1.5rem;
            margin-right: 0.5rem;
            transition: all 0.3s ease;
        }
        .theme-btn.btn-primary, .companion-btn.btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        .theme-btn.hidden {
            display: none;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/nav.jsp" />

<div class="hero text-center">
    <h1><span>AI Navigo</span> 여행 플래너</h1>
    <p>당신만을 위한 맞춤 여행을 AI가 추천해드립니다.</p>
</div>

<div class="container mt-5">
    <form action="/generate-plan" method="post">
        <div class="mb-3">
            <label for="region" class="form-label">여행 지역</label>
            <select id="region" name="region" class="form-select">
                <option value="">지역 선택</option>
                <c:forEach var="reg" items="${regions}">
                    <option value="${reg}">${reg}</option>
                </c:forEach>
            </select>
        </div>

        <div class="mb-3">
            <label for="district" class="form-label">시군구</label>
            <select id="district" name="district" class="form-select">
                <option value="">시군구 선택</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">여행 테마</label>
            <div id="theme-container">
                <c:forEach var="theme" items="${themes}">
                    <button type="button" class="btn theme-btn" data-value="${theme}">${theme}</button>
                </c:forEach>
            </div>
            <input type="hidden" id="selectedThemes" name="themes" />
        </div>

        <div class="mb-3">
            <label class="form-label">동행자 유형</label>
            <div>
                <button type="button" class="btn companion-btn" data-value="혼자">혼자</button>
                <button type="button" class="btn companion-btn" data-value="연인">연인</button>
                <button type="button" class="btn companion-btn" data-value="친구">친구</button>
                <button type="button" class="btn companion-btn" data-value="가족">가족</button>
                <button type="button" class="btn companion-btn" data-value="반려동물">반려동물</button>
            </div>
            <input type="hidden" id="selectedCompanion" name="companion_type" />
        </div>

        <div class="mb-3">
            <label for="start_date" class="form-label">여행 시작일</label>
            <input type="date" id="start_date" name="start_date" class="form-control" required />
        </div>

        <div class="mb-3">
            <label for="end_date" class="form-label">여행 종료일</label>
            <input type="date" id="end_date" name="end_date" class="form-control" required />
        </div>

        <button type="submit" class="btn btn-cta w-100">여행 일정 생성</button>
    </form>
</div>

<script>
    $(document).ready(function(){
        // 지역 변경 시 시군구 및 테마 업데이트
        $("#region").change(function(){
            const selectedRegion = $(this).val().trim();
            console.log("Selected region:", selectedRegion);

            // 시군구 업데이트
            const districtSelect = $("#district");
            districtSelect.empty().append('<option value="">시군구 선택</option>');

            if (districtData[selectedRegion]) {
                districtData[selectedRegion].forEach(district => {
                    districtSelect.append($('<option>', {
                        value: district,
                        text: district
                    }));
                });
            } else {
                console.warn(`🚨 No districts found for region: "${selectedRegion}", using default data`);
                if (defaultDistrictData[selectedRegion]) {
                    defaultDistrictData[selectedRegion].forEach(district => {
                        districtSelect.append($('<option>', {
                            value: district,
                            text: district
                        }));
                    });
                }
            }

            // "바다" 테마 표시/숨김
            const hasSea = coastalRegions[selectedRegion] === true;
            $(".theme-btn").each(function() {
                if ($(this).data("value") === "바다") {
                    $(this).toggleClass("hidden", !hasSea);
                    if (!hasSea) {
                        $(this).removeClass("btn-primary"); // 선택 해제
                        updateSelectedThemes();
                    }
                }
            });
        });

        // 테마 버튼 클릭 처리
        $(".theme-btn").click(function(){
            if (!$(this).hasClass("hidden")) {
                $(this).toggleClass("btn-primary");
                updateSelectedThemes();
            }
        });

        // 선택된 테마 업데이트
        function updateSelectedThemes() {
            const selected = $(".theme-btn.btn-primary").map(function(){
                return $(this).data("value");
            }).get();
            $("#selectedThemes").val(selected.join(","));
        }

        // 동행자 버튼 클릭 처리
        $(".companion-btn").click(function(){
            $(".companion-btn").removeClass("btn-primary");
            $(this).addClass("btn-primary");
            $("#selectedCompanion").val($(this).data("value"));
        });

        // 초기 지역 설정
        $("#region").trigger("change");
    });
</script>

</body>
</html>