<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>아이디 찾기 - AI NaviGo</title>
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
  </style>
</head>
<body>
<header id="top-header">
  <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<div class="container">
  <h2 class="text-center">아이디 찾기</h2>
  <form action="/auth/findIdResult" method="post" id="find-id-form">
    <div class="form-group">
      <label for="member_name" class="form-label">이름</label>
      <input type="text" class="form-control" id="member_name" name="memberName" required>
    </div>

    <!-- 이메일 입력 및 인증 -->
    <div class="form-group">
      <label for="member_email" class="form-label">이메일</label>
      <div class="input-group">
        <input type="email" class="form-control" id="member_email" name="memberEmail" required>
        <button type="button" class="btn btn-secondary" id="sendCodeBtn">인증번호 전송</button>
      </div>
    </div>
    <div class="form-group" id="verificationGroup" style="display: none;">
      <label for="verification_code" class="form-label">인증번호</label>
      <div class="input-group">
        <input type="text" class="form-control" id="verification_code" name="verificationCode">
        <button type="button" class="btn btn-primary" id="verifyCodeBtn">확인</button>
      </div>
    </div>

    <div class="d-flex justify-content-between mt-4">
      <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
      <button type="button" class="btn btn-primary" id="find-id-result-btn">아이디 찾기</button>
    </div>
  </form>
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
    $("#find-id-result-btn").click(function() {
      var name = $("#member_name").val().trim();
      var email = $("#member_email").val().trim();
      var code = $("#verification_code").val().trim();
      var btn = $("#verifyCodeBtn");
      var form = $("#find-id-form");

      // 이름 검증
      if (!name) {
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
