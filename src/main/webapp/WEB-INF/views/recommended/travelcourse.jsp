<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .card-img-custom {
        width: 100%;
        height: 212px;
        object-fit: cover;
    }
    .card-link {
        color: inherit;
        text-decoration: none;
    }
    .card-body {
        text-align: center;
    }
    .card-title {
        font-size: 1.1rem;
        font-weight: bold;
        margin-bottom: 0.5rem;
    }
    .card-text {
        font-size: 0.9rem;
        color: #666;
    }
</style>

<div class="container mt-5 text-center">
    <h2 class="fw-bold">여행코스 추천</h2>
    <p class="text-muted">아래 버튼을 눌러 원하는 코스를 선택하세요.</p>
    <div>
        <button type="button" class="btn btn-outline-primary filter-btn" data-tc="C01120001">가족코스</button>
        <button type="button" class="btn btn-outline-primary filter-btn" data-tc="C01130001">나홀로코스</button>
        <button type="button" class="btn btn-outline-primary filter-btn" data-tc="C01140001">힐링코스</button>
        <button type="button" class="btn btn-outline-primary filter-btn" data-tc="C01150001">도보코스</button>
        <button type="button" class="btn btn-outline-primary filter-btn" data-tc="C01160001">캠핑코스</button>
        <button type="button" class="btn btn-outline-primary filter-btn" data-tc="C01170001">맛코스</button>
    </div>
</div>
<br>
<div class="container">
    <div id="courseSection">
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <c:forEach var="item" items="${courseItems}">
                <div class="col">
                    <a href="#" class="card-link" data-contentid="${item.contentid}" data-contenttypeid="${item.contenttypeid}" data-title="${item.title}">
                        <div class="card h-100">
                            <c:choose>
                                <c:when test="${not empty item.firstimage}">
                                    <img src="${item.firstimage}" class="card-img-top card-img-custom" alt="${item.title}" />
                                </c:when>
                                <c:otherwise>
                                    <img src="/images/no-image.jpg" class="card-img-top card-img-custom" alt="no image" />
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
        </div>
    </div>
</div>
