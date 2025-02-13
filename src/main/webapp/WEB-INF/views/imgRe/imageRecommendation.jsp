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
    <style>
        .image-preview {
            max-width: 100%;
            height: auto;
            margin-top: 15px;
        }
        .result-card {
            margin-bottom: 20px;
        }
        .card-img-top {
            width: 100%;
            height: 100%;
            object-fit: cover;
            margin-top: 0px;
        }
        .loading-container {
            display: none;
            text-align: center;
            margin-top: 20px;
        }
        .loading-container img {
            width: 50px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<!-- 이미지 업로드 섹션 -->
<section class="image-upload-section">
    <div class="container">
        <h1>여행지 추천을 위한 이미지 업로드</h1>
        <form id="image-upload-form" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="image" class="form-label">이미지를 선택해주세요</label>
                <input type="file" class="form-control" id="image" name="image" accept="image/*" required>
            </div>
            <button type="submit" class="btn btn-primary">이미지 업로드</button>
        </form>

        <div id="image-preview-container" class="mt-3" style="display: none;">
            <img id="image-preview" class="image-preview" src="" alt="이미지 미리보기">
        </div>
    </div>
</section>

<!-- 분석 중 메시지 -->
<div id="loading-container" class="loading-container">
    <p>분석 중... <img src="https://i.gifer.com/4V0b.gif" alt="로딩 아이콘"></p>
</div>

<!-- 결과 섹션 -->
<section id="result-section" class="container mt-5" style="display: none;">
    <h2>추천된 여행지</h2>
    <div id="result-list" class="row">
        <!-- 추천된 여행지 결과는 여기에 동적으로 추가됩니다 -->
    </div>
</section>

<!-- 푸터 포함 -->
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    $(document).ready(function() {
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
                        let cardText = $("<p>").addClass("card-text").text(place.address);

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
                    resultList.append('<p>추천할 여행지가 없습니다.</p>');
                }

                // result-section을 보여줌
                $("#result-section").show();
            } else {
                resultList.append('<p>추천할 여행지가 없습니다.</p>');
                $("#result-section").show();
            }
        }
    });

</script>

<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
