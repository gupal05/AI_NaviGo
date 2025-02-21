<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<div class="info-box">
  <h3>추가 상세 정보 (문화시설)</h3>
  <hr class="custom-hr">
  <%
    String detailStr = (String) request.getAttribute("detail");
    if (detailStr != null && !"Detail 정보 없음".equals(detailStr)) {
      try {
        JSONArray detailArray = new JSONArray(detailStr);
        if (detailArray.length() > 0) {
          JSONObject detailItem = detailArray.getJSONObject(0);
          String restdateCulture = detailItem.optString("restdateculture", "").trim();
          String usefee = detailItem.optString("usefee", "").trim();
          String spendtimeCulture = detailItem.optString("spendtimeculture", "").trim();
          String scale = detailItem.optString("scale", "").trim();
          String infocenterCulture = detailItem.optString("infocenterculture", "").trim();

          if (!restdateCulture.isEmpty()) {
  %>
  <p><strong>쉬는날:</strong> <%= restdateCulture %></p>
  <%
    }
    if (!usefee.isEmpty()) {
  %>
  <p><strong>이용요금:</strong> <%= usefee %></p>
  <%
    }
    if (!spendtimeCulture.isEmpty()) {
  %>
  <p><strong>관람 소요시간:</strong> <%= spendtimeCulture %></p>
  <%
    }
    if (!scale.isEmpty()) {
  %>
  <p><strong>규모:</strong> <%= scale %></p>
  <%
    }
    if (!infocenterCulture.isEmpty()) {
  %>
  <p><strong>문의처:</strong> <%= infocenterCulture %></p>
  <%
    }
    if(restdateCulture.isEmpty() && usefee.isEmpty() && spendtimeCulture.isEmpty() && scale.isEmpty() && infocenterCulture.isEmpty()){
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
