<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>추천 문화축제</title>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommended/travelCard.css"/>
    <script>
        // recordClick 함수는 그대로 유지
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
    <style>
        /* 필요에 따라 스타일 추가 */
    </style>
</head>
<body>
<%--<div class="container mt-5 text-center">--%>
<%--    <h2 class="fw-bold">문화/축제</h2>--%>
<%--    <p class="text-muted">--%>
<%--        전국의 문화/축제 행사를 추천해 드립니다.--%>
<%--    </p>--%>
<%--</div>--%>
<div class="container section-header">
    <h2 class="fw-bold">문화/축제</h2>
    <p class="text-muted">
        전국의 문화/축제 행사를 추천해 드립니다.
    </p>
</div>

<div class="container" id="festivalContainer">

    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
        <c:forEach var="festival" items="${festivals}">
            <c:set var="detailUrl" value="${pageContext.request.contextPath}/main/recommend/detail?contentid=${festival.contentid}&contenttypeid=${festival.contenttypeid}&title=${festival.title}" />
            <div class="col">
                <a href="${detailUrl}" class="card-link"
                   data-contentid="${festival.contentid}"
                   data-contenttypeid="${festival.contenttypeid}"
                   data-title="${festival.title}"
                   onclick="recordClick('${festival.contentid}', '${festival.cat1}', '${festival.cat2}', '${festival.cat3}', '${festival.title}');">
                    <div class="card h-100">
                        <img src="${festival.firstimage}" class="card-img-top card-img-custom" alt="${festival.title}">
                        <div class="card-body">
                            <span class="badge bg-danger mb-2">행사 및 축제</span>
                            <h5 class="card-title">${festival.title}</h5>
                            <p class="card-text text-muted">
                                   기간: ${festival.eventstartdate} ~ ${festival.eventenddate}
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

<!-- 로딩 인디케이터 -->
<div id="loading" style="display:none; text-align:center;">
    <img src="${pageContext.request.contextPath}/images/loading.gif" alt="로딩중...">
</div>

<script>
    var currentPage = 2; // 첫 페이지는 이미 렌더링됨
    var loading = false;
    var noMoreData = false;
    var pageSize = 9;
    var maxPage = 6; // 최대 6페이지 (즉, 추가 로드는 5번만 수행)
    var scrollTimeout;

    $(window).scroll(function() {
        if (scrollTimeout) { clearTimeout(scrollTimeout); }
        scrollTimeout = setTimeout(function() {
            // 문서 하단 100px 이내에 도달하면 호출
            if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
                if (!loading && !noMoreData) {
                    // 최대 페이지 도달 시 추가 호출 중단
                    if (currentPage > maxPage) {
                        noMoreData = true;
                        return;
                    }
                    loading = true;
                    $("#loading").show();

                    $.ajax({
                        url: '${pageContext.request.contextPath}/main/recommended/festivalAjax',
                        type: 'GET',
                        data: { page: currentPage },
                        dataType: 'json',
                        success: function(data) {
                            if (data.length === 0) {
                                noMoreData = true;
                            } else {
                                $.each(data, function(index, festival) {
                                    var html = '<div class="col">' +
                                        '<a href="' + '${pageContext.request.contextPath}' + '/main/recommend/detail?contentid=' + festival.contentid +
                                        '&contenttypeid=' + festival.contenttypeid + '&title=' + encodeURIComponent(festival.title) + '" class="card-link" ' +
                                        'data-contentid="' + festival.contentid + '" ' +
                                        'data-contenttypeid="' + festival.contenttypeid + '" ' +
                                        'data-title="' + festival.title + '" ' +
                                        'onclick="recordClick(\'' + festival.contentid + '\', \'' + festival.cat1 + '\', \'' + festival.cat2 + '\', \'' + festival.cat3 + '\', \'' + festival.title + '\');">' +
                                        '<div class="card h-100">' +
                                        '<img src="' + festival.firstimage + '" class="card-img-top card-img-custom" alt="' + festival.title + '">' +
                                        '<div class="card-body">' +
                                        '<span class="badge bg-danger mb-2">행사 및 축제</span>' +
                                        '<h5 class="card-title">' + festival.title + '</h5>' +
                                        '<p class="card-text text-muted">' + festival.eventstartdate + ' ~ ' + festival.eventenddate + '</p>' +
                                        '<p class="card-text"><small class="text-muted">주소: ' + festival.addr1 + '</small></p>' +
                                        '<p class="card-text"><small class="text-muted">전화번호: ' + festival.tel + '</small></p>' +
                                        '</div></div></a></div>';
                                    $("#festivalContainer .row").append(html);
                                });
                                currentPage++;
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error("데이터 로드 오류:", error);
                        },
                        complete: function() {
                            loading = false;
                            $("#loading").hide();
                        }
                    });
                }
            }
        }, 200); // 200ms 디바운스
    });
</script>
</body>
</html>
