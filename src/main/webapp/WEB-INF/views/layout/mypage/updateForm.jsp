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
<html>
<head>
  <meta charset="UTF-8">
  <title>회원 정보 수정</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="update-container">
  <h2>회원 정보 수정</h2>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/mypage/update" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

    <div class="form-group">
      <label>아이디</label>
      <input type="text" value="${member.username}" readonly>
    </div>

    <div class="form-group">
      <label>이름</label>
      <input type="text" value="${member.name}" readonly>
    </div>

    <div class="form-group">
      <label for="email">이메일</label>
      <input type="email" id="email" name="email" value="${member.email}" required>
    </div>

    <div class="form-group">
      <label for="phone">전화번호</label>
      <input type="tel" id="phone" name="phone" value="${member.phone}" required>
    </div>

    <div class="form-group">
      <label for="currentPassword">현재 비밀번호</label>
      <input type="password" id="currentPassword" name="currentPassword" required>
    </div>

    <div class="form-group">
      <label for="newPassword">새 비밀번호 (선택)</label>
      <input type="password" id="newPassword" name="newPassword">
    </div>

    <div class="form-group">
      <label for="confirmPassword">새 비밀번호 확인</label>
      <input type="password" id="confirmPassword" name="confirmPassword">
    </div>

    <div class="form-group">
      <button type="submit" class="btn-update">정보 수정</button>
    </div>
  </form>
</div>

<script>
  $(document).ready(function() {
    $('form').on('submit', function(event) {
      var newPassword = $('#newPassword').val();
      var confirmPassword = $('#confirmPassword').val();

      if (newPassword && newPassword !== confirmPassword) {
        alert('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.');
        event.preventDefault();
        return false;
      }

      return true;
    });
  });
</script>
</body>
</html>