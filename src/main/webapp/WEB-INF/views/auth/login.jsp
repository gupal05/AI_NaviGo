<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/login.css"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    .google-btn {
      background-color: white;
      border: 2px solid #ccc;
      color: black;
    }
    .google-btn:hover {
      border-color: #888;
    }
    .custom-divider {
      margin: 8px 0;
    }
    .sign-up-divider {
      margin: 24px 0;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/nav.jsp" />

<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <!-- 알림 메시지가 있는 경우 -->
      <c:if test="${not empty loginMessage}">
        <script>
          alert("${loginMessage}");
        </script>
      </c:if>
      <h2 class="text-center">로그인</h2>
      <form action="/auth/sign_in" method="post" id="login-form">
        <div class="mb-3">
          <label for="id" class="form-label">ID</label>
          <input type="text" class="form-control" id="id" name="memberId" required>
        </div>
        <div class="mb-3">
          <label for="password" class="form-label">Password</label>
          <input type="password" class="form-control" id="password" name="memberPw" required>
        </div>
        <button type="button" id="login-btn" class="btn btn-primary w-100">Login</button>
      </form>

      <!-- ID/PW 찾기 버튼 (가운데 정렬) -->
      <div class="d-flex justify-content-center mt-2">
        <button type="button" class="btn btn-outline-secondary btn-sm mx-1" onclick="location.href='/auth/findId'">Find ID</button>
        <button type="button" class="btn btn-outline-secondary btn-sm mx-1" onclick="location.href='/auth/findPw'">Find PW</button>
      </div>

      <!-- 구분선 -->
      <div class="text-center custom-divider mt-3">or</div>

      <!-- 구글 로그인 버튼 -->
      <a href="/oauth2/authorization/google" class="btn google-btn w-100 mt-2">
        <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Logo" style="width: 20px; margin-right: 10px;"> Google Login
      </a>

      <!-- 회원가입 버튼 -->
      <div class="text-center mt-3">
        <a href="/auth/signUp" class="btn btn-secondary w-100">Sign Up</a>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
  $(document).ready(function() {
    $("#login-btn").click(function() {
      let userId = $("#id");
      let userPw = $("#password");

      if (userId.val().trim() === "") {
        alert("아이디를 입력해주세요.");
        return;
      } else if(userPw.val().trim() === ""){
        alert("비밀번호를 입력해주세요.");
        return;
      }

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
          }
        },
        error: function(xhr, status, error) {
          console.error("AJAX 오류:", error);
        }
      });
    });
  });
</script>
</body>
</html>
