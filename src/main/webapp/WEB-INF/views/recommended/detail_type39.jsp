<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<div class="info-box">
    <h3>추가 상세 정보 (음식)</h3>
    <%
        String detailStr = (String) request.getAttribute("detail");
        if (detailStr != null && !"Detail 정보 없음".equals(detailStr)) {
            try {
                JSONArray detailArray = new JSONArray(detailStr);
                if (detailArray.length() > 0) {
                    JSONObject detailItem = detailArray.getJSONObject(0);
                    String opentimefood = detailItem.optString("opentimefood", "").trim();
                    String restdatefood = detailItem.optString("restdatefood", "").trim();
                    String packing = detailItem.optString("packing", "").trim();
                    String treatmenu = detailItem.optString("treatmenu", "").trim();
                    String firstmenu = detailItem.optString("firstmenu", "").trim();
                    String infocenterfood = detailItem.optString("infocenterfood", "").trim();

                    if (!opentimefood.isEmpty()) {
    %>
    <p><strong>영업시간:</strong> <%= opentimefood %></p>
    <%
        }
        if (!restdatefood.isEmpty()) {
    %>
    <p><strong>휴무일:</strong> <%= restdatefood %></p>
    <%
        }
        if (!packing.isEmpty()) {
    %>
    <p><strong>포장 가능 여부:</strong> <%= packing %></p>
    <%
        }
        if (!treatmenu.isEmpty()) {
    %>
    <p><strong>취급 메뉴:</strong> <%= treatmenu %></p>
    <%
        }
        if (!firstmenu.isEmpty()) {
    %>
    <p><strong>대표 메뉴:</strong> <%= firstmenu %></p>
    <%
        }
        if (!infocenterfood.isEmpty()) {
    %>
    <p><strong>문의처:</strong> <%= infocenterfood %></p>
    <%
        }
        if(opentimefood.isEmpty() && restdatefood.isEmpty() && packing.isEmpty() &&
                treatmenu.isEmpty() && firstmenu.isEmpty() && infocenterfood.isEmpty()){
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
