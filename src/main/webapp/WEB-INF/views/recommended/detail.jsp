<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<html>
<head>
    <title>여행지 상세 정보</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body { font-family: Arial, sans-serif; }
        .container { width: 80%; margin: 30px auto 50px auto; }
        .title { font-size: 24px; font-weight: bold; margin-top: 20px; }
        .image-container img { width: 100%; max-height: 400px; object-fit: cover; }
        .details { margin-top: 20px; }
        .info-box { padding: 10px; border: 1px solid #ddd; margin-top: 10px; }
        .info-box h3 { margin-bottom: 10px; }
        /* 지도 표시 영역 */
        #map { width: 100%; height: 400px; margin-top: 20px; }
    </style>
</head>
<body>

<!-- 공통 네비게이션 -->
<jsp:include page="/WEB-INF/views/layout/nav.jsp" />

<div class="container">
    <h1 class="title">여행지 상세 정보</h1>

        <%
        // 좌표 정보를 위한 변수 선언
        String mapX = "";
        String mapY = "";
        String mlevel = "";

        // 컨트롤러에서 받은 items 배열 가져오기
        JSONArray items = (JSONArray) request.getAttribute("items");
        if (items != null && items.length() > 0) {
            JSONObject item = items.getJSONObject(0);

            // 좌표 관련 값 추출
            mapX = item.optString("mapx", "").trim();
            mapY = item.optString("mapy", "").trim();
            mlevel = item.optString("mlevel", "").trim();
    %>

    <!-- 제목 -->
    <h2><%= item.optString("title", "제목 없음").trim() %></h2>

    <!-- 이미지 -->
    <div class="image-container">
        <%
            String firstImage = item.optString("firstimage", "").trim();
            if (!firstImage.isEmpty()) {
        %>
        <img src="<%= firstImage %>" alt="여행지 이미지" />
        <%
        } else {
        %>
        <img src="default.jpg" alt="기본 이미지" />
        <%
            }
        %>
    </div>

    <!-- 기본 정보 -->
    <div class="details">
        <%
            String address = item.optString("addr1", "").trim();
            if (!address.isEmpty()) {
        %>
        <div class="info-box">
            <h3>주소</h3>
            <p><%= address %></p>
        </div>
        <%
            }

            String overview = item.optString("overview", "").trim();
            if (!overview.isEmpty()) {
        %>
        <div class="info-box">
            <h3>상세 설명</h3>
            <p><%= overview %></p>
        </div>
        <%
            }

            // ✅ 홈페이지 URL 중복 제거 및 하나만 출력하도록 수정
            String homepage = item.optString("homepage", "").trim();
            if (!homepage.isEmpty()) {
                // HTML 태그 제거하고 URL만 추출
                String homepageUrl = homepage.replaceAll(".*?href=\"(.*?)\".*", "$1");

                // 만약 URL이 http로 시작하지 않으면 원래 값 사용
                if (!homepageUrl.startsWith("http")) {
                    homepageUrl = homepage;
                }
        %>
        <div class="info-box">
            <h3>홈페이지</h3>
            <p>
                <a href="<%= homepageUrl %>" target="_blank">
                    <%= homepageUrl %>
                </a>
            </p>
        </div>
        <%
            }

            String tel = item.optString("tel", "").trim();
            if (!tel.isEmpty()) {
        %>
        <div class="info-box">
            <h3>전화번호</h3>
            <p><%= tel %></p>
        </div>
        <%
            }
        } else {
        %>
        <p>데이터를 불러오지 못했습니다.</p>
        <%
            }
        %>

        <!-- 지도 영역 -->
        <div class="info-box">
            <h3>지도</h3>
            <div id="map"></div>
            <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1566bd1d6f68d1023bc9a09a03089078"></script>
            <script>
                <%
                   // 좌표 값이 있을 때만 지도 초기화
                   if (!mapX.isEmpty() && !mapY.isEmpty() && !mlevel.isEmpty()) {
                %>
                var container = document.getElementById('map');
                var options = {
                    center: new kakao.maps.LatLng(<%= mapY %>, <%= mapX %>),
                    level: parseInt('<%= mlevel %>')
                };
                var map = new kakao.maps.Map(container, options);

                // 마커 표시
                var markerPosition = new kakao.maps.LatLng(<%= mapY %>, <%= mapX %>);
                var marker = new kakao.maps.Marker({ position: markerPosition });
                marker.setMap(map);
                <% } %>
            </script>
        </div>

        <hr style="margin-top:40px; margin-bottom:40px;">

        <!-- 타입별 추가 상세정보 include -->
        <c:choose>
            <c:when test="${contenttypeid == '12'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type12.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '14'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type14.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '15'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type15.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '25'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type25.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '28'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type28.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '39'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type39.jsp" />
            </c:when>
            <c:otherwise>
                <div class="info-box">
                    <p>추가 상세 정보가 없습니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 공통 푸터 -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
