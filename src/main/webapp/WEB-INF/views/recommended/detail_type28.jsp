<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<div class="info-box">
    <h3>추가 상세 정보 (레포츠)</h3>
    <%
        String detailStr = (String) request.getAttribute("detail");
        if (detailStr != null && !"Detail 정보 없음".equals(detailStr)) {
            try {
                JSONArray detailArray = new JSONArray(detailStr);
                if (detailArray.length() > 0) {
                    JSONObject detailItem = detailArray.getJSONObject(0);
                    String infocenterLeports = detailItem.optString("infocenterleports", "").trim();
                    String restdateLeports   = detailItem.optString("restdateleports", "").trim();
                    String usefeeleports     = detailItem.optString("usefeeleports", "").trim();
                    String expagerangeleports= detailItem.optString("expagerangeleports", "").trim();
                    String accomcountleports = detailItem.optString("accomcountleports", "").trim();
                    String usetimeleports    = detailItem.optString("usetimeleports", "").trim();
                    String parkingleports    = detailItem.optString("parkingleports", "").trim();

                    if (!infocenterLeports.isEmpty()) {
    %>
    <p><strong>문의처:</strong> <%= infocenterLeports %></p>
    <%
        }
        if (!restdateLeports.isEmpty()) {
    %>
    <p><strong>쉬는날:</strong> <%= restdateLeports %></p>
    <%
        }
        if (!usefeeleports.isEmpty()) {
    %>
    <p><strong>이용요금:</strong> <%= usefeeleports %></p>
    <%
        }
        if (!expagerangeleports.isEmpty()) {
    %>
    <p><strong>이용가능연령:</strong> <%= expagerangeleports %></p>
    <%
        }
        if (!accomcountleports.isEmpty()) {
    %>
    <p><strong>수용인원:</strong> <%= accomcountleports %></p>
    <%
        }
        if (!usetimeleports.isEmpty()) {
    %>
    <p><strong>이용시간:</strong> <%= usetimeleports %></p>
    <%
        }
        if (!parkingleports.isEmpty()) {
    %>
    <p><strong>주차시설:</strong> <%= parkingleports %></p>
    <%
        }
        if (infocenterLeports.isEmpty() && restdateLeports.isEmpty() && usefeeleports.isEmpty() &&
                expagerangeleports.isEmpty() && accomcountleports.isEmpty() && usetimeleports.isEmpty() && parkingleports.isEmpty()) {
    %>
    <p>추가 상세 정보가 없습니다.</p>
    <%
        }
    } else {
    %>
    <p>추가 상세 정보가 없습니다.</p>
    <%
        }
    } catch (Exception e) {
    %>
    <p>추가 상세 정보 파싱 중 오류 발생.</p>
    <%
        }
    } else {
    %>
    <p>추가 상세 정보가 없습니다.</p>
    <%
        }
    %>
</div>
