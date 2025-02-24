<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList" %>
<html>
<head>
    <title>인기 여행지</title>
<%--    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>--%>
<%--    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>--%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommended/travelCard.css"/>
<%--    <style>--%>
<%--        .card-img-custom {--%>
<%--            width: 100%;--%>
<%--            height: 212px;--%>
<%--            object-fit: cover;--%>
<%--        }--%>
<%--        .card-link {--%>
<%--            color: inherit;--%>
<%--            text-decoration: none;--%>
<%--        }--%>
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
    </script>
</head>
<body>
<%--<div class="container mt-5 text-center">--%>
<%--    <h2 class="fw-bold">인기 여행지</h2>--%>
<%--    <p class="text-muted">--%>
<%--        Navigo 사이트에서 최근 7일간 인기있었던 여행지를 추천해 드립니다.--%>
<%--    </p>--%>
<%--</div>--%>

<%
    // Controller에서 model.addAttribute("popularTitleListResults", ...);
    List<Map<String, Object>> popularTitleListResults =
            (List<Map<String, Object>>) request.getAttribute("popularTitleListResults");
    if (popularTitleListResults == null) {
        popularTitleListResults = new ArrayList<>();
    }
%>
<div class="container section-header">
    <h2 class="fw-bold">인기 여행지</h2>
    <p class="text-muted">
        Navigo 사이트에서 최근 7일간 인기있었던 여행지를 추천해 드립니다.
    </p>
</div>
<div class="container">

    <!-- 모든 카드를 하나의 row 안에 배치 -->
    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4 mb-5">
        <%
            // 모든 popularTitleListResults를 순회하면서 각 항목의 keywordResults를 하나의 row에 출력
            for (Map<String, Object> popItem : popularTitleListResults) {
                // 실제 API 검색 결과
                List<Map<String, Object>> keywordResults =
                        (List<Map<String, Object>>) popItem.get("keywordResults");
                if (keywordResults == null) {
                    keywordResults = new ArrayList<>();
                }

                // 각 item: { contentid, firstimage, title, addr1, cat1, cat2, cat3, contenttypeid, ... }
                for (Map<String, Object> item : keywordResults) {
                    String contentid     = (String) item.getOrDefault("contentid", "");
                    String firstimage    = (String) item.getOrDefault("firstimage", "placeholder.jpg");
                    String itemTitle     = (String) item.getOrDefault("title", "제목 없음");
                    String addr1         = (String) item.getOrDefault("addr1", "주소 정보 없음");
                    String cat1          = (String) item.getOrDefault("cat1", "");
                    String cat2          = (String) item.getOrDefault("cat2", "");
                    String cat3          = (String) item.getOrDefault("cat3", "");
                    String contenttypeid = (String) item.getOrDefault("contenttypeid", "");

                    String title = (String) item.getOrDefault("title", "");
                    String encodedTitle  = java.net.URLEncoder.encode(itemTitle, "UTF-8");
                    String detailUrl = "recommend/detail?contentid=" + contentid
                            + "&contenttypeid=" + contenttypeid
                            + "&title=" + encodedTitle;
        %>
        <div class="col">
            <a href="<%= detailUrl %>" class="card-link"
               data-contentid="<%= contentid %>"
               data-contenttypeid="<%= contenttypeid %>"
               data-title="<%= title %>"
               onclick="recordClick('<%= contentid %>', '<%= cat1 %>', '<%= cat2 %>', '<%= cat3 %>', '<%= itemTitle %>');">
                <div class="card h-100">
                    <img src="<%= firstimage %>" class="card-img-top card-img-custom" alt="<%= itemTitle %>">
                    <div class="card-body">
                        <!-- badge 색상을 info 클래스로 변경 -->
                        <span class="badge bg-info mb-2">인기</span>
                        <h5 class="card-title"><%= itemTitle %></h5>
                        <h6 class="card-addr"><%= addr1 %></h6>
                    </div>
                </div>
            </a>
        </div>
        <%
                } // end keywordResults loop
            } // end popularTitleListResults loop
        %>
    </div>
</div>
<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />
</body>
</html>
