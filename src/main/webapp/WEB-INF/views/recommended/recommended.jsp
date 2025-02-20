<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>추천 여행지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
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

<di class="container my-4">
    <h1>추천 여행</h1>
    <!-- 비어 있는 영역: Ajax로 가져온 컨텐츠(프래그먼트)를 주입 -->
    <div id="contentArena">

    </div>
    <%--    --%>
</di>


<%-- footer --%>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<script>
$(document).ready(function () {
    // 현재 URL의 쿼리스트링(예: ?menu=ai)에서 menu 파라미터를 얻음
    let urlParams = new URLSearchParams(window.location.search);
    let menu = urlParams.get("menu"); // "ai", "festval", "popular", "course"

    // menu 값이 있으면 해당하는 Fragment를 Ajax로 로드
    if (menu) {
        loadFragment(menu);
    }

    // 실제 Fragment 로드 함수
    function loadFragment(menukey) {
        let endpoint = "";
        switch (menukey) {
            case "ai":
                endpoint = "/main/recommended/ai"
                break;
            case "festival":
                endpoint = "/main/recommended/festival"
                break;
            case "popular":
                endpoint = "/main/recommended/popular"
                break;
            case "course":
                endpoint = "/main/recommended/course"
                break;
            default:
                console.log("없는 메뉴: ", menukey);
                return;
        }

        $.ajax({
            url: endpoint,
            type: "GET",
            success: function (response){
                //응답 html(프라그먼트)을 #contentArea 내부에 넣음.
                $("#contentArena").html(response);
            },
            error: function (err){
                console.error("AJAX Error:", err);
                alert("AJAX Error:" + JSON.stringify(err));
            }
        })
    }
})
</script>
</body>
</html>
