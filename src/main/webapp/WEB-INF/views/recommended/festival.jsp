<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>추천 문화축제</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
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
    </style>
    <script>
        // recordClick 함수에 title 매개변수를 추가하여 전송
        function recordClick(contentid, cat1, cat2, cat3, title) {
            fetch('/recordClick', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ contentid: contentid, cat1: cat1, cat2: cat2, cat3: cat3, title: title })
            })
                .then(response => response.text())
                .then(data => console.log("Click recorded:", data))
                .catch(err => console.error("Error:", err));
        }
    </script>
</head>
<body>
<!-- AI 맞춤 추천 타이틀 -->
<div class="container mt-5 text-center">
    <h2 class="fw-bold">문화/축제</h2>
    <p class="text-muted">
        전국의 문화/축제 행사를 추천해 드립니다.
    </p>
</div>
<br>
<div class="container">
    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
        <c:forEach var="festival" items="${festivals}" begin="0" end="5">
            <c:set var="detailUrl" value="recommend/detail?contentid=${festival.contentid}&contenttypeid=${festival.contenttypeid}&title=${festival.title}" />
            <div class="col">
                <a href="${detailUrl}" class="card-link"
                   onclick="recordClick('${festival.contentid}', '${festival.cat1}', '${festival.cat2}', '${festival.cat3}', '${festival.title}');">
                    <div class="card h-100">
                        <img src="${festival.firstimage}" class="card-img-top card-img-custom" alt="${festival.title}">
                        <div class="card-body">
                            <span class="badge bg-danger mb-2">행사 및 축제</span>
                            <h5 class="card-title">${festival.title}</h5>
                            <p class="card-text text-muted">
                                    ${festival.eventstartdate} ~ ${festival.eventenddate}
                            </p>
                            <p class="card-text"><small class="text-muted">주소: ${festival.addr1}</small></p>
                            <p class="card-text"><small class="text-muted">전화번호: ${festival.tel}</small></p>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
