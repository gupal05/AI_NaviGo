<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>로그인</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/login.css"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
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

    .login-container {
      width: 100%;
      max-width: 420px;
      background: var(--white);
      border-radius: 16px;
      box-shadow: var(--box-shadow);
      position: relative;
      overflow: hidden;
      padding: 48px 40px;
      margin: 0 auto;
    }

    .login-container::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 5px;
      background: linear-gradient(to right, var(--primary-color), #9f7aea);
    }

    .login-header {
      text-align: center;
      margin-bottom: 36px;
    }

    .login-title {
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 8px;
      background: linear-gradient(to right, var(--primary-color), #9f7aea);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      letter-spacing: -0.5px;
    }

    .login-subtitle {
      color: var(--text-secondary);
      font-size: 15px;
      font-weight: 400;
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
      padding: 0 20px 0 48px;
      font-size: 15px;
      color: var(--text-primary);
      transition: all 0.3s ease;
      width: 100%;
    }

    .form-control:focus {
      background-color: var(--white);
      border-color: var(--primary-color);
      box-shadow: 0 0 0 4px rgba(84, 104, 255, 0.1);
      outline: none;
    }

    .form-control::placeholder {
      color: #94a3b8;
    }

    .input-icon {
      position: absolute;
      left: 16px;
      top: 44px;
      color: #94a3b8;
      font-size: 16px;
      pointer-events: none;
      transition: all 0.3s ease;
    }

    .form-control:focus + .input-icon {
      color: var(--primary-color);
    }

    .password-toggle {
      position: absolute;
      right: 16px;
      top: 44px;
      color: #94a3b8;
      cursor: pointer;
      z-index: 10;
      transition: all 0.2s ease;
    }

    .password-toggle:hover {
      color: var(--text-primary);
    }

    .form-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
    }

    .forgot-link {
      font-size: 14px;
      font-weight: 500;
      color: var(--primary-color);
      text-decoration: none;
      transition: all 0.2s ease;
    }

    .forgot-link:hover {
      opacity: 0.8;
      text-decoration: underline;
    }

    .btn {
      position: relative;
      height: 54px;
      font-weight: 600;
      font-size: 15px;
      border-radius: 12px;
      letter-spacing: 0.3px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
      overflow: hidden;
    }

    .btn-primary {
      background: linear-gradient(to right, var(--primary-color), #6977ff);
      border: none;
      color: white;
    }

    .btn-primary::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(to right, transparent, rgba(255,255,255,0.2), transparent);
      transition: all 0.6s ease;
    }

    .btn-primary:hover {
      background: linear-gradient(to right, #4a59e5, #5c6aff);
      transform: translateY(-2px);
      box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25);
    }

    .btn-primary:hover::before {
      left: 100%;
    }

    .btn-primary:active {
      transform: translateY(0);
    }

    .divider {
      position: relative;
      text-align: center;
      margin: 28px 0;
      color: var(--text-secondary);
      font-size: 14px;
      font-weight: 500;
    }

    .divider::before,
    .divider::after {
      content: "";
      position: absolute;
      top: 50%;
      width: calc(50% - 20px);
      height: 1px;
      background-color: var(--border-color);
    }

    .divider::before {
      left: 0;
    }

    .divider::after {
      right: 0;
    }

    .social-button {
      height: 54px;
      border: 1px solid var(--border-color);
      background-color: var(--white);
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 500;
      color: var(--text-primary);
      margin-bottom: 16px;
      transition: all 0.3s ease;
    }

    .social-button:hover {
      background-color: var(--secondary-color);
      border-color: #d1d7ed;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    .social-button img {
      width: 22px;
      height: 22px;
      margin-right: 12px;
    }

    .btn-signup {
      background-color: var(--secondary-color);
      color: var(--primary-color);
      font-weight: 600;
      border: none;
    }

    .btn-signup:hover {
      background-color: #ebeffe;
      color: var(--primary-hover);
    }

    .login-footer {
      text-align: center;
      margin-top: 32px;
      font-size: 13px;
      color: var(--text-secondary);
    }

    /* Animation effects */
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .login-container {
      animation: fadeIn 0.5s ease-out;
    }

    /* Focus state indicators */
    .input-group.focused {
      transform: scale(1.01);
    }

    /* Progress indicator for login button */
    .btn .spinner {
      display: none;
      width: 20px;
      height: 20px;
      border: 2px solid rgba(255,255,255,0.3);
      border-top-color: white;
      border-radius: 50%;
      margin-right: 8px;
      animation: rotate 1s linear infinite;
    }

    @keyframes rotate {
      to { transform: rotate(360deg); }
    }

    .btn.loading .spinner {
      display: block;
    }

    /* Responsive styles */
    @media (max-width: 576px) {
      .login-container {
        padding: 32px 24px;
        border-radius: 12px;
      }

      .form-control {
        height: 50px;
      }

      .btn {
        height: 50px;
      }

      .login-title {
        font-size: 22px;
      }
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/nav.jsp" />

<div class="page-wrapper">
  <div class="login-container">
    <!-- 알림 메시지가 있는 경우 -->
    <c:if test="${not empty loginMessage}">
      <script>
        alert("${loginMessage}");
      </script>
    </c:if>

    <div class="login-header">
      <h1 class="login-title">환영합니다</h1>
      <p class="login-subtitle">계정에 로그인하여 서비스를 이용하세요</p>
    </div>

    <form action="/auth/sign_in" method="post" id="login-form">
      <div class="form-group">
        <label for="id" class="form-label">아이디</label>
        <input type="text" class="form-control" id="id" name="memberId" placeholder="아이디를 입력하세요" required>
        <i class="fas fa-user input-icon"></i>
      </div>

      <div class="form-group">
        <label for="password" class="form-label">비밀번호</label>
        <input type="password" class="form-control" id="password" name="memberPw" placeholder="비밀번호를 입력하세요" required>
        <i class="fas fa-lock input-icon"></i>
        <span class="password-toggle" id="togglePassword">
          <i class="far fa-eye"></i>
        </span>
      </div>

      <div class="form-footer">
        <a href="/auth/findId" class="forgot-link">아이디 찾기</a>
        <a href="/auth/findPw" class="forgot-link">비밀번호 찾기</a>
      </div>

      <button type="button" id="login-btn" class="btn btn-primary w-100">
        <span class="spinner"></span>
        로그인
      </button>
    </form>

    <div class="divider">또는</div>

    <!-- 구글 로그인 버튼 -->
    <a href="/oauth2/authorization/google" class="social-button w-100">
      <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Logo">
      <span>Google 계정으로 계속하기</span>
    </a>

    <!-- 회원가입 버튼 -->
    <a href="/auth/signUp" class="btn btn-signup w-100">
      새 계정 만들기
    </a>

    <div class="login-footer">
      로그인하면 이용약관 및 개인정보 보호정책에 동의하게 됩니다
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
  $(document).ready(function() {
    // 기존 로그인 기능 유지
    $("#login-btn").click(function() {
      let userId = $("#id");
      let userPw = $("#password");
      let loginBtn = $(this);

      if (userId.val().trim() === "") {
        alert("아이디를 입력해주세요.");
        userId.focus();
        return;
      } else if(userPw.val().trim() === ""){
        alert("비밀번호를 입력해주세요.");
        userPw.focus();
        return;
      }

      // 로딩 상태 표시
      loginBtn.addClass('loading');

      $.ajax({
        type: "POST",
        url: "/auth/isLogin",
        data: {
          [userId.attr("name")]: userId.val(),
          [userPw.attr("name")]: userPw.val()
        },
        success: function(response) {
          if (response === 'ok') {
            $("#login-form").submit();
          } else {
            alert(response);
            userId.val('');
            userPw.val('');
            loginBtn.removeClass('loading');
          }
        },
        error: function(xhr, status, error) {
          console.error("AJAX 오류:", error);
          loginBtn.removeClass('loading');
        }
      });
    });

    // 비밀번호 보기/숨기기 토글 기능
    $("#togglePassword").click(function() {
      const passwordField = $("#password");
      const passwordIcon = $(this).find("i");

      if (passwordField.attr("type") === "password") {
        passwordField.attr("type", "text");
        passwordIcon.removeClass("fa-eye").addClass("fa-eye-slash");
      } else {
        passwordField.attr("type", "password");
        passwordIcon.removeClass("fa-eye-slash").addClass("fa-eye");
      }
    });

    // 입력 필드 포커스 효과
    $(".form-control").focus(function() {
      $(this).parent().addClass("focused");
    }).blur(function() {
      $(this).parent().removeClass("focused");
    });

    // 엔터키로 로그인
    $("input").keypress(function(e) {
      if (e.which === 13) {
        $("#login-btn").click();
        return false;
      }
    });
  });
</script>
</body>
</html>