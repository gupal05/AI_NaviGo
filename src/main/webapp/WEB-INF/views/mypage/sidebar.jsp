<%--
  Created by IntelliJ IDEA.
  User: human-15
  Date: 25. 2. 24.
  Time: 오후 1:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- sidebar.jsp -->
<div class="sidebar">
  <ul class="nav flex-column">
    <li class="nav-item">
      <form action="/mypage/history" method="post">
        <button type="submit" class="nav-link">나의 여행 일정</button>
      </form>
    </li>
    <li class="nav-item">
      <form action="/mypage/changePw" method="post">
        <button type="submit" class="nav-link">비밀번호 변경</button>
      </form>
    </li>
    <li class="nav-item">
      <form action="/mypage/preference" method="post">
        <button type="submit" class="nav-link">여행 취향 수정</button>
      </form>
    </li>
  </ul>
</div>

<style>
  .sidebar {
    flex: 0 0 220px;
    background: var(--white);
    border-radius: 16px;
    padding: 25px;
    box-shadow: var(--box-shadow);
    height: fit-content;
    position: relative;
    overflow: hidden;
  }

  .sidebar::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 5px;
    background: linear-gradient(to right, var(--primary-color), #9f7aea);
  }

  .sidebar .nav-item {
    margin-bottom: 12px;
  }

  .sidebar button.nav-link {
    cursor: pointer;
    font-size: 15px;
    padding: 16px 20px;
    color: var(--text-primary) !important;
    display: block;
    text-decoration: none;
    transition: all 0.3s ease;
    background: var(--secondary-color);
    border: none;
    width: 100%;
    text-align: left;
    border-radius: 12px;
    font-weight: 600;
  }

  .sidebar button.nav-link:hover,
  .sidebar button.nav-link:active {
    background: linear-gradient(to right, var(--primary-color), #6977ff) !important;
    color: white !important;
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25);
  }

  .sidebar button.nav-link.active {
    background: linear-gradient(to right, var(--primary-color), #6977ff) !important;
    color: white !important;
    box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25);
  }

  @media (max-width: 768px) {
    .sidebar {
      flex: none;
      width: 100%;
    }

    .sidebar button.nav-link:hover {
      transform: none;
    }
  }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    // 현재 URL에 따라 해당하는 메뉴 활성화
    const currentPath = window.location.pathname;
    const buttons = document.querySelectorAll('.sidebar button.nav-link');

    buttons.forEach(button => {
      const form = button.closest('form');
      if (form && form.action.includes(currentPath)) {
        button.classList.add('active');
      }

      // 클릭 시 로딩 표시 추가
      button.addEventListener('click', function() {
        this.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Loading...';
      });
    });
  });
</script>
