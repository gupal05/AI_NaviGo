<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*, java.io.*, org.json.JSONArray, org.json.JSONObject" %>
<%
    // ------------------------------
    // 1. 첫번째 API 호출: areaBasedList1 (기본 목록 조회)
    // ------------------------------
    String tempword = "힐링 코스";
    String tempword2 = tempword;
    String tempsearchword = "";
    if(tempword.equals("힐링 코스")){
        tempsearchword = "C0114";
    } else if(tempword.equals("음식")){
        tempsearchword = "A0502";
    }

    String serviceKey = "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk%2BKzMuXzMv3zKpoylWiGbVlCLA%3D%3D";
    StringBuilder urlBuilder = new StringBuilder();
    urlBuilder.append("http://apis.data.go.kr/B551011/KorService1/areaBasedList1?");
    urlBuilder.append("serviceKey=").append(serviceKey);
    urlBuilder.append("&numOfRows=40");
    urlBuilder.append("&pageNo=1");
    urlBuilder.append("&MobileOS=ETC");
    urlBuilder.append("&MobileApp=AINaviGo");
    urlBuilder.append("&_type=json");
    urlBuilder.append("&listYN=Y");
    urlBuilder.append("&arrange=R");
    // 여기서는 tempsearchword를 사용하여 목록 조회
    urlBuilder.append("&cat2=").append(tempsearchword);

    URL url = new URL(urlBuilder.toString());
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    conn.setRequestProperty("Accept", "application/json");

    int responseCode = conn.getResponseCode();
    String jsonResponse = "";
    if(responseCode == 200) {
        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while((line = br.readLine()) != null){
            sb.append(line);
        }
        br.close();
        jsonResponse = sb.toString();
    } else {
        jsonResponse = "{\"response\":{\"header\":{\"resultCode\":\"API ERROR: " + responseCode + "\"}}}";
    }
    conn.disconnect();

    // ------------------------------
    // 2. 첫번째 API JSON 파싱 (목록 items 배열 추출)
    // ------------------------------
    JSONArray items = new JSONArray();
    String parsingMessage = "";
    try {
        JSONObject jsonObj = new JSONObject(jsonResponse);
        JSONObject responseObj = jsonObj.getJSONObject("response");
        JSONObject bodyObj = responseObj.getJSONObject("body");
        JSONObject itemsObj = bodyObj.getJSONObject("items");
        Object itemData = itemsObj.get("item");
        if(itemData instanceof JSONArray){
            items = (JSONArray) itemData;
        } else if(itemData instanceof JSONObject){
            items = new JSONArray();
            items.put(itemData);
        }
        parsingMessage = "JSON 파싱 성공: 총 " + items.length() + "개의 항목이 있습니다.";
    } catch(Exception e){
        parsingMessage = "첫번째 API 데이터를 불러오는데 실패했습니다: " + e.getMessage();
        items = new JSONArray();
    }

    // ------------------------------
    // 3. limit 파라미터 적용 (예: limit=8)
    // ------------------------------
    String limitStr = request.getParameter("limit");
    int limit = items.length();
    // 디버그: 파라미터 값 확인
//    out.println("Received limit parameter: " + limitStr + "<br/>");
    if(limitStr != null) {
        try {
            int reqLimit = Integer.parseInt(limitStr);
            limit = Math.min(reqLimit, items.length());
        } catch(Exception ex) {
            // 파라미터 변환 실패 시 전체 아이템 사용
        }
    }
//    out.println("Using limit: " + limit + " / Total items: " + items.length() + "<br/>");
%>
<html>
<head>
    <title>AI 추천 여행지</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <style>
        .card-img-custom {
            width: 295px;
            height: 212px;
            object-fit: cover;
        }
        .card-link {
            color: inherit;
            text-decoration: none;
        }
        /*.debug-box {*/
        /*    background-color: #f8f9fa;*/
        /*    padding: 15px;*/
        /*    margin-bottom: 20px;*/
        /*    border: 1px solid #ddd;*/
        /*    font-family: monospace;*/
        /*    font-size: 13px;*/
        /*}*/
    </style>
</head>
<body>
<%--<div class="container my-4">--%>
<%--    <!-- 디버깅 정보 영역 -->--%>
<%--    <div class="debug-box">--%>
<%--        <h5>첫번째 API 응답 (jsonResponse)</h5>--%>
<%--        <pre><%= jsonResponse %></pre>--%>
<%--        <hr>--%>
<%--        <h5>JSON 파싱 결과</h5>--%>
<%--        <p><%= parsingMessage %></p>--%>
<%--    </div>--%>

    <h3 class="mb-3">AI추천 <%= tempword2 %> 관련 여행지</h3>

    <div class="row row-cols-1 row-cols-md-4 g-4 mb-5">
        <%
            for(int i = 0; i < limit; i++){
                JSONObject item = items.getJSONObject(i);
                String title = item.optString("title", "제목 없음");
                String imageUrl = item.optString("firstimage", "");
                if(imageUrl == null || imageUrl.isEmpty()){
                    imageUrl = "placeholder.jpg";
                }
                String contentid = item.optString("contentid", "");
                String detailUrl = "detail.jsp?contentid=" + contentid;
        %>
        <div class="col">
            <a href="<%= detailUrl %>" class="card-link">
                <div class="card h-100">
                    <img src="<%= imageUrl %>" class="card-img-top card-img-custom" alt="<%= title %>">
                    <div class="card-body">
                        <span class="badge bg-Primary mb-2">AI추천</span>
                        <h5 class="card-title"><%= title %></h5>
                    </div>
                </div>
            </a>
        </div>
        <%
            } // end for
        %>
    </div>
<%--</div>--%>
</body>
</html>
