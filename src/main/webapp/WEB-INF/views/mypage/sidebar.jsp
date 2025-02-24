<%--
  Created by IntelliJ IDEA.
  User: human-15
  Date: 25. 2. 24.
  Time: 오후 1:21
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- sidebar.jsp -->
<div class="sidebar">
  <ul class="nav flex-column">
    <li class="nav-item">
      <form action="/mypage/history" method="post">
        <button type="submit" class="nav-link">나의 여행 일정</button>
      </form>
    </li>
    <%-- memberPw가 null일 때 비밀번호 변경 탭을 숨김 --%>
    <c:if test="${not empty memberInfo.memberPw}">
      <li class="nav-item">
        <form action="/mypage/changePw" method="post">
          <button type="submit" class="nav-link">비밀번호 변경</button>
        </form>
      </li>
    </c:if>
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

  /*!* hover와 active 상태의 스타일 *!*/
  /*.sidebar button.nav-link:hover,*/
  /*.sidebar button.nav-link:active {*/
  /*  background: linear-gradient(to right, var(--primary-color), #6977ff) !important;*/
  /*  color: white !important;*/
  /*  transform: translateY(-2px);*/
  /*  box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25);*/
  /*}*/

  /* active 클래스 스타일을 더 명확하게 처리 */
  .sidebar button.nav-link.active {
    background: linear-gradient(to right, var(--primary-color), #6977ff) !important;
    color: white !important;
    box-shadow: 0 6px 15px rgba(84, 104, 255, 0.25) !important;
  }

  /* hover, active 상태에서 버튼을 더 명확하게 구분 */
  .sidebar button.nav-link {
    transition: transform 0.2s ease, box-shadow 0.2s ease; /* 부드러운 효과 추가 */
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
    const currentPath = window.location.pathname;
    const buttons = document.querySelectorAll('.sidebar button.nav-link');

    // 모든 버튼에서 active 클래스 제거
    buttons.forEach(button => {
      button.classList.remove('active');
    });

    // 마이페이지 첫 진입시 처리
    if (currentPath === '/mypage' || currentPath === '/mypage/') {
      // 나의 여행 일정 버튼 찾아서 활성화
      buttons.forEach(button => {
        const form = button.closest('form');
        if (form && form.action.includes('/mypage/history')) {
          button.classList.add('active');
        }
      });
    } else {
      // 다른 페이지의 경우 해당 경로의 버튼 활성화
      buttons.forEach(button => {
        const form = button.closest('form');
        if (form && form.action.includes(currentPath)) {
          button.classList.add('active');
        }
      });
    }

    // 클릭 시 로딩 표시 추가
    buttons.forEach(button => {
      button.addEventListener('click', function() {
        this.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Loading...';
      });
    });
  });
</script>
