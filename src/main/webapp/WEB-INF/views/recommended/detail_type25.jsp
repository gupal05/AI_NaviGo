<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<!-- 이용안내 영역 (기존 detail 속성 사용) -->
<div class="info-box">
    <h3>이용안내</h3>
    <%
        String detailStr = (String) request.getAttribute("detail");
        if (detailStr != null && !"Detail_intro 정보 없음".equals(detailStr)) {
            try {
                JSONArray detailArray = new JSONArray(detailStr);
                if (detailArray.length() > 0) {
                    JSONObject detailItem = detailArray.getJSONObject(0);
                    // 예시: 기존 detail 정보에서 'distance', 'taketime', 'infocentertourcourse', 'schedule' 등을 출력
                    String distance = detailItem.optString("distance", "").trim();
                    String taketime = detailItem.optString("taketime", "").trim();
                    String infocentertourcourse = detailItem.optString("infocentertourcourse", "").trim();
                    String schedule = detailItem.optString("schedule", "").trim();

                    if (!distance.isEmpty()) {
    %>
    <p><strong>총 거리:</strong> <%= distance %></p>
    <%
        }
        if (!taketime.isEmpty()) {
    %>
    <p><strong>소요시간:</strong> <%= taketime %></p>
    <%
        }
        if (!infocentertourcourse.isEmpty()) {
    %>
    <p><strong>문의처:</strong> <%= infocentertourcourse %></p>
    <%
        }
        if (!schedule.isEmpty()) {
    %>
    <p><strong>추천 일정:</strong> <%= schedule %></p>
    <%
        }
        if(distance.isEmpty() && taketime.isEmpty() && infocentertourcourse.isEmpty() && schedule.isEmpty()){
    %>
    <p>이용 안내 정보가 없습니다.</p>
    <%
        }
    } else {
    %>
    <p>이용 안내 정보가 없습니다.</p>
    <%
        }
    } catch (Exception e) {
    %>
    <p>이용 안내 정보 파싱 중 오류 발생.</p>
    <%
        }
    } else {
    %>
    <p>이용 안내 정보가 없습니다.</p>
    <%
        }
    %>
</div>

<!-- 추가상세정보 영역 (새 detail_info 속성 사용) -->
<div class="info-box">
    <h3>추가상세정보</h3>
    <%
        String detailInfoStr = (String) request.getAttribute("detail_info");
        if (detailInfoStr != null && !"Detail_info 정보 없음".equals(detailInfoStr)) {
            try {
                JSONArray infoArray = new JSONArray(detailInfoStr);
                if (infoArray.length() > 0) {
                    // infoArray의 각 아이템을 순회하면서 infoname과 infotext를 출력
                    for (int i = 0; i < infoArray.length(); i++) {
                        JSONObject infoItem = infoArray.getJSONObject(i);
                        String infoname = infoItem.optString("infoname", "").trim();
                        String infotext = infoItem.optString("infotext", "").trim();
    %>
    <div class="sub-info-box" style="margin-bottom:15px;">
        <p><strong><%= infoname %>:</strong></p>
        <p><%= infotext %></p>
    </div>
    <%
        }
    } else {
    %>
    <p>추가상세정보가 없습니다.</p>
    <%
        }
    } catch (Exception e) {
    %>
    <p>추가상세정보 파싱 중 오류 발생.</p>
    <%
        }
    } else {
    %>
    <p>추가상세정보가 없습니다.</p>
    <%
        }
    %>
</div>
