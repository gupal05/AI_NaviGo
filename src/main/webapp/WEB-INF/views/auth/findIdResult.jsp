<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>아이디 찾기 결과 - AI NaviGo</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <style>
    .container {
      max-width: 500px;
      margin: 40px auto;
      padding: 20px;
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .form-group {
      margin-bottom: 15px;
    }
    .btn-custom {
      width: 100%;
    }
    .result-text {
      font-size: 1.2rem;
      margin-bottom: 20px;
    }
  </style>
</head>
<body>
<header id="top-header">
  <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="container">
  <c:choose>
    <c:when test="${not empty memberId}">
      <h2 class="text-center">아이디 찾기 결과</h2>
      <p class="result-text text-center">찾으신 아이디는 <strong>${memberId}</strong> 입니다.</p>
      <div class="d-flex justify-content-center">
        <button type="button" class="btn btn-primary btn-custom" onclick="window.location.href='/auth/login'">로그인</button>
      </div>
    </c:when>
    <c:otherwise>
      <h2 class="text-center">아이디 찾기 결과</h2>
      <p class="result-text text-center">해당 정보로 가입된 계정이 없습니다.</p>
      <div class="d-flex justify-content-center">
        <button type="button" class="btn btn-secondary btn-custom" onclick="window.location.href='/auth/signUp'">회원가입</button>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>