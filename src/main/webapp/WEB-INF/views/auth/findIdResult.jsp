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

    .result-container {
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

    .result-container::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 5px;
      background: linear-gradient(to right, var(--primary-color), #9f7aea);
    }

    .result-header {
      text-align: center;
      margin-bottom: 36px;
    }

    .result-title {
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 8px;
      background: linear-gradient(to right, var(--primary-color), #9f7aea);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      letter-spacing: -0.5px;
    }

    .result-message {
      color: var(--text-primary);
      font-size: 18px;
      font-weight: 500;
      margin-bottom: 32px;
      text-align: center;
      line-height: 1.6;
    }

    .result-message strong {
      color: var(--primary-color);
      font-weight: 700;
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
      width: 100%;
      max-width: 320px;
      margin: 0 auto;
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

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 576px) {
      .result-container {
        padding: 32px 24px;
        border-radius: 12px;
      }

      .result-title {
        font-size: 22px;
      }

      .result-message {
        font-size: 16px;
      }

      .btn {
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
  <div class="result-container">
    <div class="result-header">
      <h1 class="result-title">아이디 찾기 결과</h1>
    </div>

    <c:choose>
      <c:when test="${not empty memberId}">
        <p class="result-message">
          찾으신 아이디는 <strong>${memberId}</strong> 입니다.
        </p>
        <button type="button" class="btn btn-primary" onclick="window.location.href='/auth/login'">
          로그인하러 가기
        </button>
      </c:when>
      <c:otherwise>
        <p class="result-message">
          해당 정보로 가입된 계정을 찾을 수 없습니다.
        </p>
        <button type="button" class="btn btn-secondary" onclick="window.location.href='/auth/signUp'">
          회원가입하러 가기
        </button>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>