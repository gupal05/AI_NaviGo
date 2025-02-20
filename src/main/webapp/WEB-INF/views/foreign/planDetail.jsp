<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>여행 일정 상세</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/foreign/planDetail.css"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <script src="https://kit.fontawesome.com/3789e6110d.js" crossorigin="anonymous"></script>

</head>
<body>
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>
<div class="container">
    <div class="plan-header">
        <h2>${plan.destination} 여행 일정</h2>
        <p><i class="fa-solid fa-calendar-days"></i> ${plan.startDate} - ${plan.endDate}</p>
    </div>

    <div class="content-wrapper">
        <div class="schedule-list">
            <c:forEach items="${schedules}" var="schedule">
                <div class="day-schedule">
                    <div class="day-header">
                        <h3>${schedule.scheduleDate} ${schedule.dayNumber} 일차</h3>
                    </div>

                    <c:forEach items="${schedule.activities}" var="activity">
                        <div class="activity-item"
                             data-lat="${activity.latitude}"
                             data-lng="${activity.longitude}"
                             data-place-name="${activity.placeName}">
                            <div class="activity-time">${activity.visitTime}</div>
                            <div class="activity-type">
                                <c:choose>
                                    <c:when test="${activity.activityType eq 'attraction'}">관광지</c:when>
                                    <c:when test="${activity.activityType eq 'hotel'}">호텔</c:when>
                                    <c:when test="${activity.activityType eq 'restaurant'}">식사</c:when>
                                    <c:otherwise>${activity.activityType}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="activity-details">
                                <div class="activity-name">${activity.placeName}</div>
                                <div class="activity-duration">소요시간: ${activity.duration}분</div>
                                <c:if test="${not empty activity.notes}">
                                    <div class="activity-notes">${activity.notes}</div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:forEach>
        </div>

        <div class="map-container">
            <div id="map"></div>
            <div class="filter-container">
                <div class="filter-title">일정 날짜</div>
                <div id="day-filters">
                    <!-- JavaScript로 동적 생성 된다! -->
                </div>
            </div>
        </div>
    </div>
</div>
<script async defer src="https://maps.googleapis.com/maps/api/js?key=${apikey}&callback=initMap"></script>
<script>
    let map;
    let markers = [];
    let currentInfoWindow = null;
    let locations = [];

    // 14일간의 마커 색상 배열
    const markerColors = [
        '#4CAF50',  // 초록
        '#FDD835',  // 노랑
        '#F44336',  // 빨강
        '#2196F3',  // 파랑
        '#9C27B0',  // 보라
        '#FF9800',  // 주황
        '#795548',  // 갈색
        '#607D8B',  // 회색
        '#E91E63',  // 분홍
        '#00BCD4',  // 청록
        '#8BC34A',  // 연두
        '#FF5722',  // 진주황
        '#673AB7',  // 진보라
        '#009688'   // 터키블루
    ];

    // 활동 데이터를 JavaScript 배열로 변환
    <c:forEach items="${schedules}" var="schedule">
        <c:forEach items="${schedule.activities}" var="activity">
        locations.push({
            lat: ${activity.latitude},
            lng: ${activity.longitude},
            title: "${activity.placeName}",
            time: "${activity.visitTime}",
            type: "${activity.activityType}",
            duration: "${activity.duration}분",
            dayNumber: ${schedule.dayNumber}
        });
        </c:forEach>
    </c:forEach>

    function createDayFilters() {
        const filterContainer = document.getElementById('day-filters');
        const uniqueDays = [...new Set(locations.map(loc => loc.dayNumber))].sort((a, b) => a - b);

        uniqueDays.forEach(day => {
            const dayLabel = document.createElement('label');
            dayLabel.className = 'day-label';

            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.className = 'day-checkbox';
            checkbox.value = day;
            checkbox.checked = day === 1; // 첫째 날만 기본 선택

            const colorIndicator = document.createElement('span');
            colorIndicator.className = 'day-color-indicator';
            colorIndicator.style.backgroundColor = markerColors[day - 1];

            const text = document.createElement('span');
            text.textContent = day + ` 일차`;

            dayLabel.appendChild(checkbox);
            dayLabel.appendChild(colorIndicator);
            dayLabel.appendChild(text);
            filterContainer.appendChild(dayLabel);

            checkbox.addEventListener('change', updateMarkerVisibility);
        });
    }

    function updateMarkerVisibility() {
        const selectedDays = Array.from(document.querySelectorAll('.day-checkbox:checked'))
            .map(cb => parseInt(cb.value));

        markers.forEach((marker, index) => {
            const dayNumber = locations[index].dayNumber;
            marker.setVisible(selectedDays.includes(dayNumber));
        });
    }

    function initMap() {
        console.log('Initializing map...');

        map = new google.maps.Map(document.getElementById('map'), {
            zoom: 17,
            mapTypeControl: true,
            streetViewControl: true,
            fullscreenControl: true
        });

        const bounds = new google.maps.LatLngBounds();

        locations = locations.filter(location => {
            if(location.lat === 0 && location.lng === 0) {
                console.log(`${location.title}: 좌표 정보 없음`);
                return false;
            }
            return true;
        })

        locations.forEach((location, index) => {
            // 일차에 해당하는 색상 선택 (1부터 시작하므로 -1)
            const colorIndex = location.dayNumber - 1;
            const markerColor = markerColors[colorIndex];

            // SVG 마커 생성
            const markerSvg = {
                path: google.maps.SymbolPath.CIRCLE,
                fillColor: markerColor,
                fillOpacity: 1,
                strokeWeight: 1,
                strokeColor: '#FFFFFF',
                scale: 10
            };

            const marker = new google.maps.Marker({
                position: { lat: location.lat, lng: location.lng },
                map: map,
                title: location.title,
                icon: markerSvg,
                visible: location.dayNumber === 1 // 첫째 날만 기본 표시
            });

            const infoWindow = new google.maps.InfoWindow({
                content: location.title
            });

            marker.addListener('click', () => {
                if (currentInfoWindow) {
                    currentInfoWindow.close();
                }
                infoWindow.open(map, marker);
                currentInfoWindow = infoWindow;
            });

            markers.push(marker);
            bounds.extend(marker.getPosition());
        });

        if (markers.length > 0) {
            map.fitBounds(bounds);
        }

        // 일차별 필터 생성
        createDayFilters();
    }

    $(document).ready(function() {
        $('.activity-item').each(function(index) {
            $(this).hover(
                function() {
                    if (markers[index]) {
                        markers[index].setAnimation(google.maps.Animation.BOUNCE);
                    }
                },
                function() {
                    if (markers[index]) {
                        markers[index].setAnimation(null);
                    }
                }
            );

            $(this).click(function() {
                if (markers[index]) {
                    google.maps.event.trigger(markers[index], 'click');
                    map.panTo(markers[index].getPosition());
                }
            });
        });
    });

    $(document).ready(function() {
        $.ajax({
            url: '/foreign/plan/${plan.planId}/photos',
            type: 'GET',
            success: function(response) {
                if (response.success) {
                    $('.activity-item').each(function() {
                        const placeName = $(this).data('place-name');
                        const photoUrl = response.photos[placeName];

                        if (photoUrl) {
                            const imgElement = $('<img>')
                                .addClass('place-photo')
                                .attr('src', photoUrl)
                                .attr('alt', placeName + ' 사진');

                            $(this).append(imgElement);
                        }
                    });
                }
            },
            error: function(xhr, status, error) {
                console.error("사진 로딩 중 오류 발생:", error);
            }
        });
    });
</script>
</body>
</html>