<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${not empty courseItems}">
  <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
    <c:forEach var="courseItem" items="${courseItems}" varStatus="status">
      <c:if test="${status.index lt 6}">
        <div class="col">
          <c:set var="title" value="${courseItem.title}" />
          <c:set var="contentid" value="${courseItem.contentid}" />
          <c:set var="cat1" value="${courseItem.cat1}" />
          <c:set var="cat2" value="${courseItem.cat2}" />
          <c:set var="cat3" value="${courseItem.cat3}" />
          <c:set var="addr1" value="${courseItem.addr1}" />
          <c:set var="contenttypeid" value="${courseItem.contenttypeid}" />
          <c:set var="firstimage" value="${courseItem.firstimage}" />
          <c:set var="detailUrl" value="${pageContext.request.contextPath}/recommend/detail?contentid=${contentid}&contenttypeid=${contenttypeid}&title=${fn:escapeXml(title)}" />
          <div class="card h-100">
            <a href="${detailUrl}" class="card-link" onclick="recordClick('${contentid}', '${cat1}', '${cat2}', '${cat3}', '${title}');">
              <div class="card h-100">
                <img src="${firstimage}" class="card-img-top card-img-custom" alt="${title}" />
                <div class="card-body">
                  <span class="badge bg-success mb-2">여행코스</span>
                  <h5 class="card-title">${title}</h5>
                  <p class="card-text">${addr1}</p>
                </div>
              </div>
            </a>
          </div>
        </div>
      </c:if>
    </c:forEach>
  </div>
</c:if>
<c:if test="${empty courseItems}">
  <div class="row">
    <div class="col">
      <p class="text-center">검색 결과가 없습니다.</p>
    </div>
  </div>
</c:if>
