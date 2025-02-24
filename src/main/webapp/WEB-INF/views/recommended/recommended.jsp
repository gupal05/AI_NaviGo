<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>추천 여행지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommended/travelCard.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <!-- Bootstrap JS (Popper.js 포함) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%--    - Font Awesome CSS를 head에 추가 -->--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

</head>
<body>
<!-- 헤더와 네비게이션 -->
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="container my-4">
    <!-- 로딩 인디케이터: AJAX 호출 중 보여질 영역 -->
    <div id="loadingIndicator" style="display:none; text-align:center; margin:20px 0;">
        <p><i class="fas fa-compass fa-spin me-2"></i> 최적의 여행지 분석 중...</p>
        <img src="https://i.gifer.com/4V0b.gif" alt="로딩 아이콘" style="width: 80px;">
    </div>
    <!-- AJAX로 컨텐츠를 로드할 영역 -->
    <div id="contentArena"></div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    $(document).ready(function () {
        let urlParams = new URLSearchParams(window.location.search);
        let menu = urlParams.get("menu"); // "ai", "festival", "popular", "course"

        if (menu) {
            loadFragment(menu);
        }

        function loadFragment(menukey) {
            let endpoint = "";
            switch (menukey) {
                case "ai": endpoint = "/main/recommended/ai"; break;
                case "festival": endpoint = "/main/recommended/festival"; break;
                case "popular": endpoint = "/main/recommended/popular"; break;
                case "course": endpoint = "/main/recommended/course"; break;
                default:
                    console.log("없는 메뉴: ", menukey);
                    return;
            }

            $.ajax({
                url: endpoint,
                type: "GET",
                beforeSend: function() {
                    // AJAX 호출 전에 로딩 인디케이터 표시, 콘텐츠 영역 숨김
                    $("#loadingIndicator").show();
                    $("#contentArena").hide();
                },
                success: function (response) {
                    console.log("✅ AJAX 요청 성공, 응답 내용:", response);
                    $("#contentArena").html(response);
                    console.log("🔍 contentArena 업데이트 후 내부 HTML:", $("#contentArena").html());

                    // course 메뉴일 경우 travelcourse.js 다시 로드
                    if (window.location.search.includes("menu=course")) {
                        console.log("📌 travelcourse.js 처음 로드");
                        $.getScript("${pageContext.request.contextPath}/js/travelcourse.js")
                            .done(function() { console.log("✅ travelcourse.js 로드 완료"); })
                            .fail(function(jqxhr, settings, exception) {
                                console.error("❌ travelcourse.js 로드 실패:", exception);
                            });
                    }
                },
                error: function (err) {
                    console.error("AJAX Error:", err);
                    alert("AJAX Error:" + JSON.stringify(err));
                },
                complete: function() {
                    // AJAX 요청 완료 후 로딩 인디케이터 숨기고 콘텐츠 영역 표시
                    $("#loadingIndicator").hide();
                    $("#contentArena").show();
                }
            });
        }
    });
</script>

<!-- ✅ `defer` 속성을 추가하여 travelcourse.js를 미리 로드 -->
<script src="${pageContext.request.contextPath}/js/travelcourse.js" defer></script>
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
</body>
</html>
