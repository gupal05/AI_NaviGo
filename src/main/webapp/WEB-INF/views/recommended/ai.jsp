<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<%
    JSONArray items = (JSONArray) request.getAttribute("items");
%>
<html>
<head>
    <title>AI 추천 여행지</title>
    <%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommended/travelCard.css"/>--%>
<%--    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>--%>
<%--    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>--%>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommended/travelCard.css"/>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>--%>
<%--    <style>--%>
<%--        /*.recommendations-container {*/--%>
<%--        /*    position: relative;*/--%>
<%--        /*}*/--%>
<%--        /*.recommend-again {*/--%>
<%--        /*    position: absolute;*/--%>
<%--        /*    top: 10px;*/--%>
<%--        /*    right: 10px;*/--%>
<%--        /*    z-index: 10;*/--%>
<%--        /*}*/--%>
<%--    </style>--%>
    <script>
        // 클릭 시 DB에 기록 (recordClick)
        function recordClick(contentid, cat1, cat2, cat3, title) {
            fetch('/recordClick', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    contentid: contentid,
                    cat1: cat1,
                    cat2: cat2,
                    cat3: cat3,
                    title: title
                })
            })
                .then(response => response.text())
                .then(data => console.log("Click recorded:", data))
                .catch(err => console.error("Error:", err));
        }

        var currentPage = 1;
        <%--// "다시 추천받기" 버튼 클릭 시 페이지와 refresh 파라미터를 reset하여 새로운 추천 결과를 요청--%>
        function refreshRecommendations() {
            currentPage = 1;  // 첫 페이지부터 새로 시작
            var exclude = $('#excludeInput').val();
            var url = "<c:url value='/main/recommended/ai/json'/>" + "?page=" + currentPage + "&refresh=true&r=" + new Date().getTime();
            if (exclude) {
                url += "&exclude=" + exclude;
            }

            console.log("⏳ 다시 추천받기 버튼 클릭됨! 로딩 시작...");

            // ✅ AJAX 요청 전: 로딩 화면 표시
            $("#loading-container").show();  // 로딩 UI 표시
            $("#recommendations").hide();    // 기존 추천 목록 숨기기

            $.ajax({
                url: url,
                method: "GET",
                dataType: "json",
                success: function(response) {
                    console.log("✅ AJAX 요청 성공! 추천 여행지 업데이트.");
                    renderRecommendations(response.recommendations);
                },
                error: function(xhr, status, error) {
                    console.error("❌ 추천 여행지 요청 실패:", error);
                    $("#recommendations").html("<p>추천 결과가 없습니다. 다음에 다시 시도해 주세요..</p>");
                },
                complete: function() {
                    // ✅ AJAX 요청 완료 후: 로딩 UI 숨기고 새로운 추천 결과 표시
                    console.log("✅ AJAX 요청 완료! 로딩 숨기고 추천 목록 표시.");
                    $("#loading-container").hide();  // 로딩 UI 숨기기
                    $("#recommendations").show();    // 새로운 추천 목록 표시
                }
            });
        }
        function renderRecommendations(data) {
            var html = "";
            $.each(data, function(index, item) {
                var encodedTitle = encodeURIComponent(item.title);  // title 인코딩 추가
                var detailUrl = "main/recommend/detail?contentid=" + item.contentid +
                    "&contenttypeid=" + item.contenttypeid +
                    "&title=" + encodedTitle;

                html += "<div class='col'>";
                html += "  <a href='" + detailUrl + "' class='card-link' " +
                    "     data-contentid='" + item.contentid + "'" +
                    "     data-contenttypeid='" + item.contenttypeid + "'" +
                    "     data-title='" + item.title + "'" +
                    "     onclick=\"recordClick('" + item.contentid + "', '" + item.cat1 + "', '" + item.cat2 + "', '" + item.cat3 + "', '" + item.title + "');\">";
                html += "    <div class='card h-100'>";
                html += "      <img src='" + (item.firstimage || 'placeholder.jpg') + "' class='card-img-top card-img-custom' alt='" + item.title + "'>";
                html += "      <div class='card-body'>";
                html += "        <span class='badge bg-primary mb-2'>AI 추천</span>";
                html += "        <h5 class='card-title'>" + item.title + "</h5>";
                html += "        <h6 class='card-addr'>" + (item.addr1 || '주소 정보 없음') + "</h6>";
                html += "      </div>";
                html += "    </div>";
                html += "  </a>";
                html += "</div>";
            });
            $("#recommendations").html(html);
        }
    </script>
</head>
<body>
<div class="section-header">
    <h2 class="fw-bold">AI 사용자 맞춤 여행지 추천</h2>
    <p class="text-muted">나의 관심사와 선택한 여행지 데이터를 분석하여 맞춤형 여행지를 추천합니다.</p>
<%--    <button class="recommend-again" onclick="refreshRecommendations()">다시 추천받기</button>--%>
    <!-- 버튼 예시 -->
    <button class="recommend-again" onclick="refreshRecommendations()">
        <i class="fas fa-sync-alt"></i> 다시 추천받기
    </button>
</div>
<div class="container">

    <div class="recommendations-container">
        <div id="loading-container" class="loading-container" style="display: none; text-align: center; margin: 20px 0;">
            <p><i class="fas fa-compass fa-spin me-2"></i> 최적의 여행지 분석 중...</p>
            <img src="https://i.gifer.com/4V0b.gif" alt="로딩 아이콘" style="width: 80px;">
        </div>
        <div class="row row-cols-1 row-cols-md-3 g-4 mb-5" id="recommendations">
            <%
                int displayCount = Math.min(items.length(), 3);
                for (int i = 0; i < displayCount; i++) {
                    JSONObject item = items.getJSONObject(i);
                    String title = item.optString("title", "제목 없음");
                    String imageUrl = item.optString("firstimage", "placeholder.jpg");
                    String contentid = item.optString("contentid", "");
                    String cat1 = item.optString("cat1", "");
                    String cat2 = item.optString("cat2", "");
                    String cat3 = item.optString("cat3", "");
                    String addr1 = item.optString("addr1", "주소 정보 없음");
                    String contenttypeid = item.optString("contenttypeid", "");
                    String detailUrl = "main/recommend/detail?contentid=" + contentid +
                            "&contenttypeid=" + contenttypeid +
                            "&title=" + java.net.URLEncoder.encode(title, "UTF-8");
            %>
            <div class="col">
                <a href="<%= detailUrl %>" class="card-link"
                   data-contentid="<%= contentid %>"
                   data-contenttypeid="<%= contenttypeid %>"
                   data-title="<%= title %>"
                   onclick="recordClick('<%= contentid %>', '<%= cat1 %>', '<%= cat2 %>', '<%= cat3 %>', '<%= title %>');">
                    <div class="card h-100">
                        <img src="<%= imageUrl %>" class="card-img-top card-img-custom" alt="<%= title %>">
                        <div class="card-body">
                            <span class="badge bg-primary mb-2">AI 추천</span>
                            <h5 class="card-title"><%= title %></h5>
                            <h6 class="card-addr"><%= addr1 %></h6>
                        </div>
                    </div>
                </a>
            </div>
            <% } %>
        </div>
        <input type="hidden" id="excludeInput" value="" />
    </div>
</div>
<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />
</body>
</html>
