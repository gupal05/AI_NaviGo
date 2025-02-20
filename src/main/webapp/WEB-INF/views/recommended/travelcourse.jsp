<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
                        <div class="card">
                            <c:choose>
                                <c:when test="${not empty item.firstimage2}">
                                    <img src="${item.firstimage2}" class="card-img-top" alt="${item.title}" style="height:200px; object-fit:cover;" />
                                </c:when>
                                <c:otherwise>
                                    <img src="/images/no-image.jpg" class="card-img-top" alt="no image" style="height:200px; object-fit:cover;" />
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

<script>
    document.addEventListener("DOMContentLoaded", function () {
        console.log("✅ DOMContentLoaded 실행됨");

        const contextPath = "${pageContext.request.contextPath}";

        // 필터 버튼 이벤트 리스너 추가
        document.body.addEventListener("click", function (event) {
            if (event.target.classList.contains("filter-btn")) {
                event.preventDefault();
                console.log("🎉 필터 버튼 클릭됨:", event.target);

                const tc = event.target.getAttribute("data-tc");
                const url = contextPath + "/main/recommended/courseAjax?tc=" + tc;

                console.log("📡 AJAX 요청 URL:", url);

                fetch(url)
                    .then(response => response.json())
                    .then(data => {
                        console.log("📡 AJAX 응답 데이터:", data);
                        renderCourseCards(data);
                    })
                    .catch(err => console.error("❌ AJAX 요청 오류:", err));
            }
        });

        // 여행지 상세 페이지로 이동
        document.body.addEventListener("click", function (event) {
            if (event.target.closest(".card-link")) {
                event.preventDefault();
                const link = event.target.closest(".card-link");
                const contentid = link.getAttribute("data-contentid");
                const contenttypeid = link.getAttribute("data-contenttypeid");
                const title = encodeURIComponent(link.getAttribute("data-title"));

                const detailUrl = `${contextPath}/main/recommend/detail?contentid=${contentid}&contenttypeid=${contenttypeid}&title=${title}`;
                console.log("🔗 이동할 URL:", detailUrl);
                window.location.href = detailUrl;
            }
        });
    });

    function renderCourseCards(courseItems) {
        let html = '<div class="row row-cols-1 row-cols-md-3 g-4">';
        courseItems.forEach(item => {
            let imageHtml = item.firstimage2
                ? `<img src="${item.firstimage2}" class="card-img-top" alt="${item.title}" style="height:200px; object-fit:cover;">`
                : `<img src="/images/no-image.jpg" class="card-img-top" alt="no image" style="height:200px; object-fit:cover;">`;

            html += `<div class="col">
                <a href="#" class="card-link" data-contentid="${item.contentid}" data-contenttypeid="${item.contenttypeid}" data-title="${item.title}">
                    <div class="card">${imageHtml}
                        <div class="card-body">
                            <h5 class="card-title">${item.title}</h5>
                            <p class="card-text">${item.addr1}</p>
                        </div>
                    </div>
                </a>
            </div>`;
        });
        html += '</div>';
        document.getElementById("courseSection").innerHTML = html;
    }
</script>
