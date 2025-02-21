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
</head>
<body>
<!-- 헤더와 네비게이션 -->
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="container my-4">
<%--    <h1>추천 여행</h1>--%>
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
                success: function (response) {
                    console.log("✅ AJAX 요청 성공, 응답 내용:", response); // 추가된 로그
                    $("#contentArena").html(response);

                    console.log("🔍 contentArena 업데이트 후 내부 HTML:", $("#contentArena").html()); // 추가된 로그

                    // ✅ course 페이지가 로드되면 travelcourse.js 다시 실행
                    <%--if (menukey === "course") {--%>
                    <%--    console.log("📌 travelcourse.js 다시 실행");--%>
                    <%--    $.getScript("${pageContext.request.contextPath}/js/travelcourse.js")--%>
                    <%--        .done(function() { console.log("✅ travelcourse.js 로드 완료"); })--%>
                    <%--        .fail(function(jqxhr, settings, exception) {--%>
                    <%--            console.error("❌ travelcourse.js 로드 실패:", exception);--%>
                    <%--        });--%>
                    <%--}--%>
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
