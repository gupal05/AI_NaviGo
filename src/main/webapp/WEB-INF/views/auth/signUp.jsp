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

        .signup-container {
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

        .signup-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, var(--primary-color), #9f7aea);
        }

        .signup-header {
            text-align: center;
            margin-bottom: 36px;
        }

        .signup-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 8px;
            background: linear-gradient(to right, var(--primary-color), #9f7aea);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -0.5px;
        }

        .signup-subtitle {
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

        .btn.disabled {
            opacity: 0.7;
            cursor: not-allowed;
            pointer-events: none;
        }

        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%23333' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 20px center;
            padding-right: 40px;
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

        .form-control:disabled {
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
            .signup-container {
                padding: 32px 24px;
                border-radius: 12px;
            }

            .form-control, .btn {
                height: 50px;
            }

            .signup-title {
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
    <div class="signup-container">
        <div class="signup-header">
            <h1 class="signup-title">회원가입</h1>
            <p class="signup-subtitle">새로운 계정을 만들어 서비스를 이용하세요</p>
        </div>

        <form action="/auth/signResult" method="post" id="signup-form">
            <div class="form-group">
                <label for="member_name" class="form-label">이름</label>
                <input type="text" class="form-control" id="member_name" name="memberName" placeholder="이름을 입력하세요" required>
            </div>

            <div class="form-group">
                <label for="member_id" class="form-label">아이디</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="member_id" name="memberId" placeholder="아이디를 입력하세요" required>
                    <input type="hidden" id="hidden_member_id" name="memberId">
                    <button type="button" class="btn btn-secondary" id="checkIdBtn">중복 확인</button>
                </div>
            </div>

            <div class="form-group">
                <label for="member_pw" class="form-label">비밀번호</label>
                <input type="password" class="form-control" id="member_pw" name="memberPw" placeholder="비밀번호를 입력하세요" required>
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

            <div class="form-group">
                <label class="form-label">성별</label>
                <select class="form-control" name="memberGender">
                    <option value="M">남성</option>
                    <option value="F">여성</option>
                </select>
            </div>

            <div class="d-flex justify-content-between mt-4">
                <button type="button" class="btn btn-secondary" onclick="window.history.back()">취소</button>
                <button type="button" class="btn btn-primary" id="signup-result-btn">다음</button>
            </div>
        </form>
    </div>
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
                url: "/auth/dupCheckId",
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
