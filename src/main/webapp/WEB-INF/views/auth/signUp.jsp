<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>회원가입 - AI NaviGo</title>
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
    <h2 class="text-center">회원가입</h2>
    <form action="/signResult" method="post" id="signup-form">
        <div class="form-group">
            <label for="member_name" class="form-label">이름</label>
            <input type="text" class="form-control" id="member_name" name="memberName" required>
        </div>
        <div class="form-group">
            <label for="member_id" class="form-label">아이디</label>
            <div class="input-group">
                <input type="text" class="form-control" id="member_id" name="memberId" required>
                <input type="hidden" id="hidden_member_id" name="memberId">
                <button type="button" class="btn btn-secondary" id="checkIdBtn">중복 확인</button>
            </div>
        </div>
        <div class="form-group">
            <label for="member_pw" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="member_pw" name="memberPw" required>
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

        <div class="form-group">
            <label class="form-label">성별</label>
            <select class="form-control" name="memberGender">
                <option value="M">남성</option>
                <option value="F">여성</option>
            </select>
        </div>
        <div class="d-flex justify-content-between mt-4">
            <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
            <button type="button" class="btn btn-primary" id="signup-result-btn">Next</button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    //아이디 중복 확인을 위한 function
    $(document).ready(function() {
        $("#checkIdBtn").click(function() { // "중복 확인" 버튼 클릭 시 실행
            var userId = $("#member_id").val(); // 입력된 ID 값 가져오기

            if (userId.trim() === "") {
                alert("아이디를 입력해주세요.");
                return;
            }
            $.ajax({
                type: "POST",
                url: "/dupCheckId",
                data: { id: userId },
                success: function(response) {
                    if (response === '사용 가능한 ID 입니다.') {
                        // 입력창과 버튼을 비활성화
                        $("#member_id").prop("disabled", true);
                        $("#checkIdBtn").prop("disabled", true);
                        $("#hidden_member_id").val(userId); // hidden input에 값 설정
                        alert(response); // 사용 가능 메시지 출력
                    } else {
                        // 입력창을 비우기
                        $("#member_id").val("");
                        alert("사용할 수 없는 ID입니다. 다시 입력해주세요.");
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX 오류:", error);
                }
            });
        });
    });

    // 이메일 인증번호 전송
    $(document).ready(function() {
        $("#sendCodeBtn").click(function() { // "인증번호 전송" 버튼 클릭 시 실행
            var memberEmail = $("#member_email"); // 입력된 email 값 가져오기
            $.ajax({
                type: "POST",
                url: "/signUp/mailAuth",
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
        });
    });

    // 인증번호 일치 여부 확인
    $(document).ready(function() {
        $("#verifyCodeBtn").click(function() { // "인증번호 전송" 버튼 클릭 시 실행
            var code = $("#verification_code"); // 입력된 email 값 가져오기
            $.ajax({
                type: "POST",
                url: "/signUp/mailAuth/result",
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
        $("#signup-result-btn").click(function() {
            var id = $("#member_id").val().trim();
            var pw = $("#member_pw").val().trim();
            var name = $("#member_name").val().trim();
            var email = $("#member_email").val().trim();
            var code = $("#verification_code").val().trim();
            var btn = $("#verifyCodeBtn");
            var form = $("#signup-form");

            // ID 검증
            if (!id) {
                alert("필수 입력창 입니다.");
                $("#member_id").focus();
                return;
            }

            // 비밀번호 검증
            if (!pw) {
                alert("필수 입력창 입니다.");
                $("#member_pw").focus();
                return;
            }

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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
