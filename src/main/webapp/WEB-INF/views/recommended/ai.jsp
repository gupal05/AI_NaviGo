<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<%
    // 기본 limit는 6, request 파라미터 "limit"가 전달되면 그 값 사용
    int limit = 6;
    String paramLimit = request.getParameter("limit");
    if(paramLimit != null){
        try {
            limit = Integer.parseInt(paramLimit);
        } catch(NumberFormatException e) {
            // 기본값 6 유지
        }
    }
    // request에 저장된 items 배열 가져오기
    JSONArray items = (JSONArray) request.getAttribute("items");
    // 출력할 아이템 수는 items 길이와 limit 중 작은 값
    int itemCount = Math.min(items.length(), limit);
%>
<html>
<head>
    <title>AI 추천 여행지</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        .card-img-custom {
            width: 100%;
            height: 212px;
            object-fit: cover;
        }
        .card-link {
            color: inherit;
            text-decoration: none;
        }
    </style>
    <script>
        // recordClick 함수에 title 매개변수를 추가하여 전송
        function recordClick(contentid, cat1, cat2, cat3, title) {
            fetch('/recordClick', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ contentid: contentid, cat1: cat1, cat2: cat2, cat3: cat3, title: title })
            })
                .then(response => response.text())
                .then(data => console.log("Click recorded:", data))
                .catch(err => console.error("Error:", err));
        }
    </script>
</head>
<body>
<!-- AI 맞춤 추천 타이틀 -->
<div class="container mt-5 text-center">
    <h2 class="fw-bold">AI 사용자 맞춤 여행지 추천</h2>
    <p class="text-muted">
        나의 관심사와 선택한 여행지 데이터를 분석하여 맞춤형 여행지를 추천합니다.
    </p>
</div>
<br>
<div class="container">
    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
        <%
            for (int i = 0; i < itemCount; i++) {
                JSONObject item = items.getJSONObject(i);
                String title = item.optString("title", "제목 없음");
                String imageUrl = item.optString("firstimage", "placeholder.jpg");
                String contentid = item.optString("contentid", "");
                String cat1 = item.optString("cat1", "");
                String cat2 = item.optString("cat2", "");
                String cat3 = item.optString("cat3", "");
                String addr1 = item.optString("addr1", "주소 정보 없음");
                String contenttypeid = item.optString("contenttypeid", "");
                // detailUrl에 title 파라미터도 추가 (URL 인코딩 필요 시 java.net.URLEncoder.encode(title, "UTF-8") 사용)
                String detailUrl = "recommend/detail?contentid=" + contentid +
                        "&contenttypeid=" + contenttypeid +
                        "&title=" + java.net.URLEncoder.encode(title, "UTF-8");
        %>
        <div class="col">
            <a href="<%= detailUrl %>" class="card-link"
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
        <%
            } // end for
        %>
    </div>
</div>
</body>
</html>
