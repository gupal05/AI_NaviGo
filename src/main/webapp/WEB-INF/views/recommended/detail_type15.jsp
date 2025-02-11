<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<div class="info-box">
    <h3>추가 상세 정보 (축제/공연/행사)</h3>
    <%
        String detailStr = (String) request.getAttribute("detail");
        if (detailStr != null && !"Detail 정보 없음".equals(detailStr)) {
            try {
                JSONArray detailArray = new JSONArray(detailStr);
                if (detailArray.length() > 0) {
                    JSONObject detailItem = detailArray.getJSONObject(0);
                    String agelimit = detailItem.optString("agelimit", "").trim();
                    String discountinfo = detailItem.optString("discountinfofestival", "").trim();
                    String eventstartdate = detailItem.optString("eventstartdate", "").trim();
                    String eventenddate = detailItem.optString("eventenddate", "").trim();
                    String eventplace = detailItem.optString("eventplace", "").trim();
                    String festivalgrade = detailItem.optString("festivalgrade", "").trim();
                    String spendtimeFestival = detailItem.optString("spendtimefestival", "").trim();
                    String playtime = detailItem.optString("playtime", "").trim();
                    String program = detailItem.optString("program", "").trim();
                    String sponser1 = detailItem.optString("sponsor1", "").trim();
                    String sponser1tel = detailItem.optString("sponsor1tel", "").trim();

                    if (!agelimit.isEmpty()) {
    %>
    <p><strong>관람가능연령:</strong> <%= agelimit %></p>
    <%
        }
        if (!discountinfo.isEmpty()) {
    %>
    <p><strong>할인정보:</strong> <%= discountinfo %></p>
    <%
        }
        if (!eventstartdate.isEmpty() || !eventenddate.isEmpty()) {
    %>
    <p><strong>행사기간:</strong> <%= eventstartdate %> ~ <%= eventenddate %></p>
    <%
        }
        if (!eventplace.isEmpty()) {
    %>
    <p><strong>행사장소:</strong> <%= eventplace %></p>
    <%
        }
        if (!festivalgrade.isEmpty()) {
    %>
    <p><strong>축제등급:</strong> <%= festivalgrade %></p>
    <%
        }
        if (!spendtimeFestival.isEmpty()) {
    %>
    <p><strong>관람 소요시간:</strong> <%= spendtimeFestival %></p>
    <%
        }
        if (!playtime.isEmpty()) {
    %>
    <p><strong>공연시간:</strong> <%= playtime %></p>
    <%
        }
        if (!program.isEmpty()) {
    %>
    <p><strong>프로그램:</strong> <%= program %></p>
    <%
        }
        if (!sponser1.isEmpty() || !sponser1tel.isEmpty()) {
    %>
    <p><strong>주최자/문의:</strong> <%= sponser1 %> <%= sponser1tel %></p>
    <%
        }
        if (agelimit.isEmpty() && discountinfo.isEmpty() && eventstartdate.isEmpty() && eventenddate.isEmpty() &&
                eventplace.isEmpty() && festivalgrade.isEmpty() && spendtimeFestival.isEmpty() &&
                playtime.isEmpty() && program.isEmpty() && sponser1.isEmpty() && sponser1tel.isEmpty()) {
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
