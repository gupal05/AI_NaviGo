<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
<style>
  .card-img-custom { width: 100%; height: 212px; object-fit: cover; }
  .card-link { color: inherit; text-decoration: none; }
  .filter-btn { margin: 5px; }
</style>


<div class="row row-cols-1 row-cols-md-3 g-4">
  <c:forEach var="item" items="${courseItems}">
    <div class="col">
      <a href="${pageContext.request.contextPath}/main/recommend/detail?contentid=${item.contentid}&contenttypeid=${item.contenttypeid}&title=${item.title}" class="card-link">
        <div class="card">
          <c:choose>
            <c:when test="${not empty item.firstimage2}">
              <img src="${item.firstimage2}" class="card-img-top" alt="${item.title}" style="height:200px; object-fit:cover;">
            </c:when>
            <c:otherwise>
              <img src="/images/no-image.jpg" class="card-img-top" alt="no image" style="height:200px; object-fit:cover;">
            </c:otherwise>
          </c:choose>
          <div class="card-body">
            <h5 class="card-title">${item.title}</h5>
            <p class="card-text">${item.addr1}</p>
          </div>
        </div>
      </a>
    </div>
  </c:forEach>
  <!-- chatbot 포함 -->
  <jsp:include page="/WEB-INF/views/mypage/chatbot.jsp" />
</div>
