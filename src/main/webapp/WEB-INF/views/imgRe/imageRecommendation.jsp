<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AI NaviGo - 이미지 분석</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #eef2f7;
            background-image: linear-gradient(135deg, #eef2f7 0%, #e3eaf2 100%);
            font-family: 'Noto Sans KR', sans-serif;
            color: #333;
        }
        .container {
            max-width: 1000px;
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            margin-top: 50px;
            margin-bottom: 50px;
        }
        h1 {
            text-align: center;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.2rem;
            position: relative;
            padding-bottom: 15px;
        }
        h1:after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(90deg, #4a90e2, #3cc1be);
            border-radius: 3px;
        }
        h2 {
            text-align: center;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 25px;
        }
        .image-upload-section {
            background: linear-gradient(135deg, rgba(255,255,255,0.8) 0%, rgba(255,255,255,0.9) 100%);
            padding: 15px 0;
        }
        .form-label {
            font-weight: 500;
            color: #34495e;
            margin-bottom: 10px;
        }
        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 12px;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #4a90e2;
            box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
        }
        .image-preview {
            max-width: 100%;
            height: auto;
            border-radius: 12px;
            margin-top: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }
        .image-preview:hover {
            transform: scale(1.02);
        }
        .btn-primary {
            background: linear-gradient(90deg, #4a90e2, #3cc1be);
            border: none;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(74, 144, 226, 0.3);
            transition: all 0.3s;
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, #3a80d2, #4a90e2);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(74, 144, 226, 0.4);
        }
        .btn-primary:active {
            transform: translateY(1px);
        }
        .loading-container {
            display: none;
            text-align: center;
            margin: 40px auto;
            padding: 20px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.06);
            max-width: 300px;
        }
        .loading-container p {
            font-size: 18px;
            font-weight: 500;
            color: #2c3e50;
            margin-bottom: 15px;
        }
        .loading-container img {
            width: 60px;
            animation: spin 1.2s ease-in-out infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .result-card {
            margin-bottom: 30px;
            border: none;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.07);
            background-color: #ffffff;
        }
        .result-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        .card-img-top {
            width: 100%;
            height: 220px;
            object-fit: cover;
        }
        .card-body {
            padding: 20px;
        }
        .card-title {
            font-weight: 600;
            font-size: 1.2rem;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .card-text {
            color: #7f8c8d;
            font-size: 0.95rem;
            line-height: 1.5;
        }
        #image-upload-form {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.04);
            border: 1px solid rgba(74, 144, 226, 0.1);
        }
        #result-section {
            animation: fadeIn 0.6s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        /* 파일 업로드 버튼 스타일링 */
        .file-upload-wrapper {
            position: relative;
            margin-bottom: 20px;
            overflow: hidden;
        }
        .file-upload-input {
            position: absolute;
            top: 0;
            right: 0;
            margin: 0;
            padding: 0;
            font-size: 20px;
            cursor: pointer;
            opacity: 0;
            filter: alpha(opacity=0);
            height: 100%;
            width: 100%;
        }
        .file-upload-button {
            display: block;
            background: #f3f7fb;
            border: 2px dashed #ccd6e0;
            border-radius: 10px;
            padding: 40px 20px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
        }
        .file-upload-button:hover {
            background: #e9f0f8;
            border-color: #4a90e2;
        }
        .file-upload-button i {
            font-size: 48px;
            color: #4a90e2;
            margin-bottom: 15px;
            display: block;
        }
        .file-name-display {
            margin-top: 10px;
            font-size: 0.9rem;
            color: #7f8c8d;
        }
    </style>
</head>
<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<section class="image-upload-section">
    <div class="container">
        <h1>여행지 추천을 위한 이미지 업로드</h1>
        <form id="image-upload-form" enctype="multipart/form-data">
            <div class="mb-4">
                <label class="form-label">이미지를 선택해주세요</label>
                <div class="file-upload-wrapper">
                    <label class="file-upload-button">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <span>이미지를 여기에 끌어다 놓거나 클릭하여 선택하세요</span>
                        <div class="file-name-display" id="file-name">선택된 파일 없음</div>
                        <input type="file" class="file-upload-input" id="image" name="image" accept="image/*" required>
                    </label>
                </div>
            </div>
            <button type="submit" class="btn btn-primary w-100">
                <i class="fas fa-search me-2"></i>여행지 찾기
            </button>
        </form>

        <div id="image-preview-container" class="mt-4" style="display: none; text-align: center;">
            <img id="image-preview" class="image-preview" src="" alt="이미지 미리보기">
        </div>
    </div>
</section>

<div id="loading-container" class="loading-container">
    <p><i class="fas fa-compass fa-spin me-2"></i> 최적의 여행지 분석 중...</p>
    <img src="https://i.gifer.com/4V0b.gif" alt="로딩 아이콘">
</div>

<section id="result-section" class="container mt-5" style="display: none;">
    <h2><i class="fas fa-map-marked-alt me-2"></i>추천된 여행지</h2>
    <div id="result-list" class="row">
        <!-- 결과가 여기에 동적으로 추가됩니다 -->
    </div>
</section>

<!-- 푸터 포함 -->
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    $(document).ready(function() {
        // 파일 선택 시 파일명 표시
        $("#image").on("change", function() {
            let fileName = $(this).val().split('\\').pop();
            if (fileName) {
                $("#file-name").text(fileName);
            } else {
                $("#file-name").text("선택된 파일 없음");
            }
        });

        // 이미지 업로드 폼 제출 시
        $("#image-upload-form").on("submit", function(event) {
            event.preventDefault();
            let formData = new FormData();
            let imageFile = $("#image")[0].files[0];

            // 분석 중 메시지 표시
            $("#loading-container").show();
            $("#result-section").hide(); // 결과 섹션 숨기기

            // 이미지 리사이징
            let reader = new FileReader();
            reader.onload = function(e) {
                let img = new Image();
                img.onload = function() {
                    // 리사이징할 캔버스 생성
                    let canvas = document.createElement("canvas");
                    let ctx = canvas.getContext("2d");

                    // 리사이징 비율 설정 (너비 800px로 리사이즈)
                    let targetWidth = 800;
                    let targetHeight = (img.height * targetWidth) / img.width;

                    canvas.width = targetWidth;
                    canvas.height = targetHeight;

                    // 이미지를 캔버스에 그리기
                    ctx.drawImage(img, 0, 0, targetWidth, targetHeight);

                    // 캔버스에서 리사이징된 이미지 데이터를 얻어 FormData에 추가
                    canvas.toBlob(function(blob) {
                        formData.append("image", blob, imageFile.name);

                        // 이미지를 서버로 업로드
                        uploadImage(formData);
                    }, "image/jpeg");
                };
                img.src = e.target.result;

                // 이미지 미리보기 갱신
                $("#image-preview").attr("src", e.target.result);

                // 이미지 미리보기 영역을 보여줌
                $("#image-preview-container").show(); // 이 부분
            };
            reader.readAsDataURL(imageFile);
        });

        // 이미지 업로드 후 분석 결과 받기
        function uploadImage(formData) {
            $.ajax({
                url: '/upload',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                headers: { "enctype": "multipart/form-data" },
                success: function(response) {
                    console.log(response);
                    displayResults(response.places);
                },
                error: function(xhr, status, error) {
                    alert("이미지 처리 중 오류가 발생했습니다.");
                    console.error("AJAX 오류:", error);
                    $("#loading-container").hide(); // 오류 시 로딩 메시지 숨기기
                }
            });
        }

        // 결과를 화면에 표시
        function displayResults(places) {
            let resultList = $("#result-list");
            resultList.empty(); // 기존 결과 삭제

            // 로딩 메시지 숨기기
            $("#loading-container").hide();

            if (places && places.length > 0) {
                $.each(places, function(index, place) {
                    console.log(place.image_url);

                    // place가 유효한 경우
                    if (place.name && place.address && place.image_url) {
                        let card = $("<div>").addClass("col-md-4");
                        let cardInner = $("<div>").addClass("card result-card");
                        let img = $("<img>").addClass("card-img-top image-preview").attr("src", place.image_url).attr("alt", place.name);
                        let cardBody = $("<div>").addClass("card-body");
                        let cardTitle = $("<h5>").addClass("card-title").text(place.name);
                        let cardText = $("<p>").addClass("card-text").html('<i class="fas fa-map-marker-alt me-2"></i>' + place.address);

                        // 카드 요소들 추가
                        cardBody.append(cardTitle, cardText);
                        cardInner.append(img, cardBody);
                        card.append(cardInner);

                        // 결과 리스트에 카드 추가
                        resultList.append(card);
                    } else {
                        console.log("Missing data in place:", place);
                    }
                });

                // 카드가 하나도 추가되지 않은 경우 처리
                if (resultList.children().length === 0) {
                    resultList.append('<div class="col-12 text-center"><p class="py-4">추천할 여행지가 없습니다.</p></div>');
                }

                // result-section을 보여줌
                $("#result-section").show();
            } else {
                resultList.append('<div class="col-12 text-center"><p class="py-4">추천할 여행지가 없습니다.</p></div>');
                $("#result-section").show();
            }
        }
    });
</script>
<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />
<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>