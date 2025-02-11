<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<div class="info-box">
    <h3>추가 상세 정보 (관광지)</h3>
    <%
        String detailStr = (String) request.getAttribute("detail");
        if (detailStr != null && !"Detail 정보 없음".equals(detailStr)) {
            try {
                JSONArray detailArray = new JSONArray(detailStr);
                if (detailArray.length() > 0) {
                    JSONObject detailItem = detailArray.getJSONObject(0);
                    String expguide = detailItem.optString("expguide", "").trim();
                    String restdate = detailItem.optString("restdate", "").trim();
                    String infocenter = detailItem.optString("infocenter", "").trim();
                    String chkbabycarriage = detailItem.optString("chkbabycarriage", "").trim();
                    String usetime = detailItem.optString("usetime", "").trim();
                    String parking = detailItem.optString("parking", "").trim();

                    if (!expguide.isEmpty()) {
    %>
    <p><strong>이용안내:</strong> <%= expguide %></p>
    <%
        }
        if (!restdate.isEmpty()) {
    %>
    <p><strong>쉬는날:</strong> <%= restdate %></p>
    <%
        }
        if (!infocenter.isEmpty()) {
    %>
    <p><strong>문의처:</strong> <%= infocenter %></p>
    <%
        }
        if (!chkbabycarriage.isEmpty()) {
    %>
    <p><strong>유모차 대여:</strong> <%= chkbabycarriage %></p>
    <%
        }
        if (!usetime.isEmpty()) {
    %>
    <p><strong>이용시간:</strong> <%= usetime %></p>
    <%
        }
        if (!parking.isEmpty()) {
    %>
    <p><strong>주차시설:</strong> <%= parking %></p>
    <%
        }
        if(expguide.isEmpty() && restdate.isEmpty() && infocenter.isEmpty()
                && chkbabycarriage.isEmpty() && usetime.isEmpty() && parking.isEmpty()){
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
