<%--
  Created by IntelliJ IDEA.
  User: Moon yebin
  Date: 25. 2. 4.
  Time: 오후 2:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>updateForm</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <style>
    .container {
      margin: 40px auto;
      padding: 20px;
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .form-label {
      font-weight: bold;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .content {
      display: flex;
      justify-content: center;
      padding-left: 30px;
    }
  </style>
</head>

<body>

<div class="container">
  <form action="/update-profile" method="POST">
    <h2>비밀번호 변경</h2>
<%--    session 객체 확인용--%>
    <c:forEach items="${sessionScope}" var="entry">
      <p>${entry.key}: ${entry.value}</p>
    </c:forEach>
    <div class="form-group">
      <label for="member_pw" class="form-label">현재 비밀번호</label>
      <input type="password" class="form-control" id="member_pw" name="memberPw"
<%--             value="${sessionScope.memberInfo.memberPw}"--%> required>
    </div>
    <div class="form-group">
      <label for="member_pw" class="form-label">새 비밀번호</label>
      <input type="password" class="form-control" id="new_member_pw" name="memberPw"
      <%--             value="${sessionScope.memberInfo.memberPw}"--%> required>
    </div>
    <div class="form-group">
      <label for="member_pw" class="form-label">새 비밀번호 확인</label>
      <input type="password" class="form-control" id="new_member_pw_check" name="memberPw"
      <%--             value="${sessionScope.memberInfo.memberPw}"--%> required>
    </div>

<%--    <div class="form-group">--%>
<%--      <label for="member_email" class="form-label">이메일</label>--%>
<%--      <input type="email" class="form-control" id="member_email" name="memberEmail"--%>
<%--             value="${sessionScope.memberInfo.memberEmail}" disabled>--%>
<%--    </div>--%>

<%--    <div class="form-group" id="verificationGroup" style="display: none;">--%>
<%--      <label for="verification_code" class="form-label">인증번호</label>--%>
<%--      <div class="input-group">--%>
<%--        <input type="text" class="form-control" id="verification_code" name="verificationCode">--%>
<%--        <button type="button" class="btn btn-primary" id="verifyCodeBtn">확인</button>--%>
<%--      </div>--%>
<%--    </div>--%>


    <div class="d-flex justify-content-between mt-4">
      <button type="button" class="btn btn-primary" id="❤❤❤❤">변경하기</button>
    </div>
  </form>
</div>






<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>