<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>비밀번호 찾기 - AI NaviGo</title>
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
    .form-label {
      font-weight: bold;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .alert {
      margin-top: 20px;
    }
    .error-message {
      color: red;
      font-size: 0.875rem;
    }
    .valid-input {
      border-color: #90EE90; /* 연두색 */
    }
  </style>
</head>
<body>
<header id="top-header">
  <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="container">
  <h2 class="text-center">비밀번호 찾기</h2>

  <!-- memberId가 null이거나 값이 없을 때 처리 -->
  <c:if test="${empty memberId}">
    <div class="alert alert-danger">
      존재하지 않는 계정입니다.
    </div>
    <!-- 회원가입 버튼 -->
    <div id="signup-btn-group">
      <form action="/auth/signUp" method="get">
        <button type="submit" class="btn btn-primary">회원가입</button>
      </form>
    </div>
  </c:if>

  <!-- memberId가 존재할 때 비밀번호 변경 폼 -->
  <c:if test="${not empty memberId}">
    <form action="/auth/login" method="get" id="change-password-form">
      <!-- 비밀번호 입력창 -->
      <div class="form-group">
        <input type="hidden" name="memberId" id="memId" value="${memberId}">
        <label for="new_password" class="form-label">새로운 비밀번호</label>
        <input type="password" class="form-control" id="new_password" name="memberPw" required>
      </div>

      <!-- 비밀번호 확인 입력창 -->
      <div class="form-group">
        <label for="confirm_password" class="form-label">새로운 비밀번호 확인</label>
        <input type="password" class="form-control" id="confirm_password" name="confirmPassword" required onblur="checkPasswordMatch()">
        <div id="password-error-message" class="error-message" style="display: none;">비밀번호가 다릅니다.</div>
      </div>

      <!-- 비밀번호 변경 버튼 -->
      <div class="d-flex justify-content-between mt-4">
        <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
        <button type="button" class="btn btn-primary" id="change-password-btn">비밀번호 변경</button>
      </div>
    </form>
    <form action="/auth/findPw" method="get" id="fail-form"></form>
  </c:if>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
  function checkPasswordMatch() {
    var newPassword = document.getElementById("new_password").value;
    var confirmPassword = document.getElementById("confirm_password").value;
    var errorMessage = document.getElementById("password-error-message");
    var confirmPasswordField = document.getElementById("confirm_password");

    if (newPassword !== confirmPassword) {
      errorMessage.style.display = "block"; // 비밀번호가 다르면 메시지 표시
      confirmPasswordField.classList.remove("valid-input");
    } else {
      errorMessage.style.display = "none"; // 비밀번호가 같으면 메시지 숨김
      confirmPasswordField.classList.add("valid-input"); // 테두리를 연두색으로 변경
    }
  }

  $(document).ready(function() {
    $("#change-password-btn").click(function() {
      var newPassword = $("#new_password");
      var confirmPassword = $("#confirm_password");
      var memId = $("#memId");
      var form = $("#change-password-form");
      var fail = $("#fail-form");

      if (newPassword.val() !== confirmPassword.val()) {
        confirmPassword.val(''); // 비밀번호 확인 필드 값 초기화
        confirmPassword.focus(); // 비밀번호 확인 필드로 포커스 이동
      } else{
        $.ajax({
          type: "POST",
          url: "/auth/changePw",
          data: {
            memberPw: newPassword.val(),
            memberId: memId.val()
          },
          success: function(response) {
            alert(response);
            if(response === "비밀번호가 변경 되었습니다."){
              form.submit()
            } else{
              fail.submit();
            }
          },
          error: function(xhr, status, error) {
            console.error("AJAX 오류:", error);
          }
        });
      }
    });
  });
</script>

</body>
</html>
