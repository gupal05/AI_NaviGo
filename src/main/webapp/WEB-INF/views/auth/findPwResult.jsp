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
    :root {
      --primary-color: #5468ff;
      --primary-hover: #4152e3;
      --secondary-color: #f6f8ff;
      --text-primary: #2c3256;
      --text-secondary: #6b7280;
      --border-color: #e2e8f0;
      --success-color: #10b981;
      --error-color: #ef4444;
      --white: #ffffff;
      --box-shadow: 0 10px 30px rgba(84, 104, 255, 0.08);
      --font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, sans-serif;
    }

    body {
      background: linear-gradient(135deg, #f8faff 0%, #f0f4ff 100%);
      font-family: var(--font-family);
      color: var(--text-primary);
      min-height: 100vh;
    }

    .page-wrapper {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: calc(100vh - 180px);
      padding: 40px 20px;
    }

    .resetpw-container {
      width: 100%;
      max-width: 520px;
      background: var(--white);
      border-radius: 16px;
      box-shadow: var(--box-shadow);
      position: relative;
      overflow: hidden;
      padding: 48px 40px;
      margin: 0 auto;
      animation: fadeIn 0.5s ease-out;
    }

    .resetpw-container::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 5px;
      background: linear-gradient(to right, var(--primary-color), #9f7aea);
    }

    .resetpw-header {
      text-align: center;
      margin-bottom: 36px;
    }

    .resetpw-title {
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 8px;
      background: linear-gradient(to right, var(--primary-color), #9f7aea);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      letter-spacing: -0.5px;
    }

    .alert {
      padding: 16px;
      border-radius: 12px;
      margin-bottom: 24px;
      font-size: 15px;
      animation: slideDown 0.3s ease-out;
    }

    .alert-danger {
      background-color: #fef2f2;
      color: var(--error-color);
      border: 1px solid #fee2e2;
    }

    #signup-btn-group {
      text-align: center;
      margin-top: 24px;
    }

    .form-group {
      margin-bottom: 24px;
      position: relative;
    }

    .form-label {
      font-size: 14px;
      font-weight: 600;
      color: var(--text-primary);
      margin-bottom: 8px;
      display: block;
    }

    .form-control {
      height: 54px;
      background-color: #f9fafb;
      border: 1px solid var(--border-color);
      border-radius: 12px;
      padding: 0 20px;
      font-size: 15px;
      color: var(--text-primary);
      transition: all 0.3s ease;
    }

    .form-control:focus {
      background-color: var(--white);
      border-color: var(--primary-color);
      box-shadow: 0 0 0 4px rgba(84, 104, 255, 0.1);
      outline: none;
    }

    .error-message {
      color: var(--error-color);
      font-size: 13px;
      margin-top: 6px;
      display: none;
      animation: fadeIn 0.2s ease-out;
    }

    .valid-input {
      border-color: var(--success-color) !important;
    }

    .btn {
      height: 54px;
      font-weight: 600;
      font-size: 15px;
      border-radius: 12px;
      letter-spacing: 0.3px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
      padding: 0 24px;
    }

    .btn-secondary {
      background-color: var(--secondary-color);
      color: var(--primary-color);
      border: none;
    }

    .btn-secondary:hover {
      background-color: #ebeffe;
      color: var(--primary-hover);
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    .btn-primary {
      background: linear-gradient(to right, var(--primary-color), #6977ff);
      border: none;
      color: white;
    }

    .btn-primary:hover {
      background: linear-gradient(to right, #4a59e5, #5c6aff);
      transform: translateY(-2px);
      box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25);
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes slideDown {
      from { opacity: 0; transform: translateY(-10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 576px) {
      .resetpw-container {
        padding: 32px 24px;
        border-radius: 12px;
      }

      .resetpw-title {
        font-size: 22px;
      }

      .form-control, .btn {
        height: 50px;
      }
    }
  </style>
</head>
<body>
<header id="top-header">
  <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="page-wrapper">
  <div class="resetpw-container">
    <div class="resetpw-header">
      <h1 class="resetpw-title">비밀번호 재설정</h1>
    </div>

    <!-- memberId가 null이거나 값이 없을 때 처리 -->
    <c:if test="${empty memberId}">
      <div class="alert alert-danger">
        존재하지 않는 계정입니다.
      </div>
      <div id="signup-btn-group">
        <form action="/auth/signUp" method="get">
          <button type="submit" class="btn btn-primary">회원가입</button>
        </form>
      </div>
    </c:if>

    <!-- memberId가 존재할 때 비밀번호 변경 폼 -->
    <c:if test="${not empty memberId}">
      <form action="/auth/login" method="get" id="change-password-form">
        <input type="hidden" name="memberId" id="memId" value="${memberId}">

        <div class="form-group">
          <label for="new_password" class="form-label">새로운 비밀번호</label>
          <input type="password" class="form-control" id="new_password" name="memberPw" placeholder="새로운 비밀번호를 입력하세요" required>
        </div>

        <div class="form-group">
          <label for="confirm_password" class="form-label">새로운 비밀번호 확인</label>
          <input type="password" class="form-control" id="confirm_password" name="confirmPassword" placeholder="비밀번호를 다시 입력하세요" required onblur="checkPasswordMatch()">
          <div id="password-error-message" class="error-message">비밀번호가 일치하지 않습니다</div>
        </div>

        <div class="d-flex justify-content-between mt-4">
          <button type="button" class="btn btn-secondary" onclick="window.history.back()">취소</button>
          <button type="button" class="btn btn-primary" id="change-password-btn">비밀번호 변경</button>
        </div>
      </form>
      <form action="/auth/findPw" method="get" id="fail-form"></form>
    </c:if>
  </div>
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
<!-- chatbot 포함 -->
<jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />
</body>
</html>
