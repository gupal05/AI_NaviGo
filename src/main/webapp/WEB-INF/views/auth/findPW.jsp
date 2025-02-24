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

    .findpw-container {
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

    .findpw-container::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 5px;
      background: linear-gradient(to right, var(--primary-color), #9f7aea);
    }

    .findpw-header {
      text-align: center;
      margin-bottom: 36px;
    }

    .findpw-title {
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 8px;
      background: linear-gradient(to right, var(--primary-color), #9f7aea);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      letter-spacing: -0.5px;
    }

    .findpw-subtitle {
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
      padding: 0 20px;
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

    .input-group {
      display: flex;
      gap: 10px;
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

    #verificationGroup {
      display: none;
      animation: slideDown 0.3s ease-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes slideDown {
      from { opacity: 0; transform: translateY(-10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .form-control:disabled, .form-control[readonly] {
      background-color: #f1f5f9;
      color: #64748b;
      cursor: not-allowed;
    }

    .btn:disabled {
      background: #e2e8f0;
      color: #94a3b8;
      cursor: not-allowed;
      transform: none !important;
      box-shadow: none !important;
    }

    @media (max-width: 576px) {
      .findpw-container {
        padding: 32px 24px;
        border-radius: 12px;
      }

      .form-control, .btn {
        height: 50px;
      }

      .findpw-title {
        font-size: 22px;
      }
    }
  </style>
</head>
<body>
<header id="top-header">
  <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="page-wrapper">
  <div class="findpw-container">
    <div class="findpw-header">
      <h1 class="findpw-title">비밀번호 찾기</h1>
      <p class="findpw-subtitle">가입하신 아이디와 이메일로 비밀번호를 찾을 수 있습니다</p>
    </div>

    <form action="/auth/findPwResult" method="post" id="find-pw-form">
      <div class="form-group">
        <label for="member_id" class="form-label">아이디</label>
        <input type="text" class="form-control" id="member_id" name="memberId" placeholder="아이디를 입력하세요" required>
      </div>

      <div class="form-group">
        <label for="member_email" class="form-label">이메일</label>
        <div class="input-group">
          <input type="email" class="form-control" id="member_email" name="memberEmail" placeholder="이메일을 입력하세요" required>
          <button type="button" class="btn btn-secondary" id="sendCodeBtn">인증번호 전송</button>
        </div>
      </div>

      <div class="form-group" id="verificationGroup">
        <label for="verification_code" class="form-label">인증번호</label>
        <div class="input-group">
          <input type="text" class="form-control" id="verification_code" name="verificationCode" placeholder="인증번호를 입력하세요">
          <button type="button" class="btn btn-secondary" id="verifyCodeBtn">확인</button>
        </div>
      </div>

      <div class="d-flex justify-content-between mt-4">
        <button type="button" class="btn btn-secondary" onclick="window.history.back()">취소</button>
        <button type="button" class="btn btn-primary" id="find-pw-result-btn">비밀번호 찾기</button>
      </div>
    </form>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
  $(document).ready(function() {
    $("#sendCodeBtn").click(function() {
      var memberEmail = $("#member_email");
      if(memberEmail.val() === ""){
        alert("이메일을 입력 해주세요");
        memberEmail.focus();
      }else{
        $.ajax({
          type: "POST",
          url: "/auth/mailAuth",
          data: { memberEmail: memberEmail.val() },
          success: function(response) {
            alert(response);
            if(response === "인증번호가 전송 되었습니다."){
              $("#verificationGroup").show(); // 인증번호 전송 버튼 클릭시 인증번호 입력칸 block
              $("#sendCodeBtn").prop("disabled", true);
              memberEmail.attr("readonly", true);
            } else{
              memberEmail.val("");
            }
          },
          error: function(xhr, status, error) {
            console.error("AJAX 오류:", error);
          }
        });
      }
    });
  });

  // 인증번호 일치 여부 확인
  $(document).ready(function() {
    $("#verifyCodeBtn").click(function() { // "인증번호 전송" 버튼 클릭 시 실행
      var code = $("#verification_code"); // 입력된 email 값 가져오기
      $.ajax({
        type: "POST",
        url: "/auth/mailAuth/result",
        data: { mailCode: code.val() },
        success: function(response) {
          alert(response);
          if(response === "인증 되었습니다."){
            $("#verifyCodeBtn").prop("disabled", true);
            code.attr("readonly", true);
          } else{
            code.val("");
          }
        },
        error: function(xhr, status, error) {
          console.error("AJAX 오류:", error);
        }
      });
    });
  });

  // 인증번호 일치 여부 확인
  $(document).ready(function() {
    $("#find-pw-result-btn").click(function() {
      var id = $("#member_id").val().trim();
      var email = $("#member_email").val().trim();
      var code = $("#verification_code").val().trim();
      var btn = $("#verifyCodeBtn");
      var form = $("#find-pw-form");

      // 이름 검증
      if (!id) {
        alert("필수 입력창 입니다.");
        $("#member_name").focus();
        return;
      }

      // 이메일 검증
      if (!email) {
        alert("필수 입력창 입니다.");
        $("#member_email").focus();
        return;
      }

      // 인증코드 검증
      if (!code) {
        alert("필수 입력창 입니다.");
        $("#verification_code").focus();
        return;
      }

      // 인증번호 확인 버튼 검증
      if (!btn.prop('disabled')) {
        alert("인증번호 확인을 해주세요.");
        btn.focus();
        return;
      }

      // 모든 검증 통과 시 폼 제출
      form.submit();
    });
  });
</script>
</body>
</html>
